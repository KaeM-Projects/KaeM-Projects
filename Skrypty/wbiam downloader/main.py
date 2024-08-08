import os
import glob
import codecs
import re
from pywebcopy import save_webpage
import shutil
import time
from tqdm import tqdm
import warnings
from pathlib import Path

file = open("log.txt", "w")
file2 = open("link_list.txt", "w")
file.write("log messages for wbijam.pl sites downloader\n\n")
file.flush()
file2.write("Link list for all finded player sites:")
file2.flush()
temporary_folder = '..\\temp'

all_info = {}
series_list = []

series_pattern = r'.*?\\(.*wbijam.pl).*'
link_pattern = r'.*?rel=\"(.*)\".*'
series_name_pattern = r'.*?(.*).wbijam.pl'
eq_issue_pattern = r'(.*?)=*?.html'


def copy_all(src_directory,dst_directory):
    file_list = list(Path(src_directory).rglob("*.*"))
    for i in tqdm(range(len(file_list)), desc="Files copying: ", bar_format="\033[1;31m{desc} [{bar}]\033[m {percentage:3.0f}%|{n_fmt}/{total_fmt} [{elapsed}<{remaining}] | IPS: {rate_fmt}"):
        item = file_list[i]
        src_file_path = Path(item)
        dst_file_path = os.fspath(src_file_path).replace(src_directory,dst_directory)
        if os.path.exists(dst_file_path):
            pass
        else:
            folder_path = dst_file_path.replace(os.path.basename(dst_file_path),'')
            if not os.path.exists(folder_path):
                os.makedirs(folder_path)
            shutil.copy(src_file_path, dst_file_path)

def wait_for_file(path):
    i = 0
    while not os.path.exists(path):
        time.sleep(1)
        i = i+1
        if i > 20: raise "File doesn't exist"
    return


def find_allplayers_links():
    linklist = []
    prev_series_name = ''
    for html in glob.glob('./**/*.html', recursive=True):
        series_name_link = (re.search(series_pattern, str(html))).group(1)
        series_name = re.search(series_name_pattern, series_name_link).group(1)
        if series_name != prev_series_name:
            print("Finded serie name: " + series_name)
            series_list.append(series_name)
            linklist = []
            file2.write("\n\nLinks for: " + series_name + "\n")
            file2.flush()
        prev_series_name = series_name
        file_html = codecs.open(html, 'r', encoding='utf-8')
        lines = file_html.readlines()
        for idx, line in enumerate(lines):
            if "odtwarzacz_link" in line:
                player_line = line
                match = re.search(link_pattern, player_line)
                site_link = match.group(1)
                file2.write("https://" + series_name_link + "/odtwarzacz-" + site_link + ".html\n")
                file2.flush()
                linklist.append(site_link)
        all_info['series_name'] = series_list
        all_info[series_name] = {'series_link':  series_name_link, 'link_list':  linklist}
    return



def download_sites(series_name, download_folder):
    err_cnt = 0
    actual_series = all_info[series_name]
    kwargs = {'bypass_robots': True, 'project_name': '', 'open_in_browser': False, 'threaded': True, 'debug': False,}
    actual_series_link = actual_series['series_link']
    downloading_path = os.path.join(download_folder, "https_"+actual_series_link).replace("\\","/")
    #print("Downloading sites for: " + series_name)
    file.write("log messages due downloading \"" + series_name +"\":\n")
    file.flush()

    #for link in actual_series['link_list']:
    for i in tqdm(range(len(actual_series['link_list'])), desc = "Downloading sites for: " + series_name, bar_format="\033[1;31m{desc} [{bar}]\033[m {percentage:3.0f}%|{n_fmt}/{total_fmt} [{elapsed}<{remaining}] | IPS: {rate_fmt}"):
        link = actual_series['link_list'][i]
        filename = "odtwarzacz-" + link + ".html"
        site_link = "https://" + actual_series_link + "/" + filename
        try:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                save_webpage(site_link, download_folder, **kwargs)
        except:
            file.write("Fail to download site: "+site_link+"\n")
            file.flush()
            err_cnt = err_cnt + 1
        if '=.html' in site_link:
            beg_of_link = re.search(eq_issue_pattern, filename)
            folder_path = os.path.join(downloading_path, actual_series_link)
            path_wrongfile = os.path.abspath(os.path.join(folder_path,beg_of_link.group(1)+'_.html'))#.replace("\\","/")
            path_file = os.path.abspath(os.path.join(folder_path, filename))
            try:
                wait_for_file(os.path.normpath(path_wrongfile))
                os.rename(os.path.normpath(path_wrongfile), os.path.normpath(path_file))
            except:
                file.write("File " + path_wrongfile + " doesn't exist -> SKIPPED\n")
                file.flush()
                err_cnt = err_cnt + 1
        else:
            pass

    to_directory = "./"
    copy_all(downloading_path , to_directory)
    shutil.rmtree(download_folder)
    return err_cnt


find_allplayers_links()

#for j in tqdm(range(len(all_info['series_name'])), desc = "Progress of all jobs: ",leave=False):
i = 0
for series_name in all_info['series_name']:
    i = i+1
    #download_sites(all_info['series_name'][j], temporary_folder)
    print("Downloading of \033[1;31m" + series_name + "\033[m sites complete with ", download_sites(series_name, temporary_folder), "issues. \033[1;31m" + str(len(series_list) - i) + "\033[m Left to download")
    #print(download_sites(series_name, temporary_folder))



file.close()
file2.close()
print("Finished - all jobs completed")


