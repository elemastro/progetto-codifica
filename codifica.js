$(document).ready(function() {
    $(".inf_codifica, .inf_bibliografiche, .informazioni, .titolo_a, #evidenzia_parti").hide();
    $(".testo_codificato").hide();
    $(".regolarizzazione").hide();
    $(".espansione").hide();
    $(".correzione").hide();

    
    // Gestisce il click su qualsiasi div con la classe "informazioni"
    $(".but_informazioni").click(function() {
        // Mostra i div con classi inf_codifica e inf_bibliografiche
        $(".inf_codifica, .inf_bibliografiche, .informazioni, #menu_art").toggle();
        
        // Nasconde il div con class testo_codificato
        $(".testo_codificato, .titolo_a, #evidenzia_parti").hide();
    });
        
        // Aggiunge un gestore di eventi di clic per tutti i pulsanti che iniziano con "button_"
        $("button[id^='button_']").click(function() {
            // Estrae il numero dall'ID del pulsante cliccato
            var buttonId = $(this).attr('id');
            var number = buttonId.split('_')[1];
    
            // Costruisce l'ID del div da mostrare
            var targetDivId = '#cont_' + number;
    
            // Nasconde tutti i div con classe "contenitore"
            $(".contenitore").hide();
    
            // Mostra solo il div corrispondente
            $(targetDivId).show();
            $("#evidenzia_parti").show();
    
            // Nasconde tutti gli elementi con classi "testo_codificato" e "titolo_a" dentro a tutti i div
            $(".contenitore .testo_codificato, .contenitore .titolo_a").hide();
    
            // Mostra solo gli elementi con classi "testo_codificato" e "titolo_a" dentro al div corrispondente
            $(targetDivId).find(".testo_codificato, .titolo_a").show();
        });
    

    $('img.facsimile').each(function() {
        var img = $(this);
        
        // Verifica che l'immagine sia caricata
        img.on('load', function() {
            // Dimensioni originali dell'immagine
            var originalWidth = img[0].naturalWidth;
            var originalHeight = img[0].naturalHeight;

            // Dimensioni target (puoi definire la larghezza desiderata)
            var targetWidth = 700; // Ad esempio, imposta la larghezza target a 800px
            var targetHeight = targetWidth * (originalHeight / originalWidth);
            
            // Imposta le nuove dimensioni
            img.width(targetWidth);
            img.height(targetHeight);
            
            // Calcola il rapporto di ridimensionamento
            var widthRatio = targetWidth / originalWidth;
            var heightRatio = targetHeight / originalHeight;
            
            // Aggiorna le coordinate delle aree mappate
            var mapName = img.attr('usemap').substring(1); // Rimuovi il #
            $('map[name="' + mapName + '"] area').each(function() {
                var coords = $(this).attr('coords').split(',').map(Number);
                for (var i = 0; i < coords.length; i += 2) {
                    coords[i] = Math.round(coords[i] * widthRatio);
                    coords[i + 1] = Math.round(coords[i + 1] * heightRatio);
                }
                $(this).attr('coords', coords.join(','));
            });
        }).each(function() {
            if (this.complete) $(this).trigger('load');
        });
    });

    $("area").click(function(event) {
        event.preventDefault(); // Prevent default anchor behavior
    
        // Ottieni l'ID dell'area cliccata e rimuovi il carattere iniziale
        var areaId = $(this).attr('id').substring(1);
        console.log(areaId);
    
        // Trova il div selezionato
        var selectedDiv = $("div[id='" + areaId + "']");
    
        // Controlla se il div è già evidenziato
        if (selectedDiv.hasClass('highlight')) {
            // Se sì, rimuovi l'evidenziazione
            selectedDiv.removeClass('highlight');
            selectedDiv.nextAll("div.testo").first().removeClass('highlight');
        } else {
            // Altrimenti, rimuovi la classe 'highlight' da tutti i div
            $("div").removeClass('highlight');
    
            // Evidenzia il div con l'id selezionato
            selectedDiv.addClass('highlight');
            
            // Trova e aggiungi la classe 'highlight' anche al primo div 'testo' trovato
            var nextTestoDiv = selectedDiv.nextAll("div.testo").first();
            console.log(nextTestoDiv);
            nextTestoDiv.addClass('highlight');
    
            // Esegui lo scroll all'elemento con l'id selezionato
            $('html, body').animate({
                scrollTop: selectedDiv.offset().top
            }, 1000);
        }
    });
    

    $("#but_pers").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".per_rif").toggleClass("highlighted_per");
    });

    $("#but_luoghi").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".luo_rif").toggleClass("highlighted_luo");
    });

    $("#but_disc").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".discorso_diretto").toggleClass("highlighted_dis");
    });

    $("#but_pens").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".pensieri").toggleClass("highlighted_pen");
    });

    $("#but_event").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".eventi").toggleClass("highlighted_eve");
    });

    $("#but_date").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".date").toggleClass("highlighted_dat");
    });

    $("#but_organ").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".organ").toggleClass("highlighted_org");
    });

    $("#but_nume").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".num").toggleClass("highlighted_num");
    });

    $("#but_fig_ret").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".fig_ret").toggleClass("highlighted_fig");
        $(".fig_reg").toggleClass("highlighted_fig");
    });

    $("#but_cit").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".citazioni").toggleClass("highlighted_cit");
    });

    $("#but_term").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".term_tec_rif").toggleClass("highlighted_ter");
    });

    $("#but_opere").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".op_rif").toggleClass("highlighted_op");
    });

    $("#but_corr").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".errore_orig").toggle();
        $(".correzione").toggle();
        $(".correzione").toggleClass("highlighted_corr");

    });

    $("#but_esp").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".abbreviazione").toggle();
        $(".espansione").toggle();
        $(".espansione").toggleClass("highlighted_esp");

    });

    $("#but_reg").click(function() {
        // Alterna la classe "highlighted" agli elementi con la classe "pers_rif"
        $(".regolarizzazione").toggle();
        $(".originale").toggle();
        $(".regolarizzazione").toggleClass("highlighted_reg");
    });




    

});
