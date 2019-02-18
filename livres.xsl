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
    
    <!-- 
        Mettre le nom du livre désiré dans la valeur de l'attribut select 
        Exemple: select="'The Fellowship of the Ring'" va montrer toutes les
        informations associé au livre The Fellowship of the Ring 
    -->
    <xsl:param name="livre" select="''"/>
    <xsl:param name="prix_min" select="''"/>
    <xsl:param name="prix_max" select="''"/>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <head>
                    <title>
                        Informations associées 
                        <xsl:choose>
                            <xsl:when test="$livre=''">
                                aux Livres
                            </xsl:when>
                            <xsl:otherwise>
                                à <xsl:value-of select="$livre"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </title>
                    <link rel="stylesheet" type="text/css" href="livres.css"></link>
                </head>
            </head>
            <body>
                <h1>
                    Informations associées 
                    <xsl:choose>
                        <xsl:when test="$livre=''">
                            aux Livres
                        </xsl:when>
                        <xsl:otherwise>
                            au livre :  <xsl:value-of select="$livre"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </h1>
                <div>
                    <table class="livres">
                        <thead>
                            <caption>Livre(s)</caption>
                            <tr>
                                <th>Titre</th>
                                <th>Auteur(s)</th>
                                <th>Année</th>
                                <th>Langue</th>
                                <th>Couverture</th>
                                <th>Commentaire</th>
                                <th>Prix</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="bibliotheque/livres/livre[contains(titre, $livre)]">
                                
                            </xsl:apply-templates>
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour l'affichage des livres et leurs informations -->
    <xsl:template match="livre">
        <xsl:variable name="id_auteur" select="@auteur"/>
        <tr>
            <td><xsl:value-of select="titre"/></td>
            <td>
                <xsl:if test="/bibliotheque/auteurs/auteur[contains($id_auteur, @ident)]">
                    <xsl:apply-templates select="/bibliotheque/auteurs/auteur[contains($id_auteur, @ident)]"/>
                </xsl:if>
            </td>
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
    </xsl:template>
    
    <xsl:template match="auteur">
        <xsl:value-of select="nom"/>&#160;<xsl:value-of select="prenom"/>
    </xsl:template>
   
    
</xsl:stylesheet>

















