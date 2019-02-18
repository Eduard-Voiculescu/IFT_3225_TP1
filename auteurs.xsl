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
    
    <xsl:param name="auteur" select="''"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    Informations associées 
                    <xsl:choose>
                        <xsl:when test="$auteur=''">
                            aux Auteurs
                        </xsl:when>
                        <xsl:otherwise>
                            à <xsl:value-of select="$auteur"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </title>
                <link rel="stylesheet" type="text/css" href="auteurs.css"></link>
            </head>
            <body>
                <h1>
                  Informations associées 
                  <xsl:choose>
                      <xsl:when test="$auteur=''">
                          aux Auteurs
                      </xsl:when>
                      <xsl:otherwise>
                          à <xsl:value-of select="$auteur"/>
                      </xsl:otherwise>
                  </xsl:choose>
                </h1>
                <!-- Un div contenant une table avec les informations sur les auteurs --> 
                <div>
                    <xsl:apply-templates select="bibliotheque/auteurs/auteur[contains(nom, $auteur)]"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour l'affichage des auteurs et leurs informations -->
    <xsl:template match="auteur">
        <xsl:variable name="id_auteur" select="@ident"/>
        <div class="auteurs">
            <h2>
                <xsl:value-of select="prenom"></xsl:value-of>&#160;
                <xsl:value-of select="nom"/>
            </h2>
            <xsl:if test="photo">
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="photo"/>    
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                        Photo de couverture de l'auteur(e).
                    </xsl:attribute>
                    <xsl:attribute name="width">275</xsl:attribute>
                    <xsl:attribute name="height">350</xsl:attribute>
                </img>
            </xsl:if>
            <h3>ID Auteur : <xsl:value-of select="$id_auteur"/></h3>
            <h3>Pays d'origine : <xsl:value-of select="pays"/></h3>
            <xsl:if test="commentaire">
                <p><b>Commentaire :</b> <xsl:value-of select="commentaire"/></p>
            </xsl:if>
        </div>
        <table class="livres">
            <thead>
                <caption>Livre(s) écrit</caption>
                <tr>
                    <th>Titre</th>
                    <th>Année</th>
                    <th>Langue</th>
                    <th>Couverture</th>
                    <th>Commentaire</th>
                    <th>Prix</th>
                </tr>                          
            </thead>
            <tbody>
                <xsl:for-each select="/bibliotheque/livres/livre[contains(@auteur, $id_auteur)]">
                    <xsl:sort select="prix" order="descending" data-type="number"/>
                    <tr>
                        <td><xsl:value-of select="titre"/></td>
                        <td><xsl:value-of select="annee"/></td>
                        <td><xsl:value-of select="@langue"/></td>
                        <td>
                            <xsl:if test="couverture">
                                <img>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="couverture"/>   
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        Page de couverture du livre
                                    </xsl:attribute>
                                    <xsl:attribute name="width">100</xsl:attribute>
                                    <xsl:attribute name="height">150</xsl:attribute>
                                </img>
                                
                            </xsl:if>
                        </td>
                        <td><xsl:value-of select="commentaire"/></td>
                        <td>
                            <xsl:if test="prix/@devise">
                                <xsl:value-of select="prix/@devise"/>
                                <!-- &#160; c'est pour ajouter un espace vide (seulement pour l'esthétique de la page html -->
                                &#160;
                            </xsl:if>
                            <xsl:value-of select="prix"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
        
    </xsl:template>
</xsl:stylesheet>
