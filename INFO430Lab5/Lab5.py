import pyodbc
import requests as r
from bs4 import BeautifulSoup as bs
## import ODBC
cnxn = pyodbc.connect('DRIVER={ODBC Driver 13 for SQL Server};SERVER=IS-HAY04.ischool.uw.edu;DATABASE=rosem15_BookDB;UID=info430;PWD=GoHuskies!;autocommit=True')
curr = cnxn.cursor()
print("done connecting")
domain = 'http://books.toscrape.com'
frontPage = r.get(domain)
frontPageScrape = bs(frontPage.content, 'html.parser')
pageInfo = frontPageScrape.find('form', class_='form-horizontal')
## how to run stored procedure in python - refer to slides
print(pageInfo)
##  titles, prices, descriptions, and genres
titles = []
prices = []
des = []
genres = []
page =  range(1, 51)
urls = []
for i in page:
    urls.append("http://books.toscrape.com/catalogue/page-"+ str(i) + ".html")
print(urls)
newlink = []
for i in urls:
    front = r.get(i)
    rScrape = bs(front.content, 'html.parser')
    internal = rScrape.find_all('div', class_="image_container")
    for c in internal:
        newlink.extend(c.find_all('a', href = True))
print(len(newlink))
finalURL = [];
for i in newlink:
    finalURL.append(i['href'])
    print(finalURL)
    count = 1
for i in finalURL:
    temp = r.get("http://books.toscrape.com/catalogue/" + i)
    book = bs(temp.content, 'html.parser')
    titles.append(book.find('h1').text)
    prices.append(book.find('p', class_ = 'price_color').text)
    des.append(book.find_all('p')[3].text)
    genres.append(book.find('ul', class_ = 'breadcrumb').findChildren()[5].text)
    print(count)
    count = count + 1


all = list(zip(titles, prices,des, genres))
for i in all:
    print(i)

print(len(all))
print("done")
# totalResults = int(pageInfoChildren[1].text)
# perPage = int(PageInfoChildren[3].text)
# totalPages = int(totalResults / perPage)
#
# links = []
#
# for pageURL in [domain + 'catalogue/page~' + str(i) + '.html' for i in range(1, totalPages + 1)]:
#     page = r.get(pageURL)
#     pageScrape = bs(page.content, 'html.parser')
#
#     container = pageScrape.select('h3 a')
#
#     links.extend([domain + 'catalogue/' + i ['href'] for i in container])



#sql


insertBook = """
SET NOCOUNT ON; 
EXECUTE [dbo].[rosem15usp_insertBook]
@bookTitle = ?, 
@bookPrice = ?,
@bookDesc = ?,
@genreName = ?
"""
for i in all:
    bookTitle = i[0]
    bookPrice = i[1]
    bookDescr = i[2]
    genre = i[3]
    print(bookTitle, bookPrice, bookDescr, genre)
    params = (bookTitle, bookPrice, bookDescr, genre)
    curr.execute(insertBook, params)
cnxn.commit()
