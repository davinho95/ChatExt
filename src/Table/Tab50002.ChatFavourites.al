table 50002 "Chat Favourites"
{
    Caption = 'Chat Favourites';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "User Name"; Code[50])
        {
            Caption = 'User Name';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = "Chat User"."User Name";
        }
        field(2; "Favourite User Name"; Code[50])
        {
            Caption = 'Favourite User Name';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = "Chat User"."User Name";
        }
        field(3; "Favourite Full Name"; Text[80])
        {
            Caption = 'Favourite Name';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Name" = field("Favourite User Name")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "User Name","Favourite User Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        
    begin
        "User Name" := UserId();    
    end;
    
}
