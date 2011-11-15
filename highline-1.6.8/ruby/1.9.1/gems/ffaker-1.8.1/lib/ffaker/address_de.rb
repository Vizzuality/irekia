module Faker
  module AddressDE
    include Faker::Address
    extend ModuleUtils
    extend self

    def zip_code
      Faker.numerify ZIP_FORMATS.rand
    end

    def state
      STATE.rand
    end

    def city
      CITY.rand
    end

    ZIP_FORMATS = k ['#####']

    STATE = k ['Baden-Wuerttemberg', 'Bayern', 'Berlin', 'Brandenburg', 'Bremen',
       'Hamburg', 'Hessen', 'Mecklenburg-Vorpommern', 'Niedersachsen', 'Nordrhein-Westfalen',
       'Rheinland-Pfalz', 'Saarland', 'Sachsen', 'Schleswig-Holstein',
       'Thueringen']

    CITY = k %w(Aach Aachen Aalen Abenberg Abensberg Achern Achim Adelsheim Adenau Adorf Ahaus Ahlen 
	Ahrensburg Aichach Aichtal Aken Albstadt Alfeld Allendorf Allstedt Alpirsbach Alsfeld
	Alsdorf  Alsleben Altdorf Altena Altenau Altenberg Altenburg Altenkirchen Altensteig 
	Altentreptow Altlandsberg Alzenau Alzey Amberg Amorbach Andernach Angermuende Anklam 
	Annaberg-Buchholz Annaburg Annweiler Ansbach  Apolda Arendsee Arneburg Arnis Arnsberg 
	Arnstadt Arnstein Artern Arzberg Aschaffenburg Aschersleben Asperg Attendorn Aub 
	Aue Auerbach Augsburg Augustusburg Aulendorf Auma Aurich  Babenhausen Bacharach Backnang 
	Baden-Baden Baesweiler Baiersdorf Balingen Ballenstedt Balve Bamberg Barby Bargteheide 
	Barmstedt Baernau Barntrup Barsinghausen Barth Baruth Bassum Battenberg Baumholder Baunach 
	Baunatal Bautzen Bayreuth Bebra Beckum Bedburg Beelitz Beerfelden Beeskow Beilngries Beilstein 
	Belgern Belzig Bendorf Benneckenstein Bensheim Berching Berga Bergen
	Bergheim Bergisch Gladbach Bergkamen Bergneustadt Berka Berlin Bernburg Bernkastel-Kues 
	Bernsdorf Bersenbrueck Besigheim Betzdorf Betzenstein Beverungen Bexbach Biedenkopf 
	Bielefeld Biesenthal Bietigheim-Bissingen Billerbeck Birkenfeld Bischofswerda Bismark 
	Bitburg Bitterfeld Blankenburg Blankenhain Blaubeuren Bleckede Bleicherode Blieskastel 
	Blomberg Blumberg  Bobingen Bocholt Bochum Bockenem Bodenwerder Bogen Boizenburg Bonn 
	Bopfingen Boppard Borgentreich Borgholzhausen Borken Borken Borkum Borna Bornheim Bottrop 
	Boxberg Brackenheim Brake Brakel Bramsche Brand-Erbisdorf Brandis Braubach Braunfels 
	Braunlage Braeunlingen Braunsbedra Braunschweig Breckerfeld Bredstedt Brehna Bremen 	
	Bremerhaven Bretten Breuberg Brilon Brotterode Bruchsal Brueck Brueel Bruehl Brunsbuettel 
	Bruessow Buchen Buchloe Bueckeburg Buckow Buedelsdorf Buedingen Buehl Buende Bueren Burg 
	Burgau Burgbernheim Burgdorf Buergel Burghausen Burgkunstadt Burglengenfeld Burgstaedt 
	Burgwedel Burladingen Burscheid Buerstadt Buttelstedt Buttstaedt Butzbach Buetzow Buxtehude 
	Calau Calbe Calw Camburg Castrop-Rauxel Celle Cham Chemnitz Clausthal-Zellerfeld  Clingen 	
	Cloppenburg Coburg Cochem Coesfeld Colditz Coswig Coswig Cottbus Crailsheim Creglingen 
	Creuzburg Crimmitschau Crivitz Cuxhaven  Dachau Dahlen Dahn Damme Dannenberg 
	Dargun Darmstadt Dassel Dassow Datteln Daun Deggendorf Deidesheim Delbrueck Delitzsch 
	Delmenhorst Demmin Derenburg Dessau Detmold Dettelbach Dieburg  Diemelstadt Diepholz Dierdorf 
	Dietenheim Dietfurt Dietzenbach Diez Dillenburg Dillingen  Dingolfing Dinkelsbuehl Dinklage 
	Dinslaken Dippoldiswalde Dissen Ditzingen Doberlug-Kirchhain Dohna Dommitzsch 
	Donaueschingen Donzdorf Dorfen Dormagen Dornhan Dornstetten Dorsten Dortmund Dransfeld 
	Drebkau Dreieich Drensteinfurt Dresden Drolshagen Duderstadt Duisburg Duelmen Dueren 
	Duesseldorf  Ebeleben Eberbach Ebermannstadt Ebern Ebersbach Ebersberg Eberswalde Eckartsberga
	Eckernfoerde Edenkoben Egeln Eggenfelden Eggesin Ehingen Ehrenfriedersdorf Eibelstadt 
	Eibenstock Eichstaett Eilenburg Einbeck Eisenach Eisenberg Eisenberg Eisenhuettenstadt 
	Eisfeld Eisleben  Eislingen Elbingerode Ellingen Ellrich Ellwangen Elmshorn Elsfleth Elsterberg 
	Elsterwerda Elstra Elterlein Eltmann Eltville Elzach Elze Emden Emmendingen Emmerich Emsdetten 
	Endingen Engen Enger Ennepetal Ennigerloh Eppelheim Eppingen  Eppstein Erbach Erbach Erbendorf 
	Erding Erftstadt Erfurt Erkelenz Erkner Erkrath Erlangen Erlenbach Erwitte Eschborn Eschenbach 
	Eschershausen Eschwege Eschweiler Esens Espelkamp Essen Esslingen Ettenheim Ettlingen Euskirchen 
	Eutin  Falkenberg Falkensee Falkenstein Fehmarn Fellbach Felsberg Feuchtwangen Filderstadt 
	Finsterwalde Fladungen Flensburg Forchheim Forchtenberg Forst Frankenau Frankenberg Frankenberg 
	Frankenthal Frankfurt Franzburg Frauenstein Frechen Freiberg Freilassing Freinsheim Freising 
	Freital Freren Freudenberg Freudenberg Freudenstadt Freyburg Freystadt Freyung Friedberg Friedberg  
	Friedland Friedland Friedrichroda Friedrichsdorf Friedrichshafen Friedrichstadt Friedrichsthal 
	Friesack Friesoythe Fritzlar Frohburg Fulda  Gadebusch Gaggenau Gaildorf Gammertingen Garbsen 
	Gardelegen Garding Gartz Gau-Algesheim Gebesee Gedern Geesthacht Gefell Gefrees Gehrden Gehren 
	Geilenkirchen Geisa Geiselhoering Geisenfeld Geisenheim Geising Geisingen Geislingen Geithain 
	Geldern Gelnhausen Gelsenkirchen Gemuenden Gengenbach Genthin Georgsmarienhuette Gera Gerabronn 
	Gerbstedt Geretsried Geringswalde Gerlingen Germering Germersheim  Gernrode Gernsbach Gernsheim 
	Gerolstein Gerolzhofen Gersfeld Gersthofen Gescher Geseke Gevelsberg Geyer Gifhorn 
	Gladbeck Gladenbach Glashuette Glauchau Glinde Gluecksburg Glueckstadt Gnoien Goch Goldberg 
	Goldkronach Gommern Goeppingen Goerlitz Goslar Gotha Goettingen Grabow 
	Grafenau Graefenberg Graefenhainichen Graefenthal Grafenwoehr Gransee Grebenau Grebenstein 
	Greding  Greifswald Greiz Greven Grevenbroich Grevesmuehlen Griesheim Grimma Grimmen 
	Groebzig Groeditz Groitzsch Gronau Gronau Groeningen
	Gruenberg Gruenhain-Beierfeld Gruensfeld Gruenstadt Guben Gudensberg Gueglingen 
	Gummersbach Gundelsheim Guentersberge Guenzburg Gunzenhausen Guesten Guestrow Guetersloh 
	Guetzkow  Haan Hachenburg Hadamar Hadmersleben Hagen Hagenbach Hagenow Haiger Haigerloch 
	Hainichen Haiterbach Halberstadt Haldensleben Halle Halle Hallenberg Hallstadt Halver 
	Hamburg Hameln Hamm Hammelburg Hamminkeln Hanau Hannover Harburg Hardegsen Haren Harsewinkel 
	Hartenstein Hartha Harzgerode Haseluenne Hasselfelde Hattingen Hatzfeld Hausach 
	Hauzenberg Havelberg Havelsee Hayingen Hechingen Hecklingen Heide Heideck Heidelberg 
	Heidenau Heilbronn Heiligenhafen Heiligenhaus Heilsbronn Heimbach Heimsheim Heinsberg 
	Heitersheim Heldrungen Helmbrechts Helmstedt Hemau Hemer Hemmingen Hemmoor Hemsbach Hennef 
	Hennigsdorf Heppenheim Herbolzheim Herborn Herbrechtingen Herbstein Herdecke Herdorf Herford 
	Heringen  Hermeskeil Hermsdorf Herne Herrenberg Herrieden Herrnhut Hersbruck Herten Herzberg 
	Herzogenaurach Herzogenrath Hettingen Hettstedt Heubach Heusenstamm Hilchenbach Hildburghausen 
	Hilden Hildesheim Hillesheim Hilpoltstein Hirschau Hirschberg Hirschhorn Hitzacker Hockenheim 
	Hof Hofgeismar Hohenleuben Hohenmoelsen Hohnstein Hoehr-Grenzhausen Hollfeld Holzgerlingen 
	Holzminden Homberg Homberg Homburg Hornbach Hornberg Hornburg Hoerstel Horstmar Hoexter Hoya 
	Hoyerswerda Hoym Hueckelhoven Hueckeswagen Huefingen Huenfeld Hungen Huerth Husum  Ibbenbueren 
	Ichenhausen Idar-Oberstein Idstein Illertissen Ilmenau Ilsenburg Ilshofen Immenhausen Ingelfingen 
	Ingolstadt Iphofen Iserlohn Isselburg Itzehoe Jarmen Jena Jerichow Jessen Jever Joachimsthal 
	Johanngeorgenstadt Joehstadt Juelich Jueterbog  Kaarst Kahla Kaisersesch Kaiserslautern Kalbe Kalkar 
	Kaltenkirchen Kaltennordheim Kamen Kamenz Kamp-Lintfort Kandel Kandern Kappeln Karben Karlsruhe 
	Karlstadt Kassel Kastellaun Katzenelnbogen Kaub Kaufbeuren Kehl Kelbra Kelheim Kelkheim Kellinghusen 
	Kelsterbach Kemberg Kemnath Kempen Kempten Kenzingen Kerpen Ketzin Kevelaer Kiel Kierspe 
	Kindelbrueck Kirchberg Kirchberg Kirchen Kirchenlamitz Kirchhain Kirchheimbolanden Kirn Kirtorf 
	Kitzingen Kitzscher Kleve Knittlingen Koblenz Kohren-Sahlis Kolbermoor Konstanz Konz Korbach 
	Korntal-Muenchingen Kornwestheim Korschenbroich Kraichtal Kranichfeld Krautheim Krefeld Kremmen 
	Krempe Kreuztal Kronach Kroppenstedt Krumbach  Kuehlungsborn Kulmbach Kuelsheim Kuenzelsau 
	Kupferberg Kuppenheim Kusel Kyllburg Kyritz  Laage Laatzen Ladenburg Lage Lahnstein Laichingen 
	Lambrecht Lampertheim Landsberg Landshut Landstuhl Langelsheim Langen Langen Langenau Langenburg 
	Langenfeld Langenhagen Langenselbold Langenzenn Langewiesen Lassan Laubach Lauchhammer Lauchheim 
	Lauda-Koenigshofen Laufen Laufenburg Lauingen Laupheim Lauscha Lauta Lauter Lauterbach Lauterecken 
	Lauterstein Lebach Lebus Leer Lehesten Lehrte Leichlingen Leimen Leinefelde-Worbis Leinfelden-Echterdingen 
	Leipheim Leipzig Leisnig Lemgo Lengefeld Lengenfeld Lengerich Lennestadt Lenzen Leonberg Leun Leuna 
	Leutenberg Leutershausen Leverkusen Lich Lichtenau Lichtenberg Lichtenfels Lichtenstein Liebenau 
	Liebenwalde Lieberose Liebstadt Lindau Lindau Linden Lindenfels Lindow Lingen Linnich Lippstadt 
	Loebau Loebejuen Loburg Lohmar Lohne Loehne Loitz Lollar Lommatzsch Loeningen Lorch Lorch Loerrach 
	Lorsch Loewenstein Luebbecke Luebben Luebeck Luebtheen Luebz Luechow Lucka Luckau 
	Luckenwalde Luedenscheid Luedinghausen Ludwigsburg Ludwigsfelde Ludwigslust Ludwigsstadt Luegde 
	Lueneburg Luenen Lunzenau Luetjenburg Luetzen Lychen  Magdala Magdeburg Mahlberg Mainbernheim 
	Mainburg Maintal Mainz Malchin Malchow Mannheim Manderscheid Mansfeld Marburg Marienberg 
	Marienmuenster Markdorf Markgroeningen Markkleeberg Markneukirchen Markranstaedt Marktbreit 
	Marktheidenfeld Marktleuthen Marktoberdorf Marktredwitz Marktsteft Marl Marlow Marne Marsberg 
	Maulbronn Maxhuette-Haidhof Mayen Mechernich Meckenheim Medebach Meerane Meerbusch Meersburg 
	Meinerzhagen Meiningen Meisenheim Meldorf Melle Mellrichstadt Melsungen Memmingen 
	Menden Mendig Mengen Meppen Merkendorf Merseburg Merzig Meschede Mettmann 
	Metzingen Meuselwitz Meyenburg Michelstadt Miesbach Miltenberg Mindelheim Minden Mirow 
	Mittenwalde Mitterteich Mittweida Moers Monheim Monschau Montabaur Moerfelden-Walldorf 
	Moringen Mosbach Moessingen Muecheln Muegeln Muehltroff Muelheim-Kaerlich Muellheim Muellrose 
	Muenchberg Muencheberg Muenchen Muenchenbernsdorf Munderkingen Muennerstadt Muensingen 
	Munster Muenster Muenstermaifeld Muenzenberg Murrhardt Mutzschen Mylau Nabburg Nagold Naila 
	Nassau Nastaetten Nauen Naumburg Naumburg Naunhof Nebra Neckarbischofsheim Neckargemuend 
	Neckarsteinach Neckarsulm Nerchau Neresheim Netphen Nettetal Netzschkau Neubrandenburg Neubukow 
	Neubulach Neudenau Neuenbuerg Neuenhaus Neuenrade Neuenstein Neuerburg Neuffen Neugersdorf 
	Neu-Isenburg Neukalen Neukirchen Neukirchen-Vluyn Neukloster Neumark Neunkirchen Neuruppin 
	Neusalza-Spremberg Neuss Neustadt Neustadt-Glewe Neustrelitz Neutraubling Neu-Ulm Neuwied 
	Nidda Niddatal Nidderau Nideggen Niebuell Niedenstein Niederkassel Niedernhall Niederstetten 
	Niederstotzingen Nieheim Niemegk Nienburg Nienburg Niesky Nittenau Norden Nordenham Norderney 
	Norderstedt Nordhausen Nordhorn Noerdlingen Northeim Nortorf Nossen Nuernberg Nuertingen 
	Oberasbach Oberhausen Oberhof Oberkirch Oberkochen Oberlungwitz Obermoschel Obernkirchen 
	Ober-Ramstadt Oberriexingen Obertshausen Oberursel Oberviechtach Oberwesel Oberwiesenthal 
	Ochsenfurt Ochsenhausen Ochtrup Oderberg Oebisfelde Oederan Oelde Oelsnitz Oer-Erkenschwick 
	Oerlinghausen Oestrich-Winkel Offenburg Ohrdruf Oehringen Olbernhau Oldenburg Olfen Olpe 
	Olsberg Oppenau Oppenheim Oranienbaum Oranienburg Orlamuende Ornbau Ortenberg Ortrand Oschatz 
	Oschersleben Osnabrueck Osterburg Osterburken Osterfeld Osterhofen Osterholz-Scharmbeck 
	Osterwieck Ostfildern Osthofen Oestringen Ostritz Otterberg Otterndorf Ottweiler Overath Owen 
	Paderborn Papenburg Pappenheim Parchim Parsberg Pasewalk Passau Pattensen Pegau Pegnitz Peine 
	Peitz Penig Penkun Penzberg Penzlin Perleberg Petershagen Pfarrkirchen Pforzheim Pfreimd 
	Pfullendorf Pfullingen Pfungstadt Philippsburg Pinneberg Pirmasens Pirna Plattling Plaue Plauen 
	Plettenberg Pleystein Plochingen Ploen Pocking Pohlheim Polch Potsdam Pottenstein 
	Preetz Premnitz Prenzlau Pressath Prettin Pretzsch Prichsenstadt Pritzwalk Pruem Pulheim 
	Pulsnitz Putbus Putlitz Puettlingen Quakenbrueck Quedlinburg Querfurt Quickborn Rabenau 
	Radeberg Radebeul Radeburg Radegast Radevormwald Raguhn Rahden Rain Ramstein-Miesenbach Ranis 
	Ransbach-Baumbach Rastatt Rastenberg Rathenow Ratingen Ratzeburg Rauenberg Raunheim 
	Rauschenberg Ravensburg Ravenstein Recklinghausen Rees Regen Regensburg Regis-Breitingen 
	Rehau Rehburg-Loccum Rehna Reichelsheim Reinbek Reinfeld Reinheim Remagen Remda-Teichel 
	Remscheid Renchen Rendsburg Rennerod Renningen Rerik Rethem Reutlingen Rheda-Wiedenbrueck 
	Rhede Rheinau Rheinbach Rheinberg Rheine Rheinfelden Rheinsberg Rheinstetten Rhens Rhinow 
	Ribnitz-Damgarten Richtenberg Riedenburg Riedlingen Rieneck Riesa Rietberg Rinteln Rochlitz 
	Rockenhausen Rodalben Rodenberg Roedental Roedermark Rodewisch Rodgau Roding Roemhild Romrod 
	Ronneburg Ronnenberg Rosenfeld Rosenheim Rosenthal Rostock Rotenburg Roth Roetha Rothenfels 
	Roettingen Rottweil Roetz Rudolstadt Ruhla Ruhland Runkel Ruesselsheim Ruethen Saalburg-Ebersdorf 
	Saalfeld Saarburg Saarlouis Sachsenhagen Sachsenheim Salzgitter Salzkotten Salzwedel Sandau 
	Sandersleben Sangerhausen Sarstedt Sassenberg Sassnitz Sayda Schafstaedt Schalkau Schauenstein 
	Scheer Scheibenberg Scheinfeld Schelklingen Schenefeld Schieder-Schwalenberg 
	Schifferstadt Schildau Schillingsfuerst Schiltach Schirgiswalde Schkeuditz Schkoelen 
	Schleiden Schleiz Schleswig Schlettau Schleusingen Schlieben Schlitz Schlotheim Schluechtern 
	Schluesselfeld Schmalkalden Schmallenberg Schmoelln Schnackenburg Schnaittenbach Schneeberg 
	Schneverdingen Schongau Schoeningen Schoensee Schoenwald Schopfheim Schoeppenstedt Schorndorf 
	Schortens Schotten Schramberg Schraplau Schriesheim Schrobenhausen Schrozberg Schuettorf 
	Schwaan Schwabach Schwabmuenchen Schwaigern Schwalbach Schwalmstadt Schwandorf Schwanebeck 
	Schwarzenbek Schwarzenborn Schwarzheide Schweich Schweinfurt Schwelm Schwerin Schwerte 
	Schwetzingen Sebnitz Seehausen Seehausen Seelow Seelze Seesen Sehnde Seifhennersdorf Selb 
	Selbitz Seligenstadt Selm Selters Senden Sendenhorst Senftenberg Siegburg Siegen 
	Sigmaringen Simbach Sindelfingen Singen Sinsheim Sinzig Soest Solingen Solms Soltau 
	Soemmerda Sondershausen Sonneberg Sonnewalde Sonthofen Sontra Spaichingen Spalt Spangenberg 
	Spenge Speyer Spremberg Springe Sprockhoevel Stade Stadtallendorf Stadthagen Stadtilm 
	Stadtlengsfeld Stadtlohn Stadtoldendorf Stadtprozelten Stadtroda Stadtsteinach Starnberg 
	Staufenberg Stavenhagen Stein Steinach Steinbach Steinfurt Steinheim Stendal 
	Sternberg Stockach Stolberg Stolberg Stolpen Storkow Straelen Stralsund Strasburg 
	Straubing Strausberg Strehla Stromberg Stutensee Stuttgart Suhl Sulingen Sulzburg 
	Syke  Tann  Tanna Tauberbischofsheim Taucha Taunusstein Tecklenburg Tegernsee Telgte Teltow 
	Templin Tengen Tessin Teterow Tettnang Teublitz Teuchern Teupitz Teuschnitz Thale Thannhausen 
	Tharandt Themar Thum Tirschenreuth Titisee-Neustadt Tittmoning Todtnau  
	Toenisvorst Toenning Torgau Torgelow Tornesch Traben-Trarbach Traunreut Traunstein Trebbin 
	Treffurt Trendelburg Treuchtlingen Treuen Treuenbrietzen Tribsees Trier Triptis Trochtelfingen 
	Troisdorf Trossingen Trostberg Tuebingen Tuttlingen Twistringen  
	Uebigau-Wahrenbrueck Ueckermuende Uelzen Uetersen Uffenheim Uhingen Ulm Ulrichstein Ummerstadt 
	Unkel Unna Usedom Usingen Uslar  Vacha Vallendar Varel Vechta Velbert Velburg 
	Velden Vellberg Vellmar Velten Verden Veringenstadt Versmold Viechtach Vienenburg Viernheim 
	Viersen Villingen-Schwenningen Vilsbiburg Vilseck Visselhoevede Vlotho Voerde
	Volkach Volkmarsen Vreden  Waechtersbach Wadern Waghaeusel Wahlstedt Waiblingen Waibstadt 
	Waischenfeld Waldeck Waldenbuch Waldenburg Waldenburg Waldershof Waldheim Waldkappel Waldkirch 
	Waldkirchen Waldkraiburg Waldmuenchen Waldsassen Waldshut-Tiengen Walldorf Wallduern Wallenfels 
	Walsrode Waltershausen Waltrop Wanfried Wanzleben Warburg Waren Warendorf Warin Warstein Wassenberg 
	Wassertruedingen Wasungen Wedel Weener Wegberg Wegeleben Wehr Weida Weikersheim Weilburg Weimar 
	Weingarten Weinheim Weinsberg Weinstadt Weismain Weiterstadt Welzheim 
	Welzow Wemding Werben Werdau Werder Werdohl Werl Wermelskirchen Wernau 
	Werne Werneuchen Wernigerode Wertheim Werther Wertingen Wesel Wesenberg Wesselburen Wesseling Westerburg 
	Westerland Westerstede Wetter Wetter Wettin Wetzlar Widdern Wiehe Wiehl Wiesbaden Wiesmoor Wiesensteig 
	Wiesloch Wildberg Wildemann Wildenfels Wildeshausen Wilhelmshaven Willebadessen Willich 
	Wilsdruff Wilster Wilthen Windischeschenbach Windsbach Winnenden Winsen Winterberg Wipperfuerth Wirges 
	Wismar Wissen Witten Wittenberg Wittenberge Wittenburg Wittichenau Wittlich Wittingen Wittmund Witzenhausen 
	Woldegk Wolfach Wolfen Wolfenbuettel Wolfhagen Wolframs-Eschenbach Wolfratshausen Wolfsburg Wolfstein 
	Wolgast Wolkenstein Wolmirstedt Worms Wriezen Wuelfrath Wunsiedel Wunstorf Wuppertal Wuerselen Wurzbach 
	Wuerzburg Wurzen Wustrow Xanten Zahna Zehdenick Zeitz Zell Zella-Mehlis Zerbst 
	Zeulenroda-Triebes Zeven Zierenberg Ziesar Zirndorf Zittau Zossen Zschopau Zwenkau Zwickau Zwiesel Zwingenberg)

  end
end
