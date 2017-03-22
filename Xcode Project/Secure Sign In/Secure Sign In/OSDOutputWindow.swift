//
//  SecureSignInOutputWindow.swift
//  Secure Sign In
//
//  Created by Zander Labuschagne on 2015/11/20.
//  Copyright © 2015 Cryon Software. All rights reserved.
//

import Cocoa

class OSDOutputWindow: NSViewController
{
    var password = [Character]();
    var status = 0;
    var str = "";
    
    @IBOutlet weak var txtEncryptedPassword: NSTextField!
    @IBOutlet weak var btnHide: NSButton!
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder);
    }

    override func viewDidLoad()
    {
        for _ in password
        {
            str += "*";
        }
        self.txtEncryptedPassword.stringValue = str;
								self.txtEncryptedPassword.font = NSFont(name: "PT MONO", size: 12)
        super.viewDidLoad();
        
    }
    @IBAction func btnHide_Click(sender: NSButton)
    {
        if status == 0
        {
            btnHide.title = "Hide Password";
            status = 1;
            txtEncryptedPassword.stringValue = (String)(password);
        }
        else
        {
            btnHide.title = "Reveal Password";
            status = 0;
            txtEncryptedPassword.stringValue = str;
        }
    }
    
    @IBAction func btnCopy_Clicked(sender: NSButton)
    {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents();
        pasteboard.writeObjects([(String)(password)]);
        self.dismissViewController(self);
    }
    
    @IBAction func btnOK_Clicked(sender: NSButton)
    {
        self.dismissController(self);//this.close();
    }
}
