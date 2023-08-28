% Regola: Approva il prestito se il valore degli asset commerciali
% supera il valore della richiesta di prestito e il valore
% degli asset sul conto corrente supera il 10% dell'ammontare del
% prestito richiesto (serve come anticipo solitamente)
approva_per_attivo(Loan_id) :-
    attivo(Loan_id, Income_annum, Commercial_assets_value, Bank_asset_value),
    passivo(Loan_id, _, Loan_amount, _),
    Commercial_assets_value + Income_annum > Loan_amount,
    Bank_asset_value > 0.1*Loan_amount.

% Regola: Approva il prestito se il valore del reddito annuo supera di
% 3.5 volte il valore della rata annua per ripagare il prestito
approva_per_reddito(Loan_id) :-
    attivo(Loan_id, Income_annum, _, _),
    solvibilita(Loan_id, Loan_amount, Loan_term, _),
    Income_annum > 3.5*(Loan_amount/Loan_term).

% Regola: Approva il prestito se il valore degli asset in possesso del
% richiedente e' almeno il doppio del prestito richiesto
approva_per_garanzie(Loan_id) :-
    garanzie(Loan_id, Residential_assets_value, Commercial_assets_value, Luxury_assets_value, Bank_asset_value),
    solvibilita(Loan_id, Loan_amount, _,  _),
    Residential_assets_value + Commercial_assets_value + Luxury_assets_value + Bank_asset_value > 2*(Loan_amount).

% Regola: Approva il prestito se il richiedente ha una buona gestione
% delle proprie finanze (piu attivi che passivi, oppure conto corrente
% molto cospiquo)
approva_per_gestione_finanze(Loan_id) :-
    attivo(Loan_id, _, Commercial_assets_value, Bank_asset_value),
    passivo(Loan_id, _, _, Luxury_assets_value),
    Commercial_assets_value + Bank_asset_value > Luxury_assets_value.

% Regola: Approva per piccoli prestiti avendo come garanzia un asset
% residenziale
approva_per_piccoli_prestiti(Loan_id) :-
    richiesta(Loan_id, _, _, _, _, Loan_amount, _, _, Residential_assets_value, _, _, _, _),
    Loan_amount < 3000000,
    Residential_assets_value> Loan_amount.

% Regola: Approva il prestito se il punteggio CIBIL e' maggiore di 700
approva_per_solvibilita(Loan_id) :-
    richiesta(Loan_id, _, _, _, _, _, _, Cibil_score, _, _, _, _, _),
    Cibil_score > 700.

% Regola: Approva il prestito se la richiesta è idonea alle condizioni
% calcolate sulla base delle osservazioni fatti sui modelli di apprendimento
approva_per_osservazioni(Loan_id) :-
    richiesta(Loan_id, _, _, _, Income_annum, Loan_amount, _, _, Residential_assets_value, _, Luxury_assets_value, Bank_asset_value, _),
    (Income_annum > 50000000;	
    Loan_amount < 15000000;
    Residential_assets_value > 70000000;
    Luxury_assets_value	> 15000000;
    Bank_asset_value > 60000000).