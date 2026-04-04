BEGIN;
  SET search_path TO ext_pgtap;
  SELECT plan(1);

  SELECT diag('Verificando se TRUE retorna TRUE');
  SELECT is (
    TRUE,
    TRUE
  );

  SELECT * FROM finish();
ROLLBACK;