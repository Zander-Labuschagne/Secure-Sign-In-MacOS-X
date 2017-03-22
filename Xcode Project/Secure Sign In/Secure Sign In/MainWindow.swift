//
//  ViewController.swift
//  Secure Sign In
//
//  Created by Zander Labuschagne on 2015/11/19.
//  Copyright © 2015 Cryogen Software. All rights reserved.
//

//GUI
import Cocoa

//My own method to convert char to ascii value added to all char types
extension Character
{
    func toASCII() -> Int
    {
        let char = String(self);
        let ascii = char.unicodeScalars;
        
        return (Int)(ascii[ascii.startIndex].value);
    }
}

//My own method to convert ascii int to char added to all int types
extension Int
{
    func toChar() -> Character
    {
        return (Character)((UnicodeScalar)(self));
    }
}

class MainWindow: NSViewController, NSSharingServiceDelegate
{
    //enum is needed to throw exceptions
    enum InputError: ErrorType //InputError - Name of exceprtion
    {
        case passwordEmpty;
        case keyEmpty;
    }
    
    var cipherPassword = [Character]();

    override var representedObject: AnyObject?
    {
        didSet
        {
        }
    }
    @IBOutlet weak var pswPassword: NSSecureTextField!
    @IBOutlet weak var pswKey: NSSecureTextField!
    @IBOutlet weak var btnEncryptPassword: NSButton!
    @IBOutlet weak var pubLimiter: NSPopUpButton!
    @IBOutlet weak var imvLogo: NSImageView!
    
    
    
    func encrypt(plainPassword: [Character], key: [Character], limit: Int) -> [Character]
    {
        var password = [Character]();//Declaring empty char array
        var cipherPassword = [Character]();
        var keyIndex = 0;
        var temp: Int;
        var specCharCount = 0;
        var pos = 0;
        var specChars = [Character]();
        
        //for(var iii = 0; iii < userPassword.count; iii++)
        for t in plainPassword
        {
            if (t.toASCII() >= 65 && t.toASCII() <= 90 )//Encrypting Uppercase Characters
            {
                temp = t.toASCII() - 65 + (key[keyIndex].toASCII() - 65);
                
                if (t.toASCII() < 0)
                {
                    temp += 26;
                }
                if (t.toASCII() <= 0)
                {
                    temp += 26;
                }
                
                password.append((65 + (temp % 26)).toChar());
													
																//keyIndex += 1;Swift 3
																//if(keyIndex == key.count)//Swift 3
                if (++keyIndex == key.count)//Swift2
                {
                    keyIndex = 0;
                }
            }
                
            else if (t.toASCII() >= 97 && t.toASCII() <= 122)//Encrypting Lower Case Characters
            {
                temp = t.toASCII() - 97 + (key[keyIndex].toASCII() - 97);
                
                if (temp < 0)
                {
                    temp += 26;
                }
                if (temp < 0)
                {
                    temp += 26;
                }
                
                password.append((97 + (temp % 26)).toChar());

																//keyIndex += 1;//Swift 3
																//if(keyIndex == key.count)//Swift 3
                if (++keyIndex == key.count)//Swift 2
                {
                    keyIndex = 0;
                }
            }
                
            else//Encrypting Special Characters
            {
                specChars.append((pos + 65).toChar());
                specChars.append(t);
                specCharCount++;//Swift 2
																//specCharCount += 1;//Swift 3
            }
            pos++;//Swift 2
												//pos += 1;//Swift 3
									
        }
        cipherPassword.append(specCharCount == 0 ? 65.toChar() : (--specCharCount + 65).toChar());//Encrypting Amount of Special Characters in Password
        cipherPassword += specChars;
        cipherPassword += password;
    
        if(cipherPassword.count > 32)
        {
            let notification = NSAlert();//MessageBox
            notification.messageText = "Warning";
            notification.informativeText = "Password is greater than 32 characters";
            notification.runModal();//Show MessageBox
        }
        
        
        //Shuffle Password
        var evens = [Character]();
        var odds = [Character]();
        for c in cipherPassword
        {
            if(c.toASCII() % 2 == 0)
            {
                //evens.addLast(c);
                evens.append(c);
            }
            else
            {
                //odds.addFirst(c);
                odds.insert(c, atIndex: 0);
            }
        }
        
        var iv = 0;
        while(!evens.isEmpty || !odds.isEmpty)
        {
            if (!odds.isEmpty)
            {
                //iv += 1;//Swift 3
                //cipherPassword[iv] = odds.removeFirst();//Swift 3
                cipherPassword[iv++] = odds.removeFirst();//Swift 2
            }
            if(!evens.isEmpty)
            {
                //iv += 1;
                //cipherPassword[iv] = evens.removeFirst();//Swift 3
                cipherPassword[iv++] = evens.removeFirst();//Swift 2
            }
        }
        
        //encrypt special chars further
        var i = 0;
        for v in cipherPassword
        {
            var ii = v.toASCII();
            if(v.toASCII() <= 47)
            {
                ii += 10;
                //cipherPassword[i] = ii.toChar();
            }
            else if(v.toASCII() > 47 && v.toASCII() < 64)
            {
                ii -= 5;
                //cipherPassword[v] = ii.toChar();
            }
            else if(v.toASCII() > 90 && v.toASCII() <= 96)
            {
                if(cipherPassword.count % 2 == 0)
                {
                    ii += 2;
                    //cipherPassword[v] = ii.toChar();
                }
                else
                {
                    ii -= 2;
                }
            }
            cipherPassword[i] = ii.toChar();
            i++;//Swift 2
            //i += 1;//Swift 3
        }
        
        //Replacing unloved characters
        var iii = 0;
        for vi in cipherPassword
        {
            if(vi.toASCII() == 34)
            {
                cipherPassword[iii] = 123.toChar();
            }
            else if(vi.toASCII() == 38)
            {
                cipherPassword[iii] = 124.toChar();
            }
            else if(vi.toASCII() == 60)
            {
                cipherPassword[iii] = 125.toChar();
            }
            else if(vi.toASCII() == 62)
            {
                cipherPassword[iii] = 126.toChar();
            }
            //iii += 1;//Swift 3
            iii++;//Swift 2
        }
        
        //Limitations
        var cipherPasswordLimited = [Character]();
        var vii = 0;
        //for(int vii = 0; vii < cipherPassword.length && vii < limit; vii++)
        while(vii < cipherPassword.count && vii < limit)
        {
            cipherPasswordLimited.append(cipherPassword[vii++]);//Swift 2
            //cipherPasswordLimited.append(cipherPassword[vii]);//Swift 3
            //vii += 1;//Swift 3
        }
        
        return cipherPasswordLimited;
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return true;//!pause;
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "osdOutput")
        {
            let output = segue.destinationController as! OSDOutputWindow;
            output.password = cipherPassword;
        }
    }
   
    @IBAction func btnEncryptPassword_Click(sender: NSButton)
    {
        do
        {
            if(pswPassword.stringValue.isEmpty)
            {
                throw InputError.passwordEmpty;
            }
            if(pswKey.stringValue.isEmpty)
            {
                throw InputError.keyEmpty;
            }
            
            //let = constant
            //var = variable
            let plainPassword = [Character](pswPassword.stringValue.characters);
            let key = [Character](pswKey.stringValue.characters);//Convert String to char array
            var limit = 32;
            if(pubLimiter.selectedItem != nil && pubLimiter.selectedItem?.title == "20")
            {
                limit = 20;
            }
												else if(pubLimiter.selectedItem != nil && pubLimiter.selectedItem?.title == "12")
            {
                limit = 12;
            }
												else if(pubLimiter.selectedItem != nil && pubLimiter.selectedItem?.title == "10")
            {
                limit = 10;
            }
												else if(pubLimiter.selectedItem != nil && pubLimiter.selectedItem?.title == "8")
												{
                limit = 8;
            }
            cipherPassword = encrypt(plainPassword, key: key, limit: limit);
									
            performSegueWithIdentifier("osdOutput", sender: self);
        }
        catch InputError.passwordEmpty
        {
            //pause = true;
            pswPassword.becomeFirstResponder();
            let errorMessage = NSAlert();//MessageBox
            errorMessage.messageText = "Enter a Password";
            errorMessage.informativeText = "Please Enter a Password";
            errorMessage.runModal();//Show MessageBox
        }
        catch InputError.keyEmpty
        {
            //pause = true;
            pswKey.becomeFirstResponder();
            let errorMessage = NSAlert();//MessageBox
            errorMessage.messageText = "Enter a Key";
            errorMessage.informativeText = "Please Enter a Key";
            errorMessage.runModal();//Show MessageBox
        }
        catch
        {
            
        }

    }
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
				override func viewDidAppear()
				{
                    super.viewDidAppear();
                    self.view.window!.title = "Cryogen Software: Secure Sign In V2.1";
																				
					
                    let limits = ["8", "10", "12", "20", "32"];
                    pubLimiter.removeAllItems();
                    pubLimiter.addItemsWithTitles(limits);
                    pubLimiter.selectItemAtIndex(4);
                    
                    pswPassword.becomeFirstResponder();
				}
    
}

