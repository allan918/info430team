import requests as r
from bs4 import BeautifulSoup as bs
## import ODBC

domain = 'http://books.toscrape.com'


frontPage = r.get(domain)
frontPageScrape = bs(frontPage.content, 'html.parser')
pageInfo = frontPageScrape.find('form', class_='form-horizontal').findChildren("strong", recursive = False).text

total = int(pageInfo[0])
perpage = int(pageInfo[2]) - (pageInfo[1])
print(total, perpage)
#pageInfoChildren = pageInfo.findChildren(1)
## how to run stored procedure in python - refer to slides
# print("-----------")
# print(pageInfo)

# totalResults = int(pageInfo[3].text)
# perPage = int(pageInfo[7].text) - int(pageInfo[5].text)
# totalPages = int(totalResults / perPage)
# print(totalResults, perPage, totalPages)

# links = []

# for pageURL in [domain + 'catalogue/page~' + str(i) + '.html' for i in range(1, totalPages + 1)]:
#     page = r.get(pageURL)
#     pageScrape = bs(page.content, 'html.parser')
#     container = pageScrape.select('h3 a')
#     links.extend([domain + 'catalogue/' + i ['href'] for i in container])