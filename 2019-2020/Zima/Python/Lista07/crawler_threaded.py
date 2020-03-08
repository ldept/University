import re
import urllib.request
from bs4 import BeautifulSoup as Soup
from bs4 import Comment
from nltk import tokenize

import concurrent.futures
import threading

def is_url(url):
    if isinstance(url, str):
        http = re.compile('http')
        return http.match(url) #string in string / find
    else:
        return False

def tag_visible(element):
    if element.parent.name in ['style', 'script', 'head', 'title', 'meta', '[document]']:
        return False
    if isinstance(element,Comment):
        return False
    return True


def text_from_html(body):
    soup = Soup(body, 'html.parser')
    texts = soup.findAll(text=True)
    visible_texts = filter(tag_visible, texts)  
    return u" ".join(t.strip() for t in visible_texts)
    

def extract_text(text):
    #regex = re.compile("[^.]* Python [^.]*(\.|\!|\?)")
    return [sentence for sentence in text if 'Python' in sentence]

def find_sentences_with_python(site):
    try:
        url = urllib.request.urlopen(site).read().decode('utf-8')
    except:
        return ""
    html = Soup(url,'html.parser')
    text = html.body.find_all(text=True)#re.compile(r"([^.]*?Python[^.]*\.)"))
    #text = text_from_html(url)
    return extract_text(text)
    #return txt
def find_first_not_visited(links_list, visited_sites):
    for link in links_list:
        if link not in visited_sites: #set 
            return link

def extract_links_from_a_tags(src_a_tags_list, dst_links_list):
    for a_tag in src_a_tags_list:
        url = a_tag.get('href')
        if is_url(url):
            dst_links_list.append(url)


def crawl_threaded(start_page, distance, action):
    visited_sites = set() # set would be faster
    yield (start_page, action(start_page))
    visited_sites.add(start_page) # visited_sites.add
    

    start_site = urllib.request.urlopen(start_page).read()
    html = Soup(start_site,'html.parser')
    a_tags_list = html.find_all('a')
    links_list = []
    extract_links_from_a_tags(a_tags_list, links_list)
    links_to_visit = set(links_list)
    if start_page in links_to_visit:
        links_to_visit.remove(start_page)
    links_to_visit = list(links_to_visit)
    links_to_visit.sort()
    #links_to_visit = list(set([link for link in links_list if link not in visited_sites]))
    links_to_visit = links_to_visit[:distance-1]
    
    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        future_site = {executor.submit(action,link): link for link in links_to_visit}
        for future in concurrent.futures.as_completed(future_site):
            yield (future_site[future], future.result())
        # executor.map(action, links_to_visit)
         
    # while(n_of_visited < distance):
    #     link_to_visit = find_first_not_visited(links_list,visited_sites)
    #     yield(link_to_visit,action(link_to_visit))
    #     visited_sites.add(link_to_visit)
    #     n_of_visited += 1
        

def crawl(start_page, distance, action):
    visited_sites = set() # set would be faster
    yield (start_page, action(start_page))
    visited_sites.add(start_page) # visited_sites.add
    
    start_site = urllib.request.urlopen(start_page).read()
    html = Soup(start_site,'html.parser')
    a_tags_list = html.find_all('a')
    links_list = []
    extract_links_from_a_tags(a_tags_list, links_list)

    links_to_visit = set(links_list)
    if start_page in links_to_visit:
        links_to_visit.remove(start_page)
    links_to_visit = list(links_to_visit)
    links_to_visit.sort()
    links_to_visit = links_to_visit[:distance-1]
    for link in links_to_visit:
        yield(link, action(link))
import time 
t1 = time.perf_counter()
it = crawl_threaded('https://www.python.org',4,find_sentences_with_python)
for i in it:
    print(1)
t2 = time.perf_counter()

print(f'Finished in {t2-t1} second(s) \n')

t1 = time.perf_counter()
it = crawl('https://www.python.org',4,find_sentences_with_python)
for i in it:
    print(0)
t2 = time.perf_counter()
print(f'Finished in {t2-t1} second(s) \n')