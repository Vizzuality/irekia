module Faker
  module NameDE
    include Faker::Name
    extend ModuleUtils
    extend self

    def name
      case rand(10)
      when 0 then "#{prefix} #{first_name} #{last_name}"
      else 	  "#{first_name} #{last_name}"
      end
    end

    def first_name
      FIRST_NAMES.rand
    end

    def last_name
      LAST_NAMES.rand
    end

    def prefix
      PREFIXES.rand
    end

    FIRST_NAMES = k %w(Mia Hannah Hanna Lena Lea Leah Emma Anna Leonie Leoni Lilli Lilly Lili Emilie Emily Lina Laura Marie Sarah 
	Sara Sophia Sofia Lara Sophie Sofie Maja Maya Amelie Luisa Louisa Johanna Emilia Nele Neele Clara Klara Leni
	Alina Charlotte Julia Lisa Zoe Pia Paula Melina Finja Finnja Ida Lia Liah Lya Greta Jana Josefine Josephine 
	Jasmin Yasmin Lucy Lucie Victoria Viktoria Emely Emelie Katharina Fiona Stella Pauline Amy Antonia Mara
	Marah Annika Nina Matilda Mathilda Helena Marlene Lotta Isabel Isabell Isabelle Theresa Teresa Chiara 
	Kiara Frieda Frida Eva Maria Celine Selina Jule Celina Vanessa Ronja Luise Louise Romy Isabella Ella 
	Franziska Elisa Magdalena Carla Karla Luna Sina Sinah Angelina Milena Helene Merle Jolina Joelina 
	Melissa Mila Nora Jette Miriam Carlotta Karlotta Elena Kim Michelle Aylin Eileen Aileen Ayleen Lynn Linn
	Mira Carolin Caroline Karoline Kimberly Kimberley Julie Juli Alicia Kira Kyra Vivien Vivienne Lana Paulina
	Linda Larissa Annabelle Annabell Annabel Anabel Elina Samira Leyla Nelli Nelly Lucia Alexandra Tamina Laila 
	Layla Elisabeth Lenja Lenya Anny Anni Annie Diana Natalie Nathalie Martha Marta Mina Jessica Jessika 
	Valentina Alisa Leticia Letizia Olivia Christina Lotte Samantha Fabienne Nisa Zoey Mariella Svea Cheyenne 
	Chayenne Annalena Carolina Karolina Ela Leona Tabea Aliyah Aaliyah Josy Josie Rebekka Alissa Alyssa Anastasia 
	Marleen Marlen Elif Anne Carina Karina Dana Noemi Lene Milla Rosalie Luana Evelyn Evelin Eveline Fenja Tessa 
	Xenia Marla Alessia Mona Saskia Joline Joeline Alexa Aurelia Ceylin Helen Jennifer Tamara Ecrin Leana Elli 
	Elly Nayla Florentine Henriette Lorena Veronika Felicitas Liana Livia Malin Marit Melanie Josephin 
	Josefin Emmi Emmy Tuana Dilara Maike Meike Thea Ashley Linea Linnea Marina Lilian Lillian Amina 
	Jill Jil Sarina Giulia Janne Talia Thalia Alea Rieke Rike Svenja Liliana Janina Nicole Selma Alisha 
	Ava Kaja Kaya Caja Liv Rosa Valeria Heidi Joyce Selin Ina Aleyna Enya Jamie Naomi Patricia Amira 
	Amalia Anouk Eliana Hermine Joy Juliana Romina Azra Franka Melek Melinda Freya Marieke Marike Mary 
	Sonja Ayla Elaine Alma Eda Elin Lola Melia Miley Nike Philine Cora Daria Jenny Jonna Yara Zeynep 
	Cassandra Kassandra Esila Felicia Malia Smilla Alena Amelia Aurora Ceyda Juliane Leandra Lilith Madita 
	Melisa Nika Summer Fatima Ilayda Joleen Malina Sandra Jasmina Katja Medina Annelie Juna Valerie Madlen 
	Madleen Aliya Charlotta Eleni Hailey Mailin Denise Fine Flora Madeleine Sena Vivian Ann Annemarie Asya 
	Christin Kristin Jara Jenna Julina Maren Soraya Tara Viola Alia Ellen Enie Lydia Milana Nala Adriana 
	Aimee Anja Chantal Elise Elsa Gina Joanna Judith Malea Marisa Mayra Talea Thalea Tilda Delia Joana 
	Kiana Melis Meryem Sude Amanda Enna Esther Holly Irem Marlena Mirja Phoebe Rahel Verena Alexia Bianca 
	Bianka Cara Friederike Catrin Katrin Kathrin Lavinia Lenia Nadine Stefanie Stephanie Ada Asmin Bella 
	Cecilia Clarissa Esma Jolie Maila Mareike Selena Soey Ylvi Ylvie Zara Abby Ayse Claire Helin Jona 
	Jonah Lilia Luzi Luzie Nila Sally Samia Sidney Sydney Tina Tyra Alice Anisa Belinay Cecile Fee 
	Inga Janna Jolien Levke Nia Ruby Stine Sunny Tamia Tiana Alara Charleen Collien Fanny Fatma 
	Felina Ines Jane Maxima Tarja Adelina Alica Dila Elanur Elea Gloria Jamila Kate Loreen Lou Maxi 
	Melody Nela Rania Sabrina Ariana Charline Christine Cosima Leia Leya Leonora Lindsay Megan Naemi 
	Nahla Sahra Saphira Serafina Stina Toni Tony Yaren Abigail Ece Evelina Frederike Inka Irma Kayra 
	Mariam Marissa Salome Violetta Yagmur Celin Eleonora Felia Femke Finia Hedda Hedi Henrike Jody 
	Juline Lieselotte Lilliana Luca Luka Maira Naila Naima Natalia Neela Salma Scarlett Seraphine 
	Shirin Tia Wiebke Alexis Alisia Angelique Anneke Edda Elia Gabriela Geraldine Giuliana Ilaria 
	Janin Janine Joelle Malak Mieke Nilay Noelle Yuna Adele Ceren Chelsea Daniela Evangeline Liz 
	Maggie Malena Marielle Marietta Mathea Mathilde Melike Merve Rafaela Raphaela Sandy Sienna Leon 
	Lucas Lukas Ben Finn Fynn Jonas Paul Luis Louis Maximilian Luca Luka Felix Tim Timm Elias Max Noah 
	Philip Philipp Niclas Niklas Julian Moritz Jan David Fabian Alexander Simon Jannik Yannik Yannick 
	Yannic Tom Nico Niko Jacob Jakob Eric Erik Linus Florian Lennard Lennart Nils Niels Henri Henry 
	Nick Joel Rafael Raphael Benjamin Marlon Jonathan Hannes Jannis Janis Yannis Jason Anton Emil 
	Johannes Leo Mika Sebastian Dominic Dominik Daniel Adrian Vincent Tobias Samuel Julius Till Lenny 
	Lenni Constantin Konstantin Timo Lennox Robin Aaron Oscar Oskar Colin Collin Jona Jonah Justin 
	Carl Karl Leonard Joshua Ole Matteo Jamie Marvin Marwin John Kilian Lasse Mattis Mathis Matthis 
	Levin Marc Mark Liam Maxim Maksim Gabriel Theo Bastian Johann Damian Noel Levi Phil Justus Malte 
	Tyler Tayler Valentin Benedikt Christian Silas Lars Mats Mads Jeremy Michael Oliver Pascal Toni 
	Tony Dennis Bennet Bennett Artur Arthur Luke Luc Luk Jayden Finnley Finley Finlay Connor Conner 
	Tristan Richard Marcel Diego Marius Mohammed Muhammad Manuel Jannes Fabio Maik Meik Mike Julien 
	Frederic Frederik Frederick Marco Marko Kevin Matti Ian Maurice Franz Arne Nicolas Nikolas Ali 
	Leandro Kai Kay Leopold Martin Elia Sam Dean Henrik Pepe Len Lenn Hendrik Emilio Cedric Cedrik 
	Milan Theodor Timon Jasper Malik Matthias Hugo Leander Michel Andreas Laurens Laurenz Bruno Konrad 
	Arda Neo Lorenz Marcus Markus Torben Thorben Magnus Robert Can Milo Clemens Klemens Nikita Domenic 
	Domenik Emilian Laurin Willi Willy Alessio Devin Fiete Friedrich Deniz Ruben Thomas Eddi Eddy Lion 
	Luan Kian Lian Lias Mert Patrick Chris Ilias Ilyas Kaan Nevio Quentin Yusuf Christoph Dustin 
	Joris Gustav Jaden Adam Fritz Henning Ryan Ferdinand Lionel Nino Piet Yasin Alex Carlo Karlo 
	Charlie Charly Leonardo Peter Ahmed Ahmet Benno Efe Enes Iven Yven Josef Joseph Miguel William 
	Marian Alessandro Antonio Brian Bryan Jerome Kerem Ludwig Arian Cristopher Jaron Stefan 
	Stephan Sven Victor Viktor Carlos Dario Sandro Jean Mehmet Bjarne Etienne Anthony Hans Mustafa 
	Darius Leif Georg Kjell Maddox Roman Thore Tore Danny Mohamed Titus Andre Damien Leonhard 
	Ricardo Riccardo Semih Janne Melvin Valentino Cem Jannek Janek Korbinian Romeo Taylor Jack 
	Rayan Thilo Curt Kurt Darian Jermaine Steven Albert Angelo Eren Eymen Hamza Sascha Dave Sean 
	Umut Wilhelm Edgar Giuliano Arjen Bela Hennes Logan Lutz Marten Batuhan Danilo Enrico Fabrice 
	Lean Sami Tamino Tizian Amir Claas Klaas Xaver Armin Denny Ibrahim Karim Sinan Tommy 
	Yunus Emanuel Gregor Jon Joost Jost Merlin Tamme Berkay Edward Jim Lino Mick Mikail Miran 
	Nicolai Nikolai Ron Tammo Tjark Emre Jordan Leonidas Mario Quirin Eduard Hassan Jano 
	Kimi Taha Baran Berat Caspar Gianluca Jarne Jarno Jonte Lucian Lucien Mailo Nathan Nelson Tino 
	Calvin Dorian Emirhan Furkan Ilja Lio Marek Mio Rico Damon Janosch Jesper Juri Kerim Shawn Tiago 
	Timur Elian Ethan Gian Kenan Amin Arvid Enno Falk Jens Johnny Keanu Mirco Mirko Pierre Santino 
	Eike Elijah Emin Gerrit Hasan Jake Jakub James Juan Kenny Peer Raik Ramon Rocco Tarik Vitus 
	Yigit Younes Bilal Dylan Edwin Georgios Jesse Koray Lewis Nikola Stanley Taylan Vinzenz 
	Burak Corvin Dejan Keno Nathanael Neven Ahmad Andrej Davin Dion Eray Erwin Francesco Mattes 
	Brandon Cornelius Ensar Fabien Giulio Hanno Ivan Jamal Jeremias Joe Kim Kolja Marlo Miko 
	Milow Omar Paolo Salih Samir Tilo Timmy Vin Abdullah Adem Alan Alperen Ansgar Aras Arno Azad 
	Bo Giovanni Ismail Jaro Jendrik Jimmy Kadir Kirill Otto Quinn Sercan Sidney Sydney Tyron
	Adriano Aiden Amon Benny Carsten Karsten Dan Dante Hagen Harun Jayson Kalle Leonas Levent 
	Lorik Loris Mirac Onur Raul Samuele Severin Simeon Vincenzo Yassin Yves Alejandro Alfred 
	Bendix Demian Enzo)

    LAST_NAMES = k %w(Schmidt Schneider Fischer Weber Meyer Wagner Becker Schulz Hoffmann 
	Koch Bauer Richter Klein Wolf Neumann Schwarz Zimmermann Braun 
	Hofmann Hartmann Lange Schmitt Werner Schmitz Krause Meier Lehmann 
	Schmid Schulze Maier Herrmann Walter Mayer Huber Kaiser Fuchs Peters 
	Lang Scholz Weiss Jung Hahn Schubert Vogel Friedrich Keller Frank Berger 
	Winkler Roth Beck Lorenz Baumann Franke Albrecht Schuster Simon Ludwig 
	Winter Kraus Martin Schumacher Vogt Stein Otto Sommer Gross Seidel Heinrich 
	Brandt Haas Schreiber Graf Schulte Dietrich Ziegler Kuhn Pohl Engel Horn 
	Busch Bergmann Thomas Voigt Sauer Arnold Wolff Pfeiffer Brauner Dreier 
	Schmenke Nowak Heinz Haupt Siegel Wagler Moser Elsner Reitenbach Steiner)

    PREFIXES = k %w(Herr Frau Dr. Prof.)
  end
end
