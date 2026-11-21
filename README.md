# lab4
Aprés la création de la base de donnée et les tables, maintenant on va commencer à utiliser les opération CRUD.<br>
Commencons par l'insertion en utilisant la clause(INSERT)<br>
<img width="535" height="439" alt="INSERTION" src="https://github.com/user-attachments/assets/1a94c912-fc7f-4d6f-8f9e-de8fab41b096" /><br>
Il est nécessaire de faire attention au clé étrangers lors de l'insertion par exemple si on veut inserer un ouvrage qui ne concerne aucun auteur.<br>
Mettre à jour les donnes avec UPDATE:<br>
<img width="383" height="216" alt="UPDATE" src="https://github.com/user-attachments/assets/d9eeae53-26c2-474a-99bd-465884fba27d" /><br>
Il est conseillé de faire des conditions avec WHERE pour  ne pas modifier tous les enregistrements.<br>
<img width="512" height="179" alt="UPDATE 2" src="https://github.com/user-attachments/assets/dfbc9824-e2bb-4659-8717-2cf1175fb2cf" /><br>
Suppression des données avec DELETE:
<img width="932" height="156" alt="DELETE" src="https://github.com/user-attachments/assets/a43eed89-6486-4c8f-9314-57129a32cd0a" /><br>
DELETE est dangereux surtout avec les clés étrangers,il faut donner la façon de supprimmer les données lors de la création des tables :
RESTRICT:Genere des erreurs si les donné en relation avec autre tables.<br>
CASCADE :Supprimme la ligne parente et les lignes filles.<br>
SET NULL : Supprimme la ligne parente et donner NULL aux lignes filles.<br>
Les Transactions:<br>
Les transactions sont nécessaires si on veut faire un bloc de requétes qui sont liées (UNITE), on utilise COMMIT si le bloc ne génére pas des erreus et on confirme la transaction,ET ROLLBACK si une requéte genere une errure et on refuse toute la transaction pour la coherance des donnés.
Exemple:<br><img width="875" height="228" alt="TRANSACTION" src="https://github.com/user-attachments/assets/55f86e3f-c268-45c9-b337-ca241c3f4d09" /><br>
<img width="585" height="389" alt="transaction2" src="https://github.com/user-attachments/assets/96cc5723-b4a7-4286-941b-705ee3755158" /><br>
La parite des exrcices :<br>
Exploitation des connaissances pour gerer  un probleme métier:<br>
<img width="445" height="383" alt="exercices" src="https://github.com/user-attachments/assets/1fc29e52-acf2-4d34-9009-c1cbac56eced" />



