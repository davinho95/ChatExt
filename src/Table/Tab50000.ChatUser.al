table 50000 "Chat User"
{
    Caption = 'Chat User';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User Name"; Code[50])
        {
            Caption = 'User Name';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Full Name"; Text[80])
        {
            Caption = 'Full Name';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Name" = field("User Name")));
            Editable = false;
        }
        field(3; Available; Boolean)
        {
            Caption = 'Available';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "User Name")
        {
            Clustered = true;
        }
    }

}
