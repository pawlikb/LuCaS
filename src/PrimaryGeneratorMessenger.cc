// *********************************************************
// *                         Mokka                         *
// *    -- A detailed Geant 4 simulation for the ILC --    *
// *                                                       *
// *  polywww.in2p3.fr/geant4/tesla/www/mokka/mokka.html   *
// *********************************************************
//
// $Id$
// $Name: mokka-06-07-patch02 $

#include "PrimaryGeneratorMessenger.hh"
#include "PrimaryGeneratorAction.hh"
#include "VPrimaryGenerator.hh"

#include "G4UIdirectory.hh"
#include "G4UIcmdWithAString.hh"
#include "G4UIcmdWithoutParameter.hh"

PrimaryGeneratorMessenger::PrimaryGeneratorMessenger(PrimaryGeneratorAction *primaryGenerator)
{
  fPrimaryGenerator = primaryGenerator;

  fGeneratorDir = new G4UIdirectory("/generator/");
  fGeneratorDir->SetGuidance("Primary generator control commands.");
  
  fGeneratorNameCmd = new G4UIcmdWithAString("/generator/generator", this);
  fGeneratorNameCmd->SetGuidance("Select primary generator.");
  fGeneratorNameCmd->SetGuidance("Available generators: \"particleGun\" or a filename with suffix");
  fGeneratorNameCmd->SetGuidance("  \".HEPEvt\" - ASCII file in reduced HEPEvt common block format");
  /* ...insert any other interfaces here... */
  fGeneratorNameCmd->SetParameterName("generator", true);
  fGeneratorNameCmd->SetDefaultValue("particleGun");

  fGeneratorInfoCmd = new G4UIcmdWithoutParameter("/generator/info", this);
  fGeneratorInfoCmd->SetGuidance("Print some information about the next shot.");

}

PrimaryGeneratorMessenger::~PrimaryGeneratorMessenger(void)
{
  delete fGeneratorNameCmd;
  delete fGeneratorDir;
}

void PrimaryGeneratorMessenger::SetNewValue(G4UIcommand *command, G4String newValue)
{
  if(command == fGeneratorNameCmd)       
		fPrimaryGenerator->SetGeneratorWithName(newValue);
  else if(command == fGeneratorInfoCmd)
		fPrimaryGenerator->GetPrimaryGenerator()->PrintGeneratorInfo();
}

G4String PrimaryGeneratorMessenger::GetCurrentValue(G4UIcommand *command)
{
  if(command == fGeneratorNameCmd)       
	return fPrimaryGenerator->GetPrimaryGenerator()->GetGeneratorName();
  return G4String(); // nothing
}
