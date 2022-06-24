@isTest
public class AccountNewTest

{
    static testMethod void addNewAccount()
        {
            Account acc=new Account();
            acc.Name='CHASE BANK';
         //   acc.NubmerOfEmployees=12;
            insert acc;
        }
        
            static testMethod void addNewAccountWithouAcctName()
        {
            Account acc=new Account();
            acc.Name='CHASE BANK';
         //   acc.NubmerOfEmployees=12;
            insert acc;
        }
}