# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import httpclient
import htmlparser
import xmltree  # To use '$' for XmlNode
import strtabs  # To access XmlAttributes
import os
import times
  
when isMainModule:

    var client = newHttpClient()
    # Url of the website
    let url = "https://www.giornalone.it"
  
    # Get & Parse the html of the sitemap
    let sitemap = parseHtml(client.getContent(url & "/sitemap.php"))

    # create the path where th images will be saved
    let dir = "front_pages/" & format(now(), "dd-MM-YYYY") & "/"

    # Create the result foldere where the images will be saved
    if not existsDir(dir):
      createDir(dir)
     
    # search fo all the divs in the sitemap that have the class box
    for box in sitemap.findAll("div"):
     if box.attrs.hasKey("class") and box.attrs["class"] == "box": 
      # Now search for every h2 title in those divs
      for h2 in box.findAll("h2"):
       # Get the title of the section
       let sectionTitle = innerText(h2)
       # get the section that I want
       if sectionTitle == "Quotidiani Nazionali" or sectionTitle == "Quotidiani Finanziari" or sectionTitle == "Quotidiani Esteri":
        echo "==== " & sectionTitle & " ===="
        # search all the link in it
        for a in box.findAll("a"):
        # not the home link
         if a.attrs.hasKey("href") and a.attrs["href"] != "/" :
          # get the title of the newspaper
          let nomeGiornale = innerText(a)
          # get & parse the html code of the newspaper page
          let giornale = parseHtml(client.getContent(url & a.attrs["href"]))
          # search for every image in the page that has the id 'giornale'
          for img in giornale.findAll("img"):
           if img.attrs.hasKey("id") and img.attrs["id"] == "giornale":
            # output log
            echo "Salvo " & nomeGiornale & " ✔️"
            # save the image
            writeFile(dir & nomeGiornale & ".jpg", client.getContent(url & img.attrs["src"]))
