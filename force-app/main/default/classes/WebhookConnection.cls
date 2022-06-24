global class WebhookConnection extends DataSource.Connection {
/*TODO for Historical Case: 
       1. Lookup on CRM ROW_ID instead of UCM
       2. Hyperlink to CEH
       3. Child Activities
       4. Sort in tiny applet to most recent, filter on open only?
       5. custom search within context of account
       6. Replace query utils way of adding rows with production way
*/
    private static String url = 'https://webhook.contactcenter.iat.adp.com';

    global WebhookConnection(DataSource.ConnectionParams connectionParams) {
        System.debug('connectionParams:' + connectionParams);
    }

    // Sync - Invoked from Sync button on External Data Source. Auto-creates External Object and fields.
    override global List<DataSource.Table> sync() {

        List<DataSource.Table> tables = new List<DataSource.Table>();
        List<DataSource.Column> columns = new List<DataSource.Column>();
        //List<DataSource.Table> apTables = new List<DataSource.Table>();
        //List<DataSource.Column> apColumns = new List<DataSource.Column>();

        // CRM SR
        columns = new List < DataSource.Column > ();

        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl', 255));
        columns.add(DataSource.Column.text('srnumber', 255));
        columns.add(DataSource.Column.text('created', 255));
        columns.add(DataSource.Column.text('superType', 255));
        columns.add(DataSource.Column.text('type', 255));
        columns.add(DataSource.Column.text('subType', 255));
        columns.add(DataSource.Column.text('status', 255));
        columns.add(DataSource.Column.text('subStatus', 255));
        columns.add(DataSource.Column.text('abstract', 255));
        columns.add(DataSource.Column.text('description', 2000));
        columns.add(DataSource.Column.text('dueDate', 255));
        columns.add(DataSource.Column.text('closedDate', 255));
        columns.add(DataSource.Column.text('webVisibility', 255));
        columns.add(DataSource.Column.text('source', 255));
        columns.add(DataSource.Column.text('asset_partNum', 255));
        columns.add(DataSource.Column.text('contact_id', 255));
        columns.add(DataSource.Column.text('contact_fullName', 255));
        columns.add(DataSource.Column.text('contact_primaryEmail', 255));
        columns.add(DataSource.Column.text('contact_primaryPhone', 255));
        columns.add(DataSource.Column.text('owner_siebelUserId', 255));
        columns.add(DataSource.Column.text('account_crmAccountRowId', 255));
        columns.add(DataSource.Column.text('account_ein', 255));
        columns.add(DataSource.Column.text('account_processingRegion', 255));
        columns.add(DataSource.Column.text('account_companyCode', 255));
        columns.add(DataSource.Column.text('account_name', 255));
        columns.add(DataSource.Column.text('openedDate', 255));
        columns.add(DataSource.Column.text('parentSrNumber', 255));
        columns.add(DataSource.Column.text('ultimateSrNumber', 255));
        columns.add(DataSource.Column.text('clientViewDate', 255));
        columns.add(DataSource.Column.text('updated', 255));

        Datasource.Table newTable = new Datasource.Table();
        newTable.labelSingular = 'Service Request';
        newTable.labelPlural = 'Service Requests';
        newTable.description = 'Service Request';
        newTable.name = 'Service Request';
        newTable.nameColumn = 'CRM Service Request';

        newTable.columns = columns;
        tables.add(newTable);

        //Start Assist Note
        //Account Property
        columns= new List < DataSource.Column > ();
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl', 255));
        columns.add(DataSource.Column.text('source', 255));
        columns.add(DataSource.Column.text('comments', 255));
        columns.add(DataSource.Column.text('name', 255));
        columns.add(DataSource.Column.text('value', 255));
        columns.add(DataSource.Column.text('created', 255));
        columns.add(DataSource.Column.text('lastUpdated', 255));
        columns.add(DataSource.Column.text('count', 255));
        columns.add(DataSource.Column.text('countType', 255));
        columns.add(DataSource.Column.text('propertiesFreeFlow', 255));
        columns.add(DataSource.Column.text('crmAccountRowId', 255));
        columns.add(DataSource.Column.text('ucmAccountRowId', 255));
        
        newTable= new Datasource.Table();
        newTable.labelSingular = 'Account Property';
        newTable.labelPlural = 'Account Properties';
        newTable.description = 'Account Properties';
        newTable.name = 'Account Property';
        newTable.nameColumn = 'Account Property';
        
        newTable.columns = columns;
        tables.add(newTable);
        
        //Account Source Key
        columns= new List < DataSource.Column > ();
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl', 255));
        columns.add(DataSource.Column.text('source', 255));
        columns.add(DataSource.Column.text('value1', 255));
        columns.add(DataSource.Column.text('value2', 255));
        columns.add(DataSource.Column.text('value3', 255));
        columns.add(DataSource.Column.text('value', 255));
        columns.add(DataSource.Column.text('taxWebsiteId', 255));
        columns.add(DataSource.Column.text('smsClientId', 255));
        columns.add(DataSource.Column.text('ooid', 255));
        columns.add(DataSource.Column.text('created', 255));
        columns.add(DataSource.Column.text('lastUpdated', 255));
        columns.add(DataSource.Column.text('crmAccountRowId', 255));
        columns.add(DataSource.Column.text('ucmAccountRowId', 255));
        
        newTable= new Datasource.Table();
        newTable.labelSingular = 'Account Source Key';
        newTable.labelPlural = 'Account Source Keys';
        newTable.description = 'Account Source Keys';
        newTable.name = 'Account Source Key';
        newTable.nameColumn = 'Account Source Key';
        
        newTable.columns = columns;
        tables.add(newTable);
        //Contact Source Key

        return tables;
    }

    override global DataSource.TableResult query(DataSource.QueryContext c) {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();

        try {
            String table = c.tableSelection.tableSelected;
            System.debug('tableSelected: ' + table);

            //Parse Context Filter and translate to Query String.  Eventually Needs to be a loop for all query params.  This is basic for a single colname and value.
            DataSource.Filter filter = c.tableSelection.filter;
            String columnName = filter.columnName;
            Object columnVal = filter.columnValue;            
            String q;

            System.debug(c);
            System.debug('filter: ' + filter);

            if (filter != null) {
                System.debug('columnName: ' + columnName);
            

                if (columnName == null) {
                    // check for sub filter
                    //     
                    for (DataSource.Filter subfilter: filter.subfilters) {
                         System.debug('FilterVariable: ' + subfilter);
                        columnName = subFilter.columnName;
                        columnVal = subFilter.columnValue;
                        System.debug('subfilter colName' + columnName);
                    }
                }
                
                // SF does not like dot notation, however CRMP uses dot notation so must convert.
                if (columnName.indexOf('_') > 0) {
                    columnName = columnName.replace('_', '.');
                }

                System.debug('columnName: ' + columnName);
                
                q = '?q=' + columnName + '%20eq%20%22' + columnVal + '%22';
                System.debug('q: ' + q);
            }
            
            switch on table {
                when 'Historical Case' {
                    //Lookup UCM Row Id to get CRM Row Id for SR - doesn't do what is needed yet b/c indirect lookup uses config, can't fake it.
                    /*if (columnName == 'account_crmAccountRowId') {                
                          columnVal = getCRMAccountRowId('UCM', (String) columnVal); 
                    }*/                
                
                    //Search on External Id needed translation to CRMP srnumber?
                    if (columnName == 'ExternalId') {
                        columnName = 'srnumber';
                    }
                    
                    q = '?q=' + columnName + '%20eq%20%22' + columnVal + '%22';                    
                                
                    rows = getHistoricalCase(q);
                }
                when 'Service Request' {
                    //Lookup UCM Row Id to get CRM Row Id for SR - doesn't do what is needed yet b/c indirect lookup uses config, can't fake it.
                    /*if (columnName == 'account_crmAccountRowId') {                
                          columnVal = getCRMAccountRowId('UCM', (String) columnVal); 
                    }*/                
                
                    //Search on External Id needed translation to CRMP srnumber?
                    if (columnName == 'ExternalId') {
                        columnName = 'srnumber';
                    }
                    
                    q = '?q=' + columnName + '%20eq%20%22' + columnVal + '%22';                    
                                
                    rows = getHistoricalCase(q);
                }
             /*   when 'Start Assist Note' {
                    rows = getStartAssistNote(q);
                    }
             */
                when 'Account Property' {
                     if (columnName == 'ExternalId') {
                        columnName = 'crmAccountRowId';
                    }
                    q = '?q=' + columnName + '%20eq%20%22' + columnVal + '%22&i=properties';
                    rows = getAccountProperty(q);
                    //next 4 lines only for debug
                    System.debug('returned rows ' + rows);
                    for ( Integer k=0; k < rows.size(); k++ ) {
                    System.debug('Account Property Ext:'+ k + rows[k]);
                    }
                }
                
                when 'Account Source Key' {
                   if (columnName == 'ExternalId') {
                        //columnName = 'crmAccountRowId';
                       /*Object ak_id = filter.columnValue;
                       system.debug('ak_id ' + ak_id);
                       String apQuery = 'SELECT ExternalId,DisplayUrl,source__c,value1__c,value2__c,value3__c,value__c,taxWebsiteId__c,smsClientId__c,ooid__c,created__c,lastUpdated__c,crmAccountRowId__c,ucmAccountRowId__c,account_crmRowId__c  FROM Account_Source_Key__x WHERE ExternalId =\'' + ak_id + '\'';
                       system.debug('apQuery ' + apQuery);
                       List<Account_Source_Key__x> ak_row = Database.query(apQuery);
                       system.debug('ak row ' + ak_row);*/
                    }
                   else
                   {
                        q = '?q=' + columnName + '%20eq%20%22' + columnVal + '%22&i=keys';
                        rows = getAccountSourceKey(q);
                        //next 4 lines only for debug
                        System.debug('returned rows ' + rows);
                        for ( Integer k=0; k < rows.size(); k++ ) {
                        System.debug('Account Source Key:'+ k + rows[k]);
                    }
                       
                   }                    
                }
                
             /*when 'Contact Source Key' {
                    rows = getContactSourceKey(q);
             }
             */
            }
         //return DataSource.TableResult.get(c, DataSource.QueryUtils.process(c, rows));  

        } catch (Exception e) {
            System.debug(e);
        }
        System.debug('rows:'+ rows);
        return DataSource.TableResult.get(c, DataSource.QueryUtils.process(c, rows));
    }

    /* Enables Einstein Search - use sparingly
    override global List<DataSource.TableResult> search(DataSource.SearchContext c) {
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();

        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        for (Integer i =0; i< c.tableSelections.size();i++) {
            String table = c.tableSelections[i].tableSelected;
            String searchPhrase = c.searchPhrase;
            System.debug('searchPhrase:' + searchPhrase);
            System.debug(c);

            String q = '';

            switch on table {
                when 'Historical Case' {
                    //Only enable for search of SR Number
                    if (searchPhrase.indexOf('-') > 0) {
                        q = '?q=' + 'srnumber' + '%20eq%20%22' + searchPhrase + '%22';

                        System.debug('q: ' + q);
                        q = q.unescapeJava();
                        System.debug('unescape q: ' + q);
                        rows = getHistoricalCase(q);
                        results.add(DataSource.TableResult.get(true, null, table, getHistoricalCase(q)));
                    }
                }
                when 'Start Assist Note' {
                    //Not Allowed?
                }
                when 'Account Property' {
                     //Not Allowed?
                }
                when 'Account Source Key' {
                    //Allow on Source Key Value and only in certain situations like "TOPS 39939" or "KEY 3939" ???
                    rows = getAccountSourceKey(q);
                }
                when 'Contact Source Key' {
                    rows = getContactSourceKey(q);
                }
            }
        }
        return results;
    }
*/
    public static HttpResponse makeJsonCall(String method, String path, String page){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url + path + page);
        req.setMethod(method);
        req.setClientCertificateName('caet');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer Y3JtcC5nYXRld2F5LnYxLmZpdC5wYWFzY2xvdWQub25lYWRwLmNvbTpkYWVhMTI4Zi04NDcyLTQ3MTctYjAxYy05NGQyMDY1OTVlNzI=');
        // if (payload!=null){
        //     req.setBody(JSON.serialize(payload));
        // }
        req.setTimeout(30 * 1000);
        System.debug(req);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }

    /*
    public static String getCRMAccountRowId(String sourceName, String sourceKey){
        String crmAccountRowId = '';
        String path = '/autotest/accounts/v1/sourceName/' + sourceName + '/sourceKey/' + sourceKey;
        HttpResponse response = makeJsonCall('GET', path, '');

        System.debug(JSON.serializePretty(response.getBody()));
        Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

        List<Object> results=(List<Object>)responseBodyMap.get('results');

        if (results != null) {
            for (Integer i=0; i < results.size(); i++) {
                System.debug('results:' + i);
                Map<String, Object> result = (Map<String, Object>)results[i];

                if (result != null) {
                    crmAccountRowId  = (String) result.get('crmAccountRowId');
                }
            }
        }
        return crmAccountRowId;
    }
*/
    public static List<Map<String, Object>> getHistoricalCase(String q){

        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();
        String path = '/autotest/sr/v1/' + q;

        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');
            System.debug('Webhook.Connection results.size: ' + results.size());

            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    System.debug('results:' + i);

                    Map<String, Object> result = (Map<String, Object>)results[i];

                    if (result != null) {
                        row = upsertRow(result, row, null, 'srnumber');
                        row.put('DisplayUrl', 'https://fit.quicktix.adpcorp.com/vcrm/#/sr/' + result.get('srnumber'));                                              
                        //row.put('DisplayUrl', 'https://crmp-portal-fit.nj.adp.com/vcrm/#/sr/' + result.get('srnumber'));

                        Map<String, Object> child=(Map<String, Object>) result.get('account');

                        if (child != null) {
                            row = upsertRow(child, row, 'account', null);
                        }

                        child=(Map<String, Object>) result.get('asset');
                        if (child != null) {
                            row = upsertRow(child, row, 'asset', null);
                        }

                        child=(Map<String, Object>) result.get('contact');
                        if (child != null) {
                            row = upsertRow(child, row, 'contact', null);
                        }

                        child=(Map<String, Object>) result.get('owner');
                        if (child != null) {
                            row = upsertRow(child, row, 'owner', null);
                        }
                    }
                    rows.add(row);
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        return rows;
    }

    /*
    public static List<Map<String, Object>> getStartAssistNote(String q){
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();

        String path = 'crmprovider/api/crm/v1/autotest/views/query/startAssistNotes/' + q;

        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');

            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    System.debug('results:' + i);

                    Map<String, Object> result = (Map<String, Object>)results[i];

                    if (result != null) {
                        row = upsertRow(result, row, null, 'id');  
                    }
                    rows.add(row);
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        return rows;
    }
*/
    public static List<Map<String, Object>> getAccountProperty(String q){
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();

        String path = '/autotest/accounts/v1/' + q;
        System.debug('Path :'+ path);
        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');
            System.debug('Results Size:' + results.size());
            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    Map<String, Object> result = (Map<String, Object>)results[i];
                    System.debug('results:' + i + results[i]);
                    System.debug('result:' + i + result);
                    
                    // Added on 05192022 -  Start
                    String crmAccountRowId = (String)result.get('crmAccountRowId');
                    String ucmAccountRowId = (String)result.get('ucmAccountRowId');
                    System.debug('crmAccountRowId:' + crmAccountRowId);
                    if (result!= null)
                    {
                      for (String key : result.keySet())
                      {
                          if (key == 'properties')
                         {
                            List<Object> acc_properties = (List<Object>)result.get(key);
                            System.debug('acc_properties' + acc_properties);
                            for (Integer j=0; j < acc_properties.size(); j++)
                            {
                                System.debug('Account Property #:' + j);
                                Map<String, Object> property = (Map<String, Object>)acc_properties[j];
                                System.debug('Account Property Map:' + property);
                                String ExternalId = (String)property.get('id');
                                if (property != null) 
                                {
                                    property.put('crmAccountRowId', crmAccountRowId);
                                    property.put('ucmAccountRowId', ucmAccountRowId);
                                    property.put('ExternalId', ExternalId);
                                    property.put('DisplayUrl', 'https://fit.quicktix.adpcorp.com/vcrm/');
                                }
                                //row = upsertRow(property, row, null, 'ExternalId');  //replace id with external id
                                row = property;
                                System.debug('rowNow #' + j + row);
                                rows.add(row);
                                System.debug('rowsNow #' + j + rows);
                            }
                             
                         }
                          
                      }  
                        
                    }
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        System.debug('rowsNow #' + rows); //added on 0520
        System.debug('size of rows #' + rows.size());
        return rows;
    }
    
            public static List<Map<String, Object>> getAccountSourceKey(String q){
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();

        String path = '/autotest/accounts/v1/' + q;
        System.debug('Path :'+ path);
        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');
            System.debug('Results Size:' + results.size());
            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    Map<String, Object> result = (Map<String, Object>)results[i];
                    System.debug('results:' + i + results[i]);
                    System.debug('result:' + i + result);
                    
                    // Added on 05192022 -  Start
                    String crmAccountRowId = (String)result.get('crmAccountRowId');
                    String ucmAccountRowId = (String)result.get('ucmAccountRowId');
                    System.debug('crmAccountRowId:' + crmAccountRowId);
                    if (result!= null)
                    {
                      for (String key : result.keySet())
                      {
                          if (key == 'keys')
                         {
                            List<Object> acc_source_keys = (List<Object>)result.get(key);
                            System.debug('acc_source_keys' + acc_source_keys);
                            for (Integer j=0; j < acc_source_keys.size(); j++)
                            {
                                System.debug('acc_source_key #:' + j);
                                Map<String, Object> acc_key = (Map<String, Object>)acc_source_keys[j];
                                System.debug('acc_source_key Map:' + acc_key);
                                String ExternalId = (String)acc_key.get('id');
                                if (acc_key != null) 
                                {
                                    acc_key.put('crmAccountRowId', crmAccountRowId);
                                    acc_key.put('ucmAccountRowId', ucmAccountRowId);
                                    acc_key.put('ExternalId', ExternalId);
                                    acc_key.put('DisplayUrl', 'https://fit.quicktix.adpcorp.com/vcrm/');
                                }
                                //row = upsertRow(acc_key, row, null, 'ExternalId');  //replace id with external id
                                row = acc_key;
                                System.debug('rowNow #' + j + row);
                                rows.add(row);
                                System.debug('rowsNow #' + j + rows);
                            }
                             
                         }
                          
                      }  
                        
                    }
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        System.debug('rowsNow #' + rows); //added on 0520
        System.debug('size of rows #' + rows.size());
        return rows;
    }
/*
    public static List<Map<String, Object>> getAccountSourceKey(String q){
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();

        String path = '/autotest/accounts/v1/' + q;

        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');

            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    System.debug('results:' + i);

                    Map<String, Object> result = (Map<String, Object>)results[i];

                    if (result != null) {
                        row = upsertRow(result, row, null, 'id');  //replace id with external id
                    }
                    rows.add(row);
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        return rows;
    }

    public static List<Map<String, Object>> getContactSourceKey(String q){
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row = new Map<String, Object>();

        String path = '/tbd/' + q;

        try {
            HttpResponse response = makeJsonCall('GET',path, '&page=0,30');
            System.debug(JSON.serializePretty(response.getBody()));

            Map<String, Object> responseBodyMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

            List<Object> results=(List<Object>)responseBodyMap.get('results');

            if (results != null) {
                for (Integer i=0; i < results.size(); i++) {
                    row = new Map<String, Object>();
                    System.debug('results:' + i);

                    Map<String, Object> result = (Map<String, Object>)results[i];

                    if (result != null) {
                        row = upsertRow(result, row, null, 'id');  //replace id with external id
                    }
                    rows.add(row);
                }
            }
        }catch(Exception e) {
            System.debug(e);
        }
        return rows;
    }
*/
    /* Helper class to upsert the records into the SF External Objects
       prefix:     Denormalize back to the SF Field name with the underscore.  Ex: account_name
       ExternalId: Required?  Unique identifier in source.
    */
    public static Map<String, Object> upsertRow(Map<String, Object> result, Map<String, Object> row, String prefix, String ExternalId){

        for ( String key : result.keySet() ) {
            System.debug('Webhook.Connection upsertRow ' + prefix + ' ' + 'key: ' + key + ' value: ' + result.get(key));
            
            //Set the ExternalId
            if (ExternalId == key) {
                row.put('ExternalId', result.get(key));
            }

            if (prefix != null) {
                row.put(prefix + '_' + key, result.get(key));
            } else {
                row.put(key, result.get(key));
            }
        }
        return row;
    }
}