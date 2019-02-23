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
    <xsl:param name="prix_min" select="number('10')"/>
    <xsl:param name="prix_max" select="number('15')"/>
    
    <!-- 
        Faire l'ajustement du prix pour le prix min 
        On assume que si on entre un prix plus petit que 0 ou plus grand que 100,
        le prix min va être 0 par défault
    -->
    <xsl:variable name="prix_min_ajusted">
        <xsl:choose>
            <xsl:when test="string($prix_min) = 'NaN'">
                <xsl:value-of select="number('0')"/>
            </xsl:when>
            <xsl:when test="$prix_min &gt;= $prix_max">
                <xsl:value-of select="number($prix_max)"/>
            </xsl:when>
            <xsl:when test="$prix_min &lt;= 0">
                <xsl:value-of select="number(0)"/>
            </xsl:when>
            <xsl:when test="$prix_min &gt;= 100">
                <xsl:value-of select="number(0)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number($prix_min)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- 
            Faire l'ajustement du prix pour le prix max 
            On assume que si on entre un prix plus petit que 0 ou plus grand que 100,
            le prix max va être 100 par défault
    -->
    <xsl:variable name="prix_max_ajusted">
        <xsl:choose>
            <xsl:when test="string($prix_max) = 'NaN'">
                <xsl:value-of select="number('100')"/>
            </xsl:when>
            <xsl:when test="$prix_min &gt;= $prix_max">
                <xsl:value-of select="number($prix_min)"/>
            </xsl:when>
            <xsl:when test="$prix_max &lt;= 0">
                <xsl:value-of select="number(100)"/>
            </xsl:when>
            <xsl:when test="$prix_max &gt;= 100">
                <xsl:value-of select="number(100)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number($prix_max)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
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
                            <xsl:call-template name="livre"/>
                            
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour l'affichage des livres et leurs informations -->
    <xsl:template name="livre" match="livre">
        <!-- 
            Nous devons faire un check sur les prix. Il faut passer à travers les tests cases s'il y a une
            erreur quelconque qui s'est introduite ou même s'il y a une erreur de frappe. Par exemple, 
            si min ou max est laissé vide, ou si max est plus petit que min ou vice-versa. 
        -->
        
        <xsl:if test="$prix_max_ajusted > $prix_min_ajusted or $prix_min=0 or $prix_max=100">
            <xsl:for-each select="bibliotheque/livres/livre[contains(titre, $livre)]">
                <xsl:sort select="bibliotheque/auteurs/auteur/nom" data-type="text"/>
                <xsl:variable name="book_price" select="number(prix)"/>
                <xsl:if test="$book_price > number($prix_min_ajusted) and $book_price &lt;= number($prix_max_ajusted)">
                    <xsl:variable name="id_auteur" select="@auteur"/>
                    <tr>
                        <td><xsl:value-of select="titre"/></td>
                        <td>
                            <xsl:if test="/bibliotheque/auteurs/auteur[contains($id_auteur, @ident)]">
                                <xsl:apply-templates select="/bibliotheque/auteurs/auteur[contains($id_auteur, @ident)]">
                                    <xsl:sort select="nom" data-type="text"/>
                                </xsl:apply-templates>
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
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="auteur">
        <ul>
           <li><xsl:value-of select="nom"/>&#160;<xsl:value-of select="prenom"/>&#160;</li>
        </ul>
    </xsl:template>
   
    
</xsl:stylesheet>

















