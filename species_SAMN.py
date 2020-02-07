import xml.etree.ElementTree as ET

# https://docs.python.org/2/library/xml.etree.elementtree.html

def main():
    
    path = "/Users/rx32940/Downloads/"
    doc = ET.parse(path + "biosample_result-3.xml") # xml object, biosample result file downloaded directly from ncbi with all_assemblies list
    root = doc.getroot() # get the root element
    
    with open(path + "SAMN_Organism_1209.txt","w") as f:
        f.write("")
        
    for des in root.findall("BioSample"):
        SAMN_id = des.attrib["accession"]
        organisms_name = des.find("Description").find("Organism").attrib["taxonomy_name"] # access nested nodes
        id_name = SAMN_id + "," + organisms_name + "\n"
    
        with open(path + "SAMN_Organism_1209.txt","a+") as f:
            f.write(id_name)

    


if __name__ == "__main__":
    main()