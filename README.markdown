== MEbGDP User Document


*About*

MEbGDP (Multi-evidence based Gene-Disease Relationship Prediction) 
is a web-based tool allowing biologists to pull evidence from several 
aspects to predict the unknown phenotype-genotype relationship for inheritance diseases. 

For now, it uses graph-based methods to infer the "unknown" from the known disease-gene 
relationship information from OMIM and other biological evidences such as disease linkage 
intervals and animal model phenotypes from MGI

MEbGDP is developped at Division of Health Science Informatics, 
Jonhs Hopkins University School of Medicine by Xiaoli Wu, Hans Bjornsson and Harold Lehmann.


*Installation and Configuration*

1. Install Ruby 1.9.3 and Rails 3.2.8, MySQL 5.5, Matlab
2. Clone this project
3. Install the required gems using bundle
4. Create the database and config your database information in config/database.yml
5. Import data into your db using the db/mebgdp.sql
6. Register your own OMIM API Key at http://www.omim.org/api, configure it in controllers/prediction_controller.rb
7. Configure your own server, recommend using Passenger with Apache (https://www.phusionpassenger.com/)
8. If you only need the Matlab scripts and data, it is located in tasks/rwrh/
9. Enjoy!