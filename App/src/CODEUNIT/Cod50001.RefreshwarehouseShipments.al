codeunit 50001 "RefreshwarehouseShipments"
{
    procedure Refresh();
    var
        warehouseShipments: Record "Warehouse Shipment Header";
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
        HttpContent: HttpContent;
        RequestJson: text;
    begin
        //warehouseShipments.DeleteAll;

        // Simple web service call
        //HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        HttpContent.Clear();
        HttpContent.WriteFrom(RequestJson);
        AddHttpBasicAuthHeader('CAMALET', 'SVdyHJaR09dAcUAjQ1RwSWjpHjKK8M8mYwUn7MyUKuY=', HttpClient);
        if not HttpClient.Post(
            'https://api.businesscentral.dynamics.com/v2.0/6bc0bdda-9426-471f-a6cc-968322588dee/Sandbox/api/sbsiconsulting/Supply/v2.0/companies(f7cfbd17-e1d8-ea11-a814-000d3a898443)/warehouseShipments(41ae67f9-13bd-4da8-b8c5-e45e50f454a2)/Microsoft.NAV.post'
            , HttpContent
            , ResponseMessage)
        then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\' +
                  'Status code: %1' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);

        /* ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
        if not JsonArray.ReadFrom(JsonText) then begin
            // probably single object
            JsonToken.ReadFrom(JsonText);
            InsertwarehouseShipments(JsonToken);
        end else begin
            // array
            for i := 0 to JsonArray.Count - 1 do begin
                JsonArray.Get(i, JsonToken);
                InsertwarehouseShipments(JsonToken);
            end;
        end; */
    end;

    procedure InsertwarehouseShipments(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        warehouseShipments: Record "warehouse shipment header";
    begin
        JsonObject := JsonToken.AsObject;

        /*         warehouseShipments.init;

                //warehouseShipments."@odata.context" := COPYSTR(GetJsonToken(JsonObject, '@odata.context').AsValue.AsText, 1, 250);
                //warehouseShipments."@odata.etag" := COPYSTR(GetJsonToken(JsonObject, '@odata.etag').AsValue.AsText, 1, 250);
                warehouseShipments."Id" := COPYSTR(GetJsonToken(JsonObject, 'Id').AsValue.AsText, 1, 250);
                warehouseShipments."OfferNo" := COPYSTR(GetJsonToken(JsonObject, 'OfferNo').AsValue.AsText, 1, 250);
                warehouseShipments."TrackingNo" := COPYSTR(GetJsonToken(JsonObject, 'TrackingNo').AsValue.AsText, 1, 250);

                warehouseShipments.Insert; */
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := Base64Helpers.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        message(AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;

}
