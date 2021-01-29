// Pre-setup

//Reset the default admin user password because Scratch orgs don't supply password to be able to login directly
User iu = [select id from User where IsActive=true and Profile.Name='Analytics Cloud Integration User' limit 1];
User au = [select id from User where IsActive=true and Profile.Name='System Administrator' limit 1];
PermissionSet pro = [select id from PermissionSet where Name='PartnerIntelligence_RO'];
PermissionSet prw = [select id from PermissionSet where Name='PartnerIntelligence_RW'];



List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();


psa.add(new PermissionSetAssignment(PermissionSetId = pro.id, AssigneeId = iu.id));
psa.add(new PermissionSetAssignment(PermissionSetId = prw.id, AssigneeId = au.id));

insert psa;