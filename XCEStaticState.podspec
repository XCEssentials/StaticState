projName = 'StaticState'
projSummary = 'Turn any object into a discrete system where each state is a static data container.'
companyPrefix = 'XCE'
companyName = 'XCEssentials'
companyGitHubAccount = 'https://github.com/' + companyName
companyGitHubPage = 'https://' + companyName + '.github.io'

#===

Pod::Spec.new do |s|

  s.name                      = companyPrefix + projName
  s.summary                   = projSummary
  s.version                   = '1.2.1'
  s.homepage                  = companyGitHubAccount + '/' + projName
  
  s.documentation_url         = companyGitHubPage + '/' + projName

  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }
  s.source_files              = 'Sources/**/*.swift'

  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true
  
  # s.dependency                'AAA', '~> X.Y.Z'

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }
  
end
