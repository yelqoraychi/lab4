INSERT INTO AUTEUR (id, nom) VALUES (1, 'Victor Hugo');
INSERT INTO OUVRAGE (id, titre, disponible, auteur_id) VALUES 
(1, 'Les Misérables', TRUE, 1),
(2, 'Le Dernier Jour', TRUE, 1),
(3, 'Notre-Dame de Paris', FALSE, 1);
UPDATE OUVRAGE 
SET disponible = TRUE 
WHERE id = 3;
UPDATE OUVRAGE o
SET disponible = FALSE
WHERE EXISTS (
    SELECT 1 FROM EMPRUNT e 
    WHERE e.ouvrage_id = o.id 
    AND e.date_retour >= CURRENT_DATE
);
UPDATE EMPRUNT 
SET date_retour = CURRENT_DATE + INTERVAL '7 days' 
WHERE date_retour < CURRENT_DATE;
DELETE FROM AUTEUR WHERE id = 1;
DELETE FROM OUVRAGE WHERE auteur_id = 1;
DELETE FROM AUTEUR WHERE id = 1;

START  TRANSACTION;
INSERT INTO ABONNE (id, nom, email) VALUES (1, 'Jean Dupont', 'jean.dupont@example.com');
INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_emprunt, date_retour) 
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days');

COMMIT;

START TRANSACTION;

UPDATE OUVRAGE SET disponible = FALSE WHERE id = 1;
INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_emprunt, date_retour) 
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days');


ROLLBACK;
INSERT INTO OUVRAGE (id, titre, disponible, auteur_id) VALUES 
(101, 'Titre 1', TRUE, 1),
(102, 'Titre 2', TRUE, 2),
(103, 'Titre 3', FALSE, 1);
DO $$
DECLARE
    v_ouvrage_id INT := 1;
    v_abonne_id INT := 1;
    v_disponible BOOLEAN;
    v_nb_emprunts INT;
BEGIN
    BEGIN TRANSACTION;
    
    -- 1. Vérifier disponibilité
    SELECT disponible INTO v_disponible FROM OUVRAGE WHERE id = v_ouvrage_id;
    IF NOT v_disponible THEN
        RAISE EXCEPTION 'Ouvrage non disponible';
    END IF;
    
    -- 2. Vérifier limite d'emprunts
    SELECT COUNT(*) INTO v_nb_emprunts FROM EMPRUNT 
    WHERE abonne_id = v_abonne_id AND date_retour >= CURRENT_DATE;
    IF v_nb_emprunts >= 5 THEN
        RAISE EXCEPTION 'Limite de 5 emprunts atteinte';
    END IF;
    
    -- 3. Mettre à jour disponibilité
    UPDATE OUVRAGE SET disponible = FALSE WHERE id = v_ouvrage_id;
    
    -- 4. Créer l'emprunt
    INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_emprunt, date_retour) 
    VALUES (v_ouvrage_id, v_abonne_id, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days');
    
    COMMIT;
    RAISE NOTICE 'Emprunt réussi pour l''ouvrage %', v_ouvrage_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Erreur : %', SQLERRM;
END;
$$;
DO $$
DECLARE
    v_ouvrage_id INT := 1;
    v_abonne_id INT := 1;
    v_emprunt_id INT;
    v_date_retour DATE;
BEGIN
    BEGIN TRANSACTION;
    
    -- 1. Trouver l'emprunt actif
    SELECT date_retour INTO v_date_retour FROM EMPRUNT 
    WHERE ouvrage_id = v_ouvrage_id AND abonne_id = v_abonne_id 
    AND date_retour >= CURRENT_DATE;
    
    IF v_date_retour IS NULL THEN
        RAISE EXCEPTION 'Aucun emprunt actif trouvé';
    END IF;
    
    -- 2. Gérer le retard (exemple : ajouter une note ou une amende)
    IF CURRENT_DATE > v_date_retour THEN
        RAISE NOTICE 'Retour en retard de % jours', CURRENT_DATE - v_date_retour;
        -- Ici, on pourrait insérer dans une table AMENDE
    END IF;
    
    -- 3. Supprimer l'emprunt (ou mettre à jour un statut)
    DELETE FROM EMPRUNT 
    WHERE ouvrage_id = v_ouvrage_id AND abonne_id = v_abonne_id;
    
    -- 4. Remettre l'ouvrage en disponibilité
    UPDATE OUVRAGE SET disponible = TRUE WHERE id = v_ouvrage_id;
    
    COMMIT;
    RAISE NOTICE 'Retour enregistré pour l''ouvrage %', v_ouvrage_id;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Erreur lors du retour : %', SQLERRM;
END;
$$;