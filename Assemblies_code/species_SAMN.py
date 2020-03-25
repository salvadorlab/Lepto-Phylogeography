import xml.etree.ElementTree as ET

# https://docs.python.org/2/library/xml.etree.elementtree.html

def main():
    
    path = "/Users/rx32940/Dropbox/5.Rachel-projects/Phylogeography/Lepto_assemblies_V2/ncbi_assemblies/"
    doc = ET.parse(path + "biosample_result-2.xml") # xml object, biosample result file downloaded directly from ncbi with all_assemblies list
    root = doc.getroot() # get the root element
    
    with open(path + "ncbi_assemblies_species.txt","w") as f:
        f.write("")
        
    for des in root.findall("BioSample"):
        SAMN_id = des.attrib["accession"]
        organisms_name = des.find("Description").find("Organism").attrib["taxonomy_name"] # access nested nodes
        id_name = SAMN_id + "," + organisms_name + "\n"
    
        with open(path + "ncbi_assemblies_species_species.txt","a+") as f:
            f.write(id_name)

    


if __name__ == "__main__":
    main()