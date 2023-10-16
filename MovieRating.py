from bs4 import BeautifulSoup
import requests, openpyxl


excel = openpyxl.Workbook()


sheet= excel.active
sheet.title = 'Top Rated Movies'
sheet.append(['Movie Rank','Movie Name','Year of Release','IMDB Rating'])



try:
    source = requests.get('https://editorial.rottentomatoes.com/guide/popular-movies/')
    source.raise_for_status()

    soup = BeautifulSoup(source.text, 'html.parser')
    
    movies = soup.find('div',class_="articleContentBody").find_all('div',class_="row countdown-item")
    


    for movie in movies:

        name = movie.find('div', class_="article_movie_title").h2.a.text

        rank = movie.find('div', class_="countdown-index").text.split('#')[1]

        year = movie.find('div', class_="article_movie_title").h2.span.text.strip('()')
    

        rating = movie.find('span', class_="tMeterScore").text
        print(rank,name,year,rating)

        sheet.append([rank,name,year,rating])


        


except Exception as e:
    print(e)

excel.save('IDBM Movie Rating.xlsx')

