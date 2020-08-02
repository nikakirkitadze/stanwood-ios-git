# Stanwood Test Project

# Layers
<ul>
<li>Domain Layer</li>
<li>Data Repositories Layer = Repositories Implementations + API (Network) + Filemanager</li>
<li>Presentation Layer (MVVM) = ViewModels + Views</li>
</ul>

# Architecture concepts used here

<ul>
  <li><a href="https://github.com/nikakirkitadze/stanwood-ios-git/tree/master/Stanwood%20iOS%20Git/Preesentation/ViewModel">MVVM</a></li>
  <li>Error handling examples: in <a href="https://github.com/nikakirkitadze/stanwood-ios-git/blob/26c1733f5a2d14f898719004f65a345a6ac41dca/Stanwood%20iOS%20Git/Infrastructure/Network/WebServiceOperation.swift#L98">Networking</a></li>
  <li>UIKit view implementations by reusing same ViewModel (at least Xcode 11 required)</li>
</ul>

# Includes

<ul>
  <li><a href="https://cocoapods.org/pods/Kingfisher">Kingfisher</a> For asynchronous image downloading and caching.</li>
  <li><a href="https://github.com/ashleymills/Reachability.swift">Reachability</a>To notify of network interface changes</li>
</ul>

# Networking

  Applying generic, modular network layer. The solution includes Generic Type, Completion, Singleton, Codable, URLSession and OOP(Object Oriented Programming) terms.

# Requirements

  Xcode Version 11.2.1+ Swift 5.0+
