<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Pour produire un document valide en XHTML -->
    <xsl:output method="html" 
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
        indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Informations associées aux Auteurs</title>
                <link rel="stylesheet" type="text/css" href="auteurs.css"></link>
            </head>
            <body>
                <h1>Informations associées aux Auteurs</h1>
                <!-- Un div contenant une table avec les informations sur les auteurs --> 
                <div>
                    <table id="auteurs">
                        <thead>
                            <tr>
                                <th>ID - Auteur</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Pays</th>
                                <th>Photo</th>
                                <th>Commentaire</th>
                                <th>Livres</th>
                            </tr>                          
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="bibliotheque/auteurs/auteur[contains(nom, '')]"/>
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour l'affichage des auteurs et leurs informations -->
    <xsl:template match="auteur">
        <xsl:variable name="id_auteur" select="@ident"/>
        <tr>
            <td><xsl:value-of select="@ident"/></td>
            <td><xsl:value-of select="nom"/></td>
            <td><xsl:value-of select="prenom"/></td>
            <td><xsl:value-of select="pays"/></td>
            <td><xsl:value-of select="photo"/></td>
            <td>
                <!-- Ce n'est pas tout les auteurs qui ont un élément commentaire -->
                <xsl:if test="commentaire">
                    <xsl:value-of select="commentaire"/>
                </xsl:if>
            </td>
            <td>
                <!-- On doit faire un check up si un auteur a des livres dans la bibliotheque -->
                <xsl:if test="/bibliotheque/livres/livre[contains(@auteur, $id_auteur)]">
                    <ul>
                        <xsl:apply-templates select="/bibliotheque/livres/livre[contains(@auteur, $id_auteur)]"/>
                    </ul>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>
    
    <!-- Template pour l'affichage des livres -->
    <xsl:template match="livre">
        <li>
            <xsl:value-of select="titre"/>
            <!-- &#160; c'est pour ajouter un espace vide (seulement pour l'esthétique de la page html -->
            &#160;
            <xsl:value-of select="annee"/>
        </li>
        <p>
            Prix: 
            <xsl:if test="prix/@devise">
                <xsl:value-of select="prix/@devise"/>
                <!-- &#160; c'est pour ajouter un espace vide (seulement pour l'esthétique de la page html -->
                &#160;
            </xsl:if>
            <xsl:value-of select="prix"/>
            
        </p>
    </xsl:template>
</xsl:stylesheet>











