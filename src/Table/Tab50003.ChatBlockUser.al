table 50003 "Chat Block User"
{
    Caption = 'Chat Block User';
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
        field(2; "Blocked User Name"; Code[50])
        {
            Caption = 'Blocked User Name';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Chat User"."User Name";
        }
        field(3; "Blocked Full Name"; Text[80])
        {
            Caption = 'Blocked Full Name';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Name" = field("Blocked User Name")));
            Editable = false;
        }
        field(4; "Full Name"; Text[80])
        {
            Caption = 'Full Name';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Name" = field("User Name")));
            Editable = false;
        }
        field(5; TestISD; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "User Name","Blocked User Name")
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
