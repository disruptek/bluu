
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LUIS Authoring Client
## version: 2.0
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-LUIS-Authoring"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppsAdd_568201 = ref object of OpenApiRestCall_567668
proc url_AppsAdd_568203(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_568202(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new LUIS app.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationCreateObject: JObject (required)
  ##                          : An application containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is "0.1". Note: the culture cannot be changed after the app is created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_AppsAdd_568201; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_AppsAdd_568201; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : An application containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is "0.1". Note: the culture cannot be changed after the app is created.
  var body_568207 = newJObject()
  if applicationCreateObject != nil:
    body_568207 = applicationCreateObject
  result = call_568206.call(nil, nil, nil, nil, body_568207)

var appsAdd* = Call_AppsAdd_568201(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_568202, base: "",
                                url: url_AppsAdd_568203, schemes: {Scheme.Https})
type
  Call_AppsList_567890 = ref object of OpenApiRestCall_567668
proc url_AppsList_567892(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_567891(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the user's applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568065 = query.getOrDefault("skip")
  valid_568065 = validateParameter(valid_568065, JInt, required = false,
                                 default = newJInt(0))
  if valid_568065 != nil:
    section.add "skip", valid_568065
  var valid_568066 = query.getOrDefault("take")
  valid_568066 = validateParameter(valid_568066, JInt, required = false,
                                 default = newJInt(100))
  if valid_568066 != nil:
    section.add "take", valid_568066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568089: Call_AppsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user's applications.
  ## 
  let valid = call_568089.validator(path, query, header, formData, body)
  let scheme = call_568089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568089.url(scheme.get, call_568089.host, call_568089.base,
                         call_568089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568089, url, valid)

proc call*(call_568160: Call_AppsList_567890; skip: int = 0; take: int = 100): Recallable =
  ## appsList
  ## Lists all of the user's applications.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  var query_568161 = newJObject()
  add(query_568161, "skip", newJInt(skip))
  add(query_568161, "take", newJInt(take))
  result = call_568160.call(nil, query_568161, nil, nil, nil)

var appsList* = Call_AppsList_567890(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_567891, base: "",
                                  url: url_AppsList_567892,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_568208 = ref object of OpenApiRestCall_567668
proc url_AppsListCortanaEndpoints_568210(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_AppsListCortanaEndpoints_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_AppsListCortanaEndpoints_568208): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_568212.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_568208(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_568209,
    base: "", url: url_AppsListCortanaEndpoints_568210, schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_568213 = ref object of OpenApiRestCall_567668
proc url_AppsListSupportedCultures_568215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_568214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_AppsListSupportedCultures_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_AppsListSupportedCultures_568213): Recallable =
  ## appsListSupportedCultures
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  result = call_568217.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_568213(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_568214, base: "",
    url: url_AppsListSupportedCultures_568215, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_568223 = ref object of OpenApiRestCall_567668
proc url_AppsAddCustomPrebuiltDomain_568225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_568224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_AppsAddCustomPrebuiltDomain_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_AppsAddCustomPrebuiltDomain_568223;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_568229 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_568229 = prebuiltDomainCreateObject
  result = call_568228.call(nil, nil, nil, nil, body_568229)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_568223(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_568224, base: "",
    url: url_AppsAddCustomPrebuiltDomain_568225, schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_568218 = ref object of OpenApiRestCall_567668
proc url_AppsListAvailableCustomPrebuiltDomains_568220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_AppsListAvailableCustomPrebuiltDomains_568218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_AppsListAvailableCustomPrebuiltDomains_568218): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_568222.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_568218(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_568219, base: "",
    url: url_AppsListAvailableCustomPrebuiltDomains_568220,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568230 = ref object of OpenApiRestCall_567668
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_568232(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "culture" in path, "`culture` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/customprebuiltdomains/"),
               (kind: VariableSegment, value: "culture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_568231(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all the available prebuilt domains for a specific culture.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   culture: JString (required)
  ##          : Culture.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `culture` field"
  var valid_568247 = path.getOrDefault("culture")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "culture", valid_568247
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available prebuilt domains for a specific culture.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568230;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_568250 = newJObject()
  add(path_568250, "culture", newJString(culture))
  result = call_568249.call(path_568250, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_568230(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_568231,
    base: "", url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_568232,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_568251 = ref object of OpenApiRestCall_567668
proc url_AppsListDomains_568253(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_568252(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the available application domains.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568254: Call_AppsListDomains_568251; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_AppsListDomains_568251): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_568255.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_568251(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_568252, base: "", url: url_AppsListDomains_568253,
    schemes: {Scheme.Https})
type
  Call_AppsImport_568256 = ref object of OpenApiRestCall_567668
proc url_AppsImport_568258(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_568257(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   appName: JString
  ##          : The application name to create. If not specified, the application name will be read from the imported object. If the application name already exists, an error is returned.
  section = newJObject()
  var valid_568259 = query.getOrDefault("appName")
  valid_568259 = validateParameter(valid_568259, JString, required = false,
                                 default = nil)
  if valid_568259 != nil:
    section.add "appName", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_AppsImport_568256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_AppsImport_568256; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object. If the application name already exists, an error is returned.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var query_568263 = newJObject()
  var body_568264 = newJObject()
  add(query_568263, "appName", newJString(appName))
  if luisApp != nil:
    body_568264 = luisApp
  result = call_568262.call(nil, query_568263, nil, nil, body_568264)

var appsImport* = Call_AppsImport_568256(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_568257,
                                      base: "", url: url_AppsImport_568258,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_568265 = ref object of OpenApiRestCall_567668
proc url_AppsListUsageScenarios_568267(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_568266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the application available usage scenarios.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_AppsListUsageScenarios_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_AppsListUsageScenarios_568265): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_568269.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_568265(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_568266,
    base: "", url: url_AppsListUsageScenarios_568267, schemes: {Scheme.Https})
type
  Call_AppsUpdate_568277 = ref object of OpenApiRestCall_567668
proc url_AppsUpdate_568279(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdate_568278(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name or description of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568280 = path.getOrDefault("appId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "appId", valid_568280
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_AppsUpdate_568277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_AppsUpdate_568277; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_568284 = newJObject()
  var body_568285 = newJObject()
  add(path_568284, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_568285 = applicationUpdateObject
  result = call_568283.call(path_568284, nil, nil, nil, body_568285)

var appsUpdate* = Call_AppsUpdate_568277(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_568278,
                                      base: "", url: url_AppsUpdate_568279,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_568270 = ref object of OpenApiRestCall_567668
proc url_AppsGet_568272(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGet_568271(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the application info.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568273 = path.getOrDefault("appId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "appId", valid_568273
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_AppsGet_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_AppsGet_568270; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568276 = newJObject()
  add(path_568276, "appId", newJString(appId))
  result = call_568275.call(path_568276, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_568270(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_568271, base: "",
                                url: url_AppsGet_568272, schemes: {Scheme.Https})
type
  Call_AppsDelete_568286 = ref object of OpenApiRestCall_567668
proc url_AppsDelete_568288(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsDelete_568287(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568289 = path.getOrDefault("appId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "appId", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : A flag to indicate whether to force an operation.
  section = newJObject()
  var valid_568290 = query.getOrDefault("force")
  valid_568290 = validateParameter(valid_568290, JBool, required = false,
                                 default = newJBool(false))
  if valid_568290 != nil:
    section.add "force", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_AppsDelete_568286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_AppsDelete_568286; appId: string; force: bool = false): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   force: bool
  ##        : A flag to indicate whether to force an operation.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(query_568294, "force", newJBool(force))
  add(path_568293, "appId", newJString(appId))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var appsDelete* = Call_AppsDelete_568286(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_568287,
                                      base: "", url: url_AppsDelete_568288,
                                      schemes: {Scheme.Https})
type
  Call_AzureAccountsAssignToApp_568303 = ref object of OpenApiRestCall_567668
proc url_AzureAccountsAssignToApp_568305(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsAssignToApp_568304(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assigns an Azure account to the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568306 = path.getOrDefault("appId")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "appId", valid_568306
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_568307 = header.getOrDefault("Authorization")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "Authorization", valid_568307
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_AzureAccountsAssignToApp_568303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assigns an Azure account to the application.
  ## 
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_AzureAccountsAssignToApp_568303; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsAssignToApp
  ## Assigns an Azure account to the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568311 = newJObject()
  var body_568312 = newJObject()
  if azureAccountInfoObject != nil:
    body_568312 = azureAccountInfoObject
  add(path_568311, "appId", newJString(appId))
  result = call_568310.call(path_568311, nil, nil, nil, body_568312)

var azureAccountsAssignToApp* = Call_AzureAccountsAssignToApp_568303(
    name: "azureAccountsAssignToApp", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsAssignToApp_568304, base: "",
    url: url_AzureAccountsAssignToApp_568305, schemes: {Scheme.Https})
type
  Call_AzureAccountsGetAssigned_568295 = ref object of OpenApiRestCall_567668
proc url_AzureAccountsGetAssigned_568297(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsGetAssigned_568296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568298 = path.getOrDefault("appId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "appId", valid_568298
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_568299 = header.getOrDefault("Authorization")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "Authorization", valid_568299
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_AzureAccountsGetAssigned_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_AzureAccountsGetAssigned_568295; appId: string): Recallable =
  ## azureAccountsGetAssigned
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568302 = newJObject()
  add(path_568302, "appId", newJString(appId))
  result = call_568301.call(path_568302, nil, nil, nil, nil)

var azureAccountsGetAssigned* = Call_AzureAccountsGetAssigned_568295(
    name: "azureAccountsGetAssigned", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsGetAssigned_568296, base: "",
    url: url_AzureAccountsGetAssigned_568297, schemes: {Scheme.Https})
type
  Call_AzureAccountsRemoveFromApp_568313 = ref object of OpenApiRestCall_567668
proc url_AzureAccountsRemoveFromApp_568315(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/azureaccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AzureAccountsRemoveFromApp_568314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes assigned Azure account from the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568316 = path.getOrDefault("appId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "appId", valid_568316
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_568317 = header.getOrDefault("Authorization")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "Authorization", valid_568317
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_AzureAccountsRemoveFromApp_568313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes assigned Azure account from the application.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_AzureAccountsRemoveFromApp_568313; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsRemoveFromApp
  ## Removes assigned Azure account from the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568321 = newJObject()
  var body_568322 = newJObject()
  if azureAccountInfoObject != nil:
    body_568322 = azureAccountInfoObject
  add(path_568321, "appId", newJString(appId))
  result = call_568320.call(path_568321, nil, nil, nil, body_568322)

var azureAccountsRemoveFromApp* = Call_AzureAccountsRemoveFromApp_568313(
    name: "azureAccountsRemoveFromApp", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsRemoveFromApp_568314, base: "",
    url: url_AzureAccountsRemoveFromApp_568315, schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_568323 = ref object of OpenApiRestCall_567668
proc url_AppsListEndpoints_568325(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/endpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsListEndpoints_568324(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568326 = path.getOrDefault("appId")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "appId", valid_568326
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_AppsListEndpoints_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_AppsListEndpoints_568323; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568329 = newJObject()
  add(path_568329, "appId", newJString(appId))
  result = call_568328.call(path_568329, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_568323(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_568324, base: "",
    url: url_AppsListEndpoints_568325, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_568337 = ref object of OpenApiRestCall_567668
proc url_PermissionsUpdate_568339(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsUpdate_568338(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568340 = path.getOrDefault("appId")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "appId", valid_568340
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user email addresses.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_PermissionsUpdate_568337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_PermissionsUpdate_568337; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568344 = newJObject()
  var body_568345 = newJObject()
  if collaborators != nil:
    body_568345 = collaborators
  add(path_568344, "appId", newJString(appId))
  result = call_568343.call(path_568344, nil, nil, nil, body_568345)

var permissionsUpdate* = Call_PermissionsUpdate_568337(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_568338,
    base: "", url: url_PermissionsUpdate_568339, schemes: {Scheme.Https})
type
  Call_PermissionsAdd_568346 = ref object of OpenApiRestCall_567668
proc url_PermissionsAdd_568348(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsAdd_568347(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568349 = path.getOrDefault("appId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "appId", valid_568349
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_PermissionsAdd_568346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_PermissionsAdd_568346; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568353 = newJObject()
  var body_568354 = newJObject()
  if userToAdd != nil:
    body_568354 = userToAdd
  add(path_568353, "appId", newJString(appId))
  result = call_568352.call(path_568353, nil, nil, nil, body_568354)

var permissionsAdd* = Call_PermissionsAdd_568346(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_568347,
    base: "", url: url_PermissionsAdd_568348, schemes: {Scheme.Https})
type
  Call_PermissionsList_568330 = ref object of OpenApiRestCall_567668
proc url_PermissionsList_568332(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsList_568331(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568333 = path.getOrDefault("appId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "appId", valid_568333
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_PermissionsList_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_PermissionsList_568330; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568336 = newJObject()
  add(path_568336, "appId", newJString(appId))
  result = call_568335.call(path_568336, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_568330(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_568331,
    base: "", url: url_PermissionsList_568332, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_568355 = ref object of OpenApiRestCall_567668
proc url_PermissionsDelete_568357(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsDelete_568356(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568358 = path.getOrDefault("appId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "appId", valid_568358
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_PermissionsDelete_568355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_PermissionsDelete_568355; appId: string;
          userToDelete: JsonNode): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   appId: string (required)
  ##        : The application ID.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  var path_568362 = newJObject()
  var body_568363 = newJObject()
  add(path_568362, "appId", newJString(appId))
  if userToDelete != nil:
    body_568363 = userToDelete
  result = call_568361.call(path_568362, nil, nil, nil, body_568363)

var permissionsDelete* = Call_PermissionsDelete_568355(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_568356,
    base: "", url: url_PermissionsDelete_568357, schemes: {Scheme.Https})
type
  Call_AppsPublish_568364 = ref object of OpenApiRestCall_567668
proc url_AppsPublish_568366(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPublish_568365(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Publishes a specific version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568367 = path.getOrDefault("appId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "appId", valid_568367
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_AppsPublish_568364; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_AppsPublish_568364;
          applicationPublishObject: JsonNode; appId: string): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568371 = newJObject()
  var body_568372 = newJObject()
  if applicationPublishObject != nil:
    body_568372 = applicationPublishObject
  add(path_568371, "appId", newJString(appId))
  result = call_568370.call(path_568371, nil, nil, nil, body_568372)

var appsPublish* = Call_AppsPublish_568364(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_568365,
                                        base: "", url: url_AppsPublish_568366,
                                        schemes: {Scheme.Https})
type
  Call_AppsUpdatePublishSettings_568380 = ref object of OpenApiRestCall_567668
proc url_AppsUpdatePublishSettings_568382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publishsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdatePublishSettings_568381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568383 = path.getOrDefault("appId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "appId", valid_568383
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   publishSettingUpdateObject: JObject (required)
  ##                             : An object containing the new publish application settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_AppsUpdatePublishSettings_568380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_AppsUpdatePublishSettings_568380;
          publishSettingUpdateObject: JsonNode; appId: string): Recallable =
  ## appsUpdatePublishSettings
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ##   publishSettingUpdateObject: JObject (required)
  ##                             : An object containing the new publish application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568387 = newJObject()
  var body_568388 = newJObject()
  if publishSettingUpdateObject != nil:
    body_568388 = publishSettingUpdateObject
  add(path_568387, "appId", newJString(appId))
  result = call_568386.call(path_568387, nil, nil, nil, body_568388)

var appsUpdatePublishSettings* = Call_AppsUpdatePublishSettings_568380(
    name: "appsUpdatePublishSettings", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/publishsettings",
    validator: validate_AppsUpdatePublishSettings_568381, base: "",
    url: url_AppsUpdatePublishSettings_568382, schemes: {Scheme.Https})
type
  Call_AppsGetPublishSettings_568373 = ref object of OpenApiRestCall_567668
proc url_AppsGetPublishSettings_568375(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/publishsettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGetPublishSettings_568374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the application publish settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568376 = path.getOrDefault("appId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "appId", valid_568376
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_AppsGetPublishSettings_568373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_AppsGetPublishSettings_568373; appId: string): Recallable =
  ## appsGetPublishSettings
  ## Get the application publish settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568379 = newJObject()
  add(path_568379, "appId", newJString(appId))
  result = call_568378.call(path_568379, nil, nil, nil, nil)

var appsGetPublishSettings* = Call_AppsGetPublishSettings_568373(
    name: "appsGetPublishSettings", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/publishsettings",
    validator: validate_AppsGetPublishSettings_568374, base: "",
    url: url_AppsGetPublishSettings_568375, schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_568389 = ref object of OpenApiRestCall_567668
proc url_AppsDownloadQueryLogs_568391(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/querylogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsDownloadQueryLogs_568390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the logs of the past month's endpoint queries for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568392 = path.getOrDefault("appId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "appId", valid_568392
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_AppsDownloadQueryLogs_568389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs of the past month's endpoint queries for the application.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_AppsDownloadQueryLogs_568389; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the logs of the past month's endpoint queries for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568395 = newJObject()
  add(path_568395, "appId", newJString(appId))
  result = call_568394.call(path_568395, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_568389(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_568390,
    base: "", url: url_AppsDownloadQueryLogs_568391, schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_568403 = ref object of OpenApiRestCall_567668
proc url_AppsUpdateSettings_568405(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsUpdateSettings_568404(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the application settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568406 = path.getOrDefault("appId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "appId", valid_568406
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568408: Call_AppsUpdateSettings_568403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_568408.validator(path, query, header, formData, body)
  let scheme = call_568408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568408.url(scheme.get, call_568408.host, call_568408.base,
                         call_568408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568408, url, valid)

proc call*(call_568409: Call_AppsUpdateSettings_568403; appId: string;
          applicationSettingUpdateObject: JsonNode): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  var path_568410 = newJObject()
  var body_568411 = newJObject()
  add(path_568410, "appId", newJString(appId))
  if applicationSettingUpdateObject != nil:
    body_568411 = applicationSettingUpdateObject
  result = call_568409.call(path_568410, nil, nil, nil, body_568411)

var appsUpdateSettings* = Call_AppsUpdateSettings_568403(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_568404,
    base: "", url: url_AppsUpdateSettings_568405, schemes: {Scheme.Https})
type
  Call_AppsGetSettings_568396 = ref object of OpenApiRestCall_567668
proc url_AppsGetSettings_568398(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsGetSettings_568397(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the application settings including 'UseAllTrainingData'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568399 = path.getOrDefault("appId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "appId", valid_568399
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_AppsGetSettings_568396; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_AppsGetSettings_568396; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568402 = newJObject()
  add(path_568402, "appId", newJString(appId))
  result = call_568401.call(path_568402, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_568396(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_568397, base: "", url: url_AppsGetSettings_568398,
    schemes: {Scheme.Https})
type
  Call_VersionsList_568412 = ref object of OpenApiRestCall_567668
proc url_VersionsList_568414(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsList_568413(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of versions for this application ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568415 = path.getOrDefault("appId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "appId", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568416 = query.getOrDefault("skip")
  valid_568416 = validateParameter(valid_568416, JInt, required = false,
                                 default = newJInt(0))
  if valid_568416 != nil:
    section.add "skip", valid_568416
  var valid_568417 = query.getOrDefault("take")
  valid_568417 = validateParameter(valid_568417, JInt, required = false,
                                 default = newJInt(100))
  if valid_568417 != nil:
    section.add "take", valid_568417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568418: Call_VersionsList_568412; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of versions for this application ID.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_VersionsList_568412; appId: string; skip: int = 0;
          take: int = 100): Recallable =
  ## versionsList
  ## Gets a list of versions for this application ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568420 = newJObject()
  var query_568421 = newJObject()
  add(query_568421, "skip", newJInt(skip))
  add(query_568421, "take", newJInt(take))
  add(path_568420, "appId", newJString(appId))
  result = call_568419.call(path_568420, query_568421, nil, nil, nil)

var versionsList* = Call_VersionsList_568412(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_568413, base: "", url: url_VersionsList_568414,
    schemes: {Scheme.Https})
type
  Call_VersionsImport_568422 = ref object of OpenApiRestCall_567668
proc url_VersionsImport_568424(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsImport_568423(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Imports a new version into a LUIS application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_568425 = path.getOrDefault("appId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "appId", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_568426 = query.getOrDefault("versionId")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "versionId", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_VersionsImport_568422; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_VersionsImport_568422; appId: string; luisApp: JsonNode;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(query_568431, "versionId", newJString(versionId))
  add(path_568430, "appId", newJString(appId))
  if luisApp != nil:
    body_568432 = luisApp
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var versionsImport* = Call_VersionsImport_568422(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_568423,
    base: "", url: url_VersionsImport_568424, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_568441 = ref object of OpenApiRestCall_567668
proc url_VersionsUpdate_568443(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsUpdate_568442(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the name or description of the application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568444 = path.getOrDefault("versionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "versionId", valid_568444
  var valid_568445 = path.getOrDefault("appId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "appId", valid_568445
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_VersionsUpdate_568441; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_VersionsUpdate_568441; versionId: string; appId: string;
          versionUpdateObject: JsonNode): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  var path_568449 = newJObject()
  var body_568450 = newJObject()
  add(path_568449, "versionId", newJString(versionId))
  add(path_568449, "appId", newJString(appId))
  if versionUpdateObject != nil:
    body_568450 = versionUpdateObject
  result = call_568448.call(path_568449, nil, nil, nil, body_568450)

var versionsUpdate* = Call_VersionsUpdate_568441(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_568442, base: "", url: url_VersionsUpdate_568443,
    schemes: {Scheme.Https})
type
  Call_VersionsGet_568433 = ref object of OpenApiRestCall_567668
proc url_VersionsGet_568435(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsGet_568434(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568436 = path.getOrDefault("versionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "versionId", valid_568436
  var valid_568437 = path.getOrDefault("appId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "appId", valid_568437
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_VersionsGet_568433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ## 
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_VersionsGet_568433; versionId: string; appId: string): Recallable =
  ## versionsGet
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568440 = newJObject()
  add(path_568440, "versionId", newJString(versionId))
  add(path_568440, "appId", newJString(appId))
  result = call_568439.call(path_568440, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_568433(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_568434,
                                        base: "", url: url_VersionsGet_568435,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_568451 = ref object of OpenApiRestCall_567668
proc url_VersionsDelete_568453(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsDelete_568452(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568454 = path.getOrDefault("versionId")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "versionId", valid_568454
  var valid_568455 = path.getOrDefault("appId")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "appId", valid_568455
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_VersionsDelete_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_VersionsDelete_568451; versionId: string; appId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568458 = newJObject()
  add(path_568458, "versionId", newJString(versionId))
  add(path_568458, "appId", newJString(appId))
  result = call_568457.call(path_568458, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_568451(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_568452, base: "", url: url_VersionsDelete_568453,
    schemes: {Scheme.Https})
type
  Call_VersionsClone_568459 = ref object of OpenApiRestCall_567668
proc url_VersionsClone_568461(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsClone_568460(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version from the selected version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568462 = path.getOrDefault("versionId")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "versionId", valid_568462
  var valid_568463 = path.getOrDefault("appId")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "appId", valid_568463
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   versionCloneObject: JObject (required)
  ##                     : A model containing the new version ID.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568465: Call_VersionsClone_568459; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version from the selected version.
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_VersionsClone_568459; versionId: string; appId: string;
          versionCloneObject: JsonNode): Recallable =
  ## versionsClone
  ## Creates a new version from the selected version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject (required)
  ##                     : A model containing the new version ID.
  var path_568467 = newJObject()
  var body_568468 = newJObject()
  add(path_568467, "versionId", newJString(versionId))
  add(path_568467, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_568468 = versionCloneObject
  result = call_568466.call(path_568467, nil, nil, nil, body_568468)

var versionsClone* = Call_VersionsClone_568459(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_568460, base: "", url: url_VersionsClone_568461,
    schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_568480 = ref object of OpenApiRestCall_567668
proc url_ModelAddClosedList_568482(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddClosedList_568481(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Adds a list entity model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568483 = path.getOrDefault("versionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "versionId", valid_568483
  var valid_568484 = path.getOrDefault("appId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "appId", valid_568484
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new list entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568486: Call_ModelAddClosedList_568480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list entity model to a version of the application.
  ## 
  let valid = call_568486.validator(path, query, header, formData, body)
  let scheme = call_568486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568486.url(scheme.get, call_568486.host, call_568486.base,
                         call_568486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568486, url, valid)

proc call*(call_568487: Call_ModelAddClosedList_568480; versionId: string;
          appId: string; closedListModelCreateObject: JsonNode): Recallable =
  ## modelAddClosedList
  ## Adds a list entity model to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new list entity extractor.
  var path_568488 = newJObject()
  var body_568489 = newJObject()
  add(path_568488, "versionId", newJString(versionId))
  add(path_568488, "appId", newJString(appId))
  if closedListModelCreateObject != nil:
    body_568489 = closedListModelCreateObject
  result = call_568487.call(path_568488, nil, nil, nil, body_568489)

var modelAddClosedList* = Call_ModelAddClosedList_568480(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_568481, base: "",
    url: url_ModelAddClosedList_568482, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_568469 = ref object of OpenApiRestCall_567668
proc url_ModelListClosedLists_568471(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListClosedLists_568470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the list entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568472 = path.getOrDefault("versionId")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "versionId", valid_568472
  var valid_568473 = path.getOrDefault("appId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "appId", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568474 = query.getOrDefault("skip")
  valid_568474 = validateParameter(valid_568474, JInt, required = false,
                                 default = newJInt(0))
  if valid_568474 != nil:
    section.add "skip", valid_568474
  var valid_568475 = query.getOrDefault("take")
  valid_568475 = validateParameter(valid_568475, JInt, required = false,
                                 default = newJInt(100))
  if valid_568475 != nil:
    section.add "take", valid_568475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568476: Call_ModelListClosedLists_568469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the list entity models in a version of the application.
  ## 
  let valid = call_568476.validator(path, query, header, formData, body)
  let scheme = call_568476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568476.url(scheme.get, call_568476.host, call_568476.base,
                         call_568476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568476, url, valid)

proc call*(call_568477: Call_ModelListClosedLists_568469; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListClosedLists
  ## Gets information about all the list entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568478 = newJObject()
  var query_568479 = newJObject()
  add(path_568478, "versionId", newJString(versionId))
  add(query_568479, "skip", newJInt(skip))
  add(query_568479, "take", newJInt(take))
  add(path_568478, "appId", newJString(appId))
  result = call_568477.call(path_568478, query_568479, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_568469(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_568470, base: "",
    url: url_ModelListClosedLists_568471, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_568499 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateClosedList_568501(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateClosedList_568500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568502 = path.getOrDefault("versionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "versionId", valid_568502
  var valid_568503 = path.getOrDefault("appId")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "appId", valid_568503
  var valid_568504 = path.getOrDefault("clEntityId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "clEntityId", valid_568504
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new list entity name and words list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_ModelUpdateClosedList_568499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the list entity in a version of the application.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_ModelUpdateClosedList_568499; versionId: string;
          closedListModelUpdateObject: JsonNode; appId: string; clEntityId: string): Recallable =
  ## modelUpdateClosedList
  ## Updates the list entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   closedListModelUpdateObject: JObject (required)
  ##                              : The new list entity name and words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list model ID.
  var path_568508 = newJObject()
  var body_568509 = newJObject()
  add(path_568508, "versionId", newJString(versionId))
  if closedListModelUpdateObject != nil:
    body_568509 = closedListModelUpdateObject
  add(path_568508, "appId", newJString(appId))
  add(path_568508, "clEntityId", newJString(clEntityId))
  result = call_568507.call(path_568508, nil, nil, nil, body_568509)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_568499(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_568500, base: "",
    url: url_ModelUpdateClosedList_568501, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_568490 = ref object of OpenApiRestCall_567668
proc url_ModelGetClosedList_568492(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetClosedList_568491(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about a list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568493 = path.getOrDefault("versionId")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "versionId", valid_568493
  var valid_568494 = path.getOrDefault("appId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "appId", valid_568494
  var valid_568495 = path.getOrDefault("clEntityId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "clEntityId", valid_568495
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_ModelGetClosedList_568490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a list entity in a version of the application.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_ModelGetClosedList_568490; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelGetClosedList
  ## Gets information about a list entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list model ID.
  var path_568498 = newJObject()
  add(path_568498, "versionId", newJString(versionId))
  add(path_568498, "appId", newJString(appId))
  add(path_568498, "clEntityId", newJString(clEntityId))
  result = call_568497.call(path_568498, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_568490(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_568491, base: "",
    url: url_ModelGetClosedList_568492, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_568519 = ref object of OpenApiRestCall_567668
proc url_ModelPatchClosedList_568521(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelPatchClosedList_568520(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list entity model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568522 = path.getOrDefault("versionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "versionId", valid_568522
  var valid_568523 = path.getOrDefault("appId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "appId", valid_568523
  var valid_568524 = path.getOrDefault("clEntityId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "clEntityId", valid_568524
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_ModelPatchClosedList_568519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_ModelPatchClosedList_568519; versionId: string;
          appId: string; clEntityId: string; closedListModelPatchObject: JsonNode): Recallable =
  ## modelPatchClosedList
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity model ID.
  ##   closedListModelPatchObject: JObject (required)
  ##                             : A words list batch.
  var path_568528 = newJObject()
  var body_568529 = newJObject()
  add(path_568528, "versionId", newJString(versionId))
  add(path_568528, "appId", newJString(appId))
  add(path_568528, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_568529 = closedListModelPatchObject
  result = call_568527.call(path_568528, nil, nil, nil, body_568529)

var modelPatchClosedList* = Call_ModelPatchClosedList_568519(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_568520, base: "",
    url: url_ModelPatchClosedList_568521, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_568510 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteClosedList_568512(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteClosedList_568511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a list entity model from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list entity model ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568513 = path.getOrDefault("versionId")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "versionId", valid_568513
  var valid_568514 = path.getOrDefault("appId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "appId", valid_568514
  var valid_568515 = path.getOrDefault("clEntityId")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "clEntityId", valid_568515
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568516: Call_ModelDeleteClosedList_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list entity model from a version of the application.
  ## 
  let valid = call_568516.validator(path, query, header, formData, body)
  let scheme = call_568516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568516.url(scheme.get, call_568516.host, call_568516.base,
                         call_568516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568516, url, valid)

proc call*(call_568517: Call_ModelDeleteClosedList_568510; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a list entity model from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity model ID.
  var path_568518 = newJObject()
  add(path_568518, "versionId", newJString(versionId))
  add(path_568518, "appId", newJString(appId))
  add(path_568518, "clEntityId", newJString(clEntityId))
  result = call_568517.call(path_568518, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_568510(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_568511, base: "",
    url: url_ModelDeleteClosedList_568512, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_568530 = ref object of OpenApiRestCall_567668
proc url_ModelAddSubList_568532(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddSubList_568531(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a sublist to an existing list entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568533 = path.getOrDefault("versionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "versionId", valid_568533
  var valid_568534 = path.getOrDefault("appId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "appId", valid_568534
  var valid_568535 = path.getOrDefault("clEntityId")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "clEntityId", valid_568535
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_ModelAddSubList_568530; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a sublist to an existing list entity in a version of the application.
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_ModelAddSubList_568530; versionId: string;
          wordListCreateObject: JsonNode; appId: string; clEntityId: string): Recallable =
  ## modelAddSubList
  ## Adds a sublist to an existing list entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListCreateObject: JObject (required)
  ##                       : Words list.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  var path_568539 = newJObject()
  var body_568540 = newJObject()
  add(path_568539, "versionId", newJString(versionId))
  if wordListCreateObject != nil:
    body_568540 = wordListCreateObject
  add(path_568539, "appId", newJString(appId))
  add(path_568539, "clEntityId", newJString(clEntityId))
  result = call_568538.call(path_568539, nil, nil, nil, body_568540)

var modelAddSubList* = Call_ModelAddSubList_568530(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_568531, base: "", url: url_ModelAddSubList_568532,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_568541 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateSubList_568543(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  assert "subListId" in path, "`subListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists/"),
               (kind: VariableSegment, value: "subListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateSubList_568542(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates one of the list entity's sublists in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568544 = path.getOrDefault("versionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "versionId", valid_568544
  var valid_568545 = path.getOrDefault("appId")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "appId", valid_568545
  var valid_568546 = path.getOrDefault("clEntityId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "clEntityId", valid_568546
  var valid_568547 = path.getOrDefault("subListId")
  valid_568547 = validateParameter(valid_568547, JInt, required = true, default = nil)
  if valid_568547 != nil:
    section.add "subListId", valid_568547
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568549: Call_ModelUpdateSubList_568541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the list entity's sublists in a version of the application.
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_ModelUpdateSubList_568541; versionId: string;
          wordListBaseUpdateObject: JsonNode; appId: string; clEntityId: string;
          subListId: int): Recallable =
  ## modelUpdateSubList
  ## Updates one of the list entity's sublists in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   wordListBaseUpdateObject: JObject (required)
  ##                           : A sublist update object containing the new canonical form and the list of words.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  var path_568551 = newJObject()
  var body_568552 = newJObject()
  add(path_568551, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_568552 = wordListBaseUpdateObject
  add(path_568551, "appId", newJString(appId))
  add(path_568551, "clEntityId", newJString(clEntityId))
  add(path_568551, "subListId", newJInt(subListId))
  result = call_568550.call(path_568551, nil, nil, nil, body_568552)

var modelUpdateSubList* = Call_ModelUpdateSubList_568541(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_568542, base: "",
    url: url_ModelUpdateSubList_568543, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_568553 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteSubList_568555(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "clEntityId" in path, "`clEntityId` is a required path parameter"
  assert "subListId" in path, "`subListId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "clEntityId"),
               (kind: ConstantSegment, value: "/sublists/"),
               (kind: VariableSegment, value: "subListId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteSubList_568554(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   clEntityId: JString (required)
  ##             : The list entity extractor ID.
  ##   subListId: JInt (required)
  ##            : The sublist ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568556 = path.getOrDefault("versionId")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "versionId", valid_568556
  var valid_568557 = path.getOrDefault("appId")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "appId", valid_568557
  var valid_568558 = path.getOrDefault("clEntityId")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "clEntityId", valid_568558
  var valid_568559 = path.getOrDefault("subListId")
  valid_568559 = validateParameter(valid_568559, JInt, required = true, default = nil)
  if valid_568559 != nil:
    section.add "subListId", valid_568559
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568560: Call_ModelDeleteSubList_568553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ## 
  let valid = call_568560.validator(path, query, header, formData, body)
  let scheme = call_568560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568560.url(scheme.get, call_568560.host, call_568560.base,
                         call_568560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568560, url, valid)

proc call*(call_568561: Call_ModelDeleteSubList_568553; versionId: string;
          appId: string; clEntityId: string; subListId: int): Recallable =
  ## modelDeleteSubList
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity extractor ID.
  ##   subListId: int (required)
  ##            : The sublist ID.
  var path_568562 = newJObject()
  add(path_568562, "versionId", newJString(versionId))
  add(path_568562, "appId", newJString(appId))
  add(path_568562, "clEntityId", newJString(clEntityId))
  add(path_568562, "subListId", newJInt(subListId))
  result = call_568561.call(path_568562, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_568553(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_568554, base: "",
    url: url_ModelDeleteSubList_568555, schemes: {Scheme.Https})
type
  Call_ModelCreateClosedListEntityRole_568572 = ref object of OpenApiRestCall_567668
proc url_ModelCreateClosedListEntityRole_568574(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateClosedListEntityRole_568573(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568575 = path.getOrDefault("versionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "versionId", valid_568575
  var valid_568576 = path.getOrDefault("entityId")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "entityId", valid_568576
  var valid_568577 = path.getOrDefault("appId")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "appId", valid_568577
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568579: Call_ModelCreateClosedListEntityRole_568572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568579.validator(path, query, header, formData, body)
  let scheme = call_568579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568579.url(scheme.get, call_568579.host, call_568579.base,
                         call_568579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568579, url, valid)

proc call*(call_568580: Call_ModelCreateClosedListEntityRole_568572;
          versionId: string; entityId: string; entityRoleCreateObject: JsonNode;
          appId: string): Recallable =
  ## modelCreateClosedListEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568581 = newJObject()
  var body_568582 = newJObject()
  add(path_568581, "versionId", newJString(versionId))
  add(path_568581, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_568582 = entityRoleCreateObject
  add(path_568581, "appId", newJString(appId))
  result = call_568580.call(path_568581, nil, nil, nil, body_568582)

var modelCreateClosedListEntityRole* = Call_ModelCreateClosedListEntityRole_568572(
    name: "modelCreateClosedListEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelCreateClosedListEntityRole_568573, base: "",
    url: url_ModelCreateClosedListEntityRole_568574, schemes: {Scheme.Https})
type
  Call_ModelListClosedListEntityRoles_568563 = ref object of OpenApiRestCall_567668
proc url_ModelListClosedListEntityRoles_568565(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListClosedListEntityRoles_568564(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568566 = path.getOrDefault("versionId")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "versionId", valid_568566
  var valid_568567 = path.getOrDefault("entityId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "entityId", valid_568567
  var valid_568568 = path.getOrDefault("appId")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "appId", valid_568568
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568569: Call_ModelListClosedListEntityRoles_568563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_ModelListClosedListEntityRoles_568563;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListClosedListEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_568571 = newJObject()
  add(path_568571, "versionId", newJString(versionId))
  add(path_568571, "entityId", newJString(entityId))
  add(path_568571, "appId", newJString(appId))
  result = call_568570.call(path_568571, nil, nil, nil, nil)

var modelListClosedListEntityRoles* = Call_ModelListClosedListEntityRoles_568563(
    name: "modelListClosedListEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelListClosedListEntityRoles_568564, base: "",
    url: url_ModelListClosedListEntityRoles_568565, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedListEntityRole_568593 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateClosedListEntityRole_568595(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateClosedListEntityRole_568594(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568596 = path.getOrDefault("versionId")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "versionId", valid_568596
  var valid_568597 = path.getOrDefault("entityId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "entityId", valid_568597
  var valid_568598 = path.getOrDefault("appId")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "appId", valid_568598
  var valid_568599 = path.getOrDefault("roleId")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "roleId", valid_568599
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568601: Call_ModelUpdateClosedListEntityRole_568593;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_ModelUpdateClosedListEntityRole_568593;
          versionId: string; entityRoleUpdateObject: JsonNode; entityId: string;
          appId: string; roleId: string): Recallable =
  ## modelUpdateClosedListEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_568603 = newJObject()
  var body_568604 = newJObject()
  add(path_568603, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_568604 = entityRoleUpdateObject
  add(path_568603, "entityId", newJString(entityId))
  add(path_568603, "appId", newJString(appId))
  add(path_568603, "roleId", newJString(roleId))
  result = call_568602.call(path_568603, nil, nil, nil, body_568604)

var modelUpdateClosedListEntityRole* = Call_ModelUpdateClosedListEntityRole_568593(
    name: "modelUpdateClosedListEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateClosedListEntityRole_568594, base: "",
    url: url_ModelUpdateClosedListEntityRole_568595, schemes: {Scheme.Https})
type
  Call_ModelGetClosedListEntityRole_568583 = ref object of OpenApiRestCall_567668
proc url_ModelGetClosedListEntityRole_568585(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetClosedListEntityRole_568584(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568586 = path.getOrDefault("versionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "versionId", valid_568586
  var valid_568587 = path.getOrDefault("entityId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "entityId", valid_568587
  var valid_568588 = path.getOrDefault("appId")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "appId", valid_568588
  var valid_568589 = path.getOrDefault("roleId")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "roleId", valid_568589
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_ModelGetClosedListEntityRole_568583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_ModelGetClosedListEntityRole_568583;
          versionId: string; entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetClosedListEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_568592 = newJObject()
  add(path_568592, "versionId", newJString(versionId))
  add(path_568592, "entityId", newJString(entityId))
  add(path_568592, "appId", newJString(appId))
  add(path_568592, "roleId", newJString(roleId))
  result = call_568591.call(path_568592, nil, nil, nil, nil)

var modelGetClosedListEntityRole* = Call_ModelGetClosedListEntityRole_568583(
    name: "modelGetClosedListEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelGetClosedListEntityRole_568584, base: "",
    url: url_ModelGetClosedListEntityRole_568585, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedListEntityRole_568605 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteClosedListEntityRole_568607(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/closedlists/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteClosedListEntityRole_568606(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568608 = path.getOrDefault("versionId")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "versionId", valid_568608
  var valid_568609 = path.getOrDefault("entityId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "entityId", valid_568609
  var valid_568610 = path.getOrDefault("appId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "appId", valid_568610
  var valid_568611 = path.getOrDefault("roleId")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "roleId", valid_568611
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568612: Call_ModelDeleteClosedListEntityRole_568605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_ModelDeleteClosedListEntityRole_568605;
          versionId: string; entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeleteClosedListEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_568614 = newJObject()
  add(path_568614, "versionId", newJString(versionId))
  add(path_568614, "entityId", newJString(entityId))
  add(path_568614, "appId", newJString(appId))
  add(path_568614, "roleId", newJString(roleId))
  result = call_568613.call(path_568614, nil, nil, nil, nil)

var modelDeleteClosedListEntityRole* = Call_ModelDeleteClosedListEntityRole_568605(
    name: "modelDeleteClosedListEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteClosedListEntityRole_568606, base: "",
    url: url_ModelDeleteClosedListEntityRole_568607, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_568626 = ref object of OpenApiRestCall_567668
proc url_ModelAddCompositeEntity_568628(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCompositeEntity_568627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a composite entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568629 = path.getOrDefault("versionId")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "versionId", valid_568629
  var valid_568630 = path.getOrDefault("appId")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "appId", valid_568630
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568632: Call_ModelAddCompositeEntity_568626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to a version of the application.
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_ModelAddCompositeEntity_568626; versionId: string;
          appId: string; compositeModelCreateObject: JsonNode): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  var path_568634 = newJObject()
  var body_568635 = newJObject()
  add(path_568634, "versionId", newJString(versionId))
  add(path_568634, "appId", newJString(appId))
  if compositeModelCreateObject != nil:
    body_568635 = compositeModelCreateObject
  result = call_568633.call(path_568634, nil, nil, nil, body_568635)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_568626(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_568627, base: "",
    url: url_ModelAddCompositeEntity_568628, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_568615 = ref object of OpenApiRestCall_567668
proc url_ModelListCompositeEntities_568617(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCompositeEntities_568616(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the composite entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568618 = path.getOrDefault("versionId")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "versionId", valid_568618
  var valid_568619 = path.getOrDefault("appId")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "appId", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568620 = query.getOrDefault("skip")
  valid_568620 = validateParameter(valid_568620, JInt, required = false,
                                 default = newJInt(0))
  if valid_568620 != nil:
    section.add "skip", valid_568620
  var valid_568621 = query.getOrDefault("take")
  valid_568621 = validateParameter(valid_568621, JInt, required = false,
                                 default = newJInt(100))
  if valid_568621 != nil:
    section.add "take", valid_568621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568622: Call_ModelListCompositeEntities_568615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the composite entity models in a version of the application.
  ## 
  let valid = call_568622.validator(path, query, header, formData, body)
  let scheme = call_568622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568622.url(scheme.get, call_568622.host, call_568622.base,
                         call_568622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568622, url, valid)

proc call*(call_568623: Call_ModelListCompositeEntities_568615; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListCompositeEntities
  ## Gets information about all the composite entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568624 = newJObject()
  var query_568625 = newJObject()
  add(path_568624, "versionId", newJString(versionId))
  add(query_568625, "skip", newJInt(skip))
  add(query_568625, "take", newJInt(take))
  add(path_568624, "appId", newJString(appId))
  result = call_568623.call(path_568624, query_568625, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_568615(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_568616, base: "",
    url: url_ModelListCompositeEntities_568617, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_568645 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateCompositeEntity_568647(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCompositeEntity_568646(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568648 = path.getOrDefault("versionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "versionId", valid_568648
  var valid_568649 = path.getOrDefault("appId")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "appId", valid_568649
  var valid_568650 = path.getOrDefault("cEntityId")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "cEntityId", valid_568650
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568652: Call_ModelUpdateCompositeEntity_568645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a composite entity in a version of the application.
  ## 
  let valid = call_568652.validator(path, query, header, formData, body)
  let scheme = call_568652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568652.url(scheme.get, call_568652.host, call_568652.base,
                         call_568652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568652, url, valid)

proc call*(call_568653: Call_ModelUpdateCompositeEntity_568645; versionId: string;
          compositeModelUpdateObject: JsonNode; appId: string; cEntityId: string): Recallable =
  ## modelUpdateCompositeEntity
  ## Updates a composite entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   compositeModelUpdateObject: JObject (required)
  ##                             : A model object containing the new entity extractor name and children.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568654 = newJObject()
  var body_568655 = newJObject()
  add(path_568654, "versionId", newJString(versionId))
  if compositeModelUpdateObject != nil:
    body_568655 = compositeModelUpdateObject
  add(path_568654, "appId", newJString(appId))
  add(path_568654, "cEntityId", newJString(cEntityId))
  result = call_568653.call(path_568654, nil, nil, nil, body_568655)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_568645(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_568646, base: "",
    url: url_ModelUpdateCompositeEntity_568647, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_568636 = ref object of OpenApiRestCall_567668
proc url_ModelGetCompositeEntity_568638(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCompositeEntity_568637(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a composite entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568639 = path.getOrDefault("versionId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "versionId", valid_568639
  var valid_568640 = path.getOrDefault("appId")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "appId", valid_568640
  var valid_568641 = path.getOrDefault("cEntityId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "cEntityId", valid_568641
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568642: Call_ModelGetCompositeEntity_568636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a composite entity in a version of the application.
  ## 
  let valid = call_568642.validator(path, query, header, formData, body)
  let scheme = call_568642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568642.url(scheme.get, call_568642.host, call_568642.base,
                         call_568642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568642, url, valid)

proc call*(call_568643: Call_ModelGetCompositeEntity_568636; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about a composite entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568644 = newJObject()
  add(path_568644, "versionId", newJString(versionId))
  add(path_568644, "appId", newJString(appId))
  add(path_568644, "cEntityId", newJString(cEntityId))
  result = call_568643.call(path_568644, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_568636(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_568637, base: "",
    url: url_ModelGetCompositeEntity_568638, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_568656 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteCompositeEntity_568658(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntity_568657(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568659 = path.getOrDefault("versionId")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "versionId", valid_568659
  var valid_568660 = path.getOrDefault("appId")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "appId", valid_568660
  var valid_568661 = path.getOrDefault("cEntityId")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "cEntityId", valid_568661
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568662: Call_ModelDeleteCompositeEntity_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity from a version of the application.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_ModelDeleteCompositeEntity_568656; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568664 = newJObject()
  add(path_568664, "versionId", newJString(versionId))
  add(path_568664, "appId", newJString(appId))
  add(path_568664, "cEntityId", newJString(cEntityId))
  result = call_568663.call(path_568664, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_568656(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_568657, base: "",
    url: url_ModelDeleteCompositeEntity_568658, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_568665 = ref object of OpenApiRestCall_567668
proc url_ModelAddCompositeEntityChild_568667(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCompositeEntityChild_568666(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing composite entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568668 = path.getOrDefault("versionId")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "versionId", valid_568668
  var valid_568669 = path.getOrDefault("appId")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "appId", valid_568669
  var valid_568670 = path.getOrDefault("cEntityId")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "cEntityId", valid_568670
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568672: Call_ModelAddCompositeEntityChild_568665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model in a version of the application.
  ## 
  let valid = call_568672.validator(path, query, header, formData, body)
  let scheme = call_568672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568672.url(scheme.get, call_568672.host, call_568672.base,
                         call_568672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568672, url, valid)

proc call*(call_568673: Call_ModelAddCompositeEntityChild_568665;
          versionId: string; compositeChildModelCreateObject: JsonNode;
          appId: string; cEntityId: string): Recallable =
  ## modelAddCompositeEntityChild
  ## Creates a single child in an existing composite entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   compositeChildModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the new composite child model.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568674 = newJObject()
  var body_568675 = newJObject()
  add(path_568674, "versionId", newJString(versionId))
  if compositeChildModelCreateObject != nil:
    body_568675 = compositeChildModelCreateObject
  add(path_568674, "appId", newJString(appId))
  add(path_568674, "cEntityId", newJString(cEntityId))
  result = call_568673.call(path_568674, nil, nil, nil, body_568675)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_568665(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_568666, base: "",
    url: url_ModelAddCompositeEntityChild_568667, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_568676 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteCompositeEntityChild_568678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "cChildId" in path, "`cChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "cChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntityChild_568677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite entity extractor child from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   cChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568679 = path.getOrDefault("versionId")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "versionId", valid_568679
  var valid_568680 = path.getOrDefault("cChildId")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "cChildId", valid_568680
  var valid_568681 = path.getOrDefault("appId")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "appId", valid_568681
  var valid_568682 = path.getOrDefault("cEntityId")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "cEntityId", valid_568682
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568683: Call_ModelDeleteCompositeEntityChild_568676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from a version of the application.
  ## 
  let valid = call_568683.validator(path, query, header, formData, body)
  let scheme = call_568683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568683.url(scheme.get, call_568683.host, call_568683.base,
                         call_568683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568683, url, valid)

proc call*(call_568684: Call_ModelDeleteCompositeEntityChild_568676;
          versionId: string; cChildId: string; appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntityChild
  ## Deletes a composite entity extractor child from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   cChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568685 = newJObject()
  add(path_568685, "versionId", newJString(versionId))
  add(path_568685, "cChildId", newJString(cChildId))
  add(path_568685, "appId", newJString(appId))
  add(path_568685, "cEntityId", newJString(cEntityId))
  result = call_568684.call(path_568685, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_568676(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_568677, base: "",
    url: url_ModelDeleteCompositeEntityChild_568678, schemes: {Scheme.Https})
type
  Call_ModelCreateCompositeEntityRole_568695 = ref object of OpenApiRestCall_567668
proc url_ModelCreateCompositeEntityRole_568697(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateCompositeEntityRole_568696(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568698 = path.getOrDefault("versionId")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "versionId", valid_568698
  var valid_568699 = path.getOrDefault("appId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "appId", valid_568699
  var valid_568700 = path.getOrDefault("cEntityId")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "cEntityId", valid_568700
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568702: Call_ModelCreateCompositeEntityRole_568695; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568702.validator(path, query, header, formData, body)
  let scheme = call_568702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568702.url(scheme.get, call_568702.host, call_568702.base,
                         call_568702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568702, url, valid)

proc call*(call_568703: Call_ModelCreateCompositeEntityRole_568695;
          versionId: string; entityRoleCreateObject: JsonNode; appId: string;
          cEntityId: string): Recallable =
  ## modelCreateCompositeEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568704 = newJObject()
  var body_568705 = newJObject()
  add(path_568704, "versionId", newJString(versionId))
  if entityRoleCreateObject != nil:
    body_568705 = entityRoleCreateObject
  add(path_568704, "appId", newJString(appId))
  add(path_568704, "cEntityId", newJString(cEntityId))
  result = call_568703.call(path_568704, nil, nil, nil, body_568705)

var modelCreateCompositeEntityRole* = Call_ModelCreateCompositeEntityRole_568695(
    name: "modelCreateCompositeEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelCreateCompositeEntityRole_568696, base: "",
    url: url_ModelCreateCompositeEntityRole_568697, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntityRoles_568686 = ref object of OpenApiRestCall_567668
proc url_ModelListCompositeEntityRoles_568688(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCompositeEntityRoles_568687(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568689 = path.getOrDefault("versionId")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "versionId", valid_568689
  var valid_568690 = path.getOrDefault("appId")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "appId", valid_568690
  var valid_568691 = path.getOrDefault("cEntityId")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "cEntityId", valid_568691
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568692: Call_ModelListCompositeEntityRoles_568686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568692.validator(path, query, header, formData, body)
  let scheme = call_568692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568692.url(scheme.get, call_568692.host, call_568692.base,
                         call_568692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568692, url, valid)

proc call*(call_568693: Call_ModelListCompositeEntityRoles_568686;
          versionId: string; appId: string; cEntityId: string): Recallable =
  ## modelListCompositeEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568694 = newJObject()
  add(path_568694, "versionId", newJString(versionId))
  add(path_568694, "appId", newJString(appId))
  add(path_568694, "cEntityId", newJString(cEntityId))
  result = call_568693.call(path_568694, nil, nil, nil, nil)

var modelListCompositeEntityRoles* = Call_ModelListCompositeEntityRoles_568686(
    name: "modelListCompositeEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelListCompositeEntityRoles_568687, base: "",
    url: url_ModelListCompositeEntityRoles_568688, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntityRole_568716 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateCompositeEntityRole_568718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCompositeEntityRole_568717(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568719 = path.getOrDefault("versionId")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "versionId", valid_568719
  var valid_568720 = path.getOrDefault("appId")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "appId", valid_568720
  var valid_568721 = path.getOrDefault("roleId")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "roleId", valid_568721
  var valid_568722 = path.getOrDefault("cEntityId")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "cEntityId", valid_568722
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568724: Call_ModelUpdateCompositeEntityRole_568716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568724.validator(path, query, header, formData, body)
  let scheme = call_568724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568724.url(scheme.get, call_568724.host, call_568724.base,
                         call_568724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568724, url, valid)

proc call*(call_568725: Call_ModelUpdateCompositeEntityRole_568716;
          versionId: string; entityRoleUpdateObject: JsonNode; appId: string;
          roleId: string; cEntityId: string): Recallable =
  ## modelUpdateCompositeEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568726 = newJObject()
  var body_568727 = newJObject()
  add(path_568726, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_568727 = entityRoleUpdateObject
  add(path_568726, "appId", newJString(appId))
  add(path_568726, "roleId", newJString(roleId))
  add(path_568726, "cEntityId", newJString(cEntityId))
  result = call_568725.call(path_568726, nil, nil, nil, body_568727)

var modelUpdateCompositeEntityRole* = Call_ModelUpdateCompositeEntityRole_568716(
    name: "modelUpdateCompositeEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateCompositeEntityRole_568717, base: "",
    url: url_ModelUpdateCompositeEntityRole_568718, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntityRole_568706 = ref object of OpenApiRestCall_567668
proc url_ModelGetCompositeEntityRole_568708(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCompositeEntityRole_568707(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568709 = path.getOrDefault("versionId")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "versionId", valid_568709
  var valid_568710 = path.getOrDefault("appId")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "appId", valid_568710
  var valid_568711 = path.getOrDefault("roleId")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "roleId", valid_568711
  var valid_568712 = path.getOrDefault("cEntityId")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "cEntityId", valid_568712
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568713: Call_ModelGetCompositeEntityRole_568706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568713.validator(path, query, header, formData, body)
  let scheme = call_568713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568713.url(scheme.get, call_568713.host, call_568713.base,
                         call_568713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568713, url, valid)

proc call*(call_568714: Call_ModelGetCompositeEntityRole_568706; versionId: string;
          appId: string; roleId: string; cEntityId: string): Recallable =
  ## modelGetCompositeEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568715 = newJObject()
  add(path_568715, "versionId", newJString(versionId))
  add(path_568715, "appId", newJString(appId))
  add(path_568715, "roleId", newJString(roleId))
  add(path_568715, "cEntityId", newJString(cEntityId))
  result = call_568714.call(path_568715, nil, nil, nil, nil)

var modelGetCompositeEntityRole* = Call_ModelGetCompositeEntityRole_568706(
    name: "modelGetCompositeEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelGetCompositeEntityRole_568707, base: "",
    url: url_ModelGetCompositeEntityRole_568708, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityRole_568728 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteCompositeEntityRole_568730(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "cEntityId" in path, "`cEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/compositeentities/"),
               (kind: VariableSegment, value: "cEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCompositeEntityRole_568729(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  ##   cEntityId: JString (required)
  ##            : The composite entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568731 = path.getOrDefault("versionId")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "versionId", valid_568731
  var valid_568732 = path.getOrDefault("appId")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "appId", valid_568732
  var valid_568733 = path.getOrDefault("roleId")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "roleId", valid_568733
  var valid_568734 = path.getOrDefault("cEntityId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "cEntityId", valid_568734
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568735: Call_ModelDeleteCompositeEntityRole_568728; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568735.validator(path, query, header, formData, body)
  let scheme = call_568735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568735.url(scheme.get, call_568735.host, call_568735.base,
                         call_568735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568735, url, valid)

proc call*(call_568736: Call_ModelDeleteCompositeEntityRole_568728;
          versionId: string; appId: string; roleId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_568737 = newJObject()
  add(path_568737, "versionId", newJString(versionId))
  add(path_568737, "appId", newJString(appId))
  add(path_568737, "roleId", newJString(roleId))
  add(path_568737, "cEntityId", newJString(cEntityId))
  result = call_568736.call(path_568737, nil, nil, nil, nil)

var modelDeleteCompositeEntityRole* = Call_ModelDeleteCompositeEntityRole_568728(
    name: "modelDeleteCompositeEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteCompositeEntityRole_568729, base: "",
    url: url_ModelDeleteCompositeEntityRole_568730, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_568738 = ref object of OpenApiRestCall_567668
proc url_ModelAddCustomPrebuiltDomain_568740(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltdomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltDomain_568739(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568741 = path.getOrDefault("versionId")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "versionId", valid_568741
  var valid_568742 = path.getOrDefault("appId")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "appId", valid_568742
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568744: Call_ModelAddCustomPrebuiltDomain_568738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ## 
  let valid = call_568744.validator(path, query, header, formData, body)
  let scheme = call_568744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568744.url(scheme.get, call_568744.host, call_568744.base,
                         call_568744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568744, url, valid)

proc call*(call_568745: Call_ModelAddCustomPrebuiltDomain_568738;
          versionId: string; appId: string; prebuiltDomainObject: JsonNode): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  var path_568746 = newJObject()
  var body_568747 = newJObject()
  add(path_568746, "versionId", newJString(versionId))
  add(path_568746, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_568747 = prebuiltDomainObject
  result = call_568745.call(path_568746, nil, nil, nil, body_568747)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_568738(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_568739, base: "",
    url: url_ModelAddCustomPrebuiltDomain_568740, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_568748 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteCustomPrebuiltDomain_568750(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltdomains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCustomPrebuiltDomain_568749(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a prebuilt domain's models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   domainName: JString (required)
  ##             : Domain name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568751 = path.getOrDefault("versionId")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "versionId", valid_568751
  var valid_568752 = path.getOrDefault("appId")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "appId", valid_568752
  var valid_568753 = path.getOrDefault("domainName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "domainName", valid_568753
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568754: Call_ModelDeleteCustomPrebuiltDomain_568748;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models in a version of the application.
  ## 
  let valid = call_568754.validator(path, query, header, formData, body)
  let scheme = call_568754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568754.url(scheme.get, call_568754.host, call_568754.base,
                         call_568754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568754, url, valid)

proc call*(call_568755: Call_ModelDeleteCustomPrebuiltDomain_568748;
          versionId: string; appId: string; domainName: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  var path_568756 = newJObject()
  add(path_568756, "versionId", newJString(versionId))
  add(path_568756, "appId", newJString(appId))
  add(path_568756, "domainName", newJString(domainName))
  result = call_568755.call(path_568756, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_568748(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_568749, base: "",
    url: url_ModelDeleteCustomPrebuiltDomain_568750, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_568765 = ref object of OpenApiRestCall_567668
proc url_ModelAddCustomPrebuiltEntity_568767(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltEntity_568766(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a prebuilt entity model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568768 = path.getOrDefault("versionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "versionId", valid_568768
  var valid_568769 = path.getOrDefault("appId")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "appId", valid_568769
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the prebuilt entity and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568771: Call_ModelAddCustomPrebuiltEntity_568765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt entity model to a version of the application.
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_ModelAddCustomPrebuiltEntity_568765;
          prebuiltDomainModelCreateObject: JsonNode; versionId: string;
          appId: string): Recallable =
  ## modelAddCustomPrebuiltEntity
  ## Adds a prebuilt entity model to a version of the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the prebuilt entity and the name of the domain to which this model belongs.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568773 = newJObject()
  var body_568774 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_568774 = prebuiltDomainModelCreateObject
  add(path_568773, "versionId", newJString(versionId))
  add(path_568773, "appId", newJString(appId))
  result = call_568772.call(path_568773, nil, nil, nil, body_568774)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_568765(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_568766, base: "",
    url: url_ModelAddCustomPrebuiltEntity_568767, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_568757 = ref object of OpenApiRestCall_567668
proc url_ModelListCustomPrebuiltEntities_568759(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltEntities_568758(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all prebuilt entities used in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568760 = path.getOrDefault("versionId")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "versionId", valid_568760
  var valid_568761 = path.getOrDefault("appId")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "appId", valid_568761
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568762: Call_ModelListCustomPrebuiltEntities_568757;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all prebuilt entities used in a version of the application.
  ## 
  let valid = call_568762.validator(path, query, header, formData, body)
  let scheme = call_568762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568762.url(scheme.get, call_568762.host, call_568762.base,
                         call_568762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568762, url, valid)

proc call*(call_568763: Call_ModelListCustomPrebuiltEntities_568757;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all prebuilt entities used in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568764 = newJObject()
  add(path_568764, "versionId", newJString(versionId))
  add(path_568764, "appId", newJString(appId))
  result = call_568763.call(path_568764, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_568757(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_568758, base: "",
    url: url_ModelListCustomPrebuiltEntities_568759, schemes: {Scheme.Https})
type
  Call_ModelCreateCustomPrebuiltEntityRole_568784 = ref object of OpenApiRestCall_567668
proc url_ModelCreateCustomPrebuiltEntityRole_568786(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateCustomPrebuiltEntityRole_568785(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568787 = path.getOrDefault("versionId")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "versionId", valid_568787
  var valid_568788 = path.getOrDefault("entityId")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "entityId", valid_568788
  var valid_568789 = path.getOrDefault("appId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "appId", valid_568789
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568791: Call_ModelCreateCustomPrebuiltEntityRole_568784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568791.validator(path, query, header, formData, body)
  let scheme = call_568791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568791.url(scheme.get, call_568791.host, call_568791.base,
                         call_568791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568791, url, valid)

proc call*(call_568792: Call_ModelCreateCustomPrebuiltEntityRole_568784;
          versionId: string; entityId: string; entityRoleCreateObject: JsonNode;
          appId: string): Recallable =
  ## modelCreateCustomPrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568793 = newJObject()
  var body_568794 = newJObject()
  add(path_568793, "versionId", newJString(versionId))
  add(path_568793, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_568794 = entityRoleCreateObject
  add(path_568793, "appId", newJString(appId))
  result = call_568792.call(path_568793, nil, nil, nil, body_568794)

var modelCreateCustomPrebuiltEntityRole* = Call_ModelCreateCustomPrebuiltEntityRole_568784(
    name: "modelCreateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelCreateCustomPrebuiltEntityRole_568785, base: "",
    url: url_ModelCreateCustomPrebuiltEntityRole_568786, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntityRoles_568775 = ref object of OpenApiRestCall_567668
proc url_ModelListCustomPrebuiltEntityRoles_568777(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltEntityRoles_568776(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568778 = path.getOrDefault("versionId")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "versionId", valid_568778
  var valid_568779 = path.getOrDefault("entityId")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "entityId", valid_568779
  var valid_568780 = path.getOrDefault("appId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "appId", valid_568780
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568781: Call_ModelListCustomPrebuiltEntityRoles_568775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568781.validator(path, query, header, formData, body)
  let scheme = call_568781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568781.url(scheme.get, call_568781.host, call_568781.base,
                         call_568781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568781, url, valid)

proc call*(call_568782: Call_ModelListCustomPrebuiltEntityRoles_568775;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_568783 = newJObject()
  add(path_568783, "versionId", newJString(versionId))
  add(path_568783, "entityId", newJString(entityId))
  add(path_568783, "appId", newJString(appId))
  result = call_568782.call(path_568783, nil, nil, nil, nil)

var modelListCustomPrebuiltEntityRoles* = Call_ModelListCustomPrebuiltEntityRoles_568775(
    name: "modelListCustomPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelListCustomPrebuiltEntityRoles_568776, base: "",
    url: url_ModelListCustomPrebuiltEntityRoles_568777, schemes: {Scheme.Https})
type
  Call_ModelUpdateCustomPrebuiltEntityRole_568805 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateCustomPrebuiltEntityRole_568807(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateCustomPrebuiltEntityRole_568806(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568808 = path.getOrDefault("versionId")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "versionId", valid_568808
  var valid_568809 = path.getOrDefault("entityId")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "entityId", valid_568809
  var valid_568810 = path.getOrDefault("appId")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "appId", valid_568810
  var valid_568811 = path.getOrDefault("roleId")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "roleId", valid_568811
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568813: Call_ModelUpdateCustomPrebuiltEntityRole_568805;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568813.validator(path, query, header, formData, body)
  let scheme = call_568813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568813.url(scheme.get, call_568813.host, call_568813.base,
                         call_568813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568813, url, valid)

proc call*(call_568814: Call_ModelUpdateCustomPrebuiltEntityRole_568805;
          versionId: string; entityRoleUpdateObject: JsonNode; entityId: string;
          appId: string; roleId: string): Recallable =
  ## modelUpdateCustomPrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_568815 = newJObject()
  var body_568816 = newJObject()
  add(path_568815, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_568816 = entityRoleUpdateObject
  add(path_568815, "entityId", newJString(entityId))
  add(path_568815, "appId", newJString(appId))
  add(path_568815, "roleId", newJString(roleId))
  result = call_568814.call(path_568815, nil, nil, nil, body_568816)

var modelUpdateCustomPrebuiltEntityRole* = Call_ModelUpdateCustomPrebuiltEntityRole_568805(
    name: "modelUpdateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateCustomPrebuiltEntityRole_568806, base: "",
    url: url_ModelUpdateCustomPrebuiltEntityRole_568807, schemes: {Scheme.Https})
type
  Call_ModelGetCustomEntityRole_568795 = ref object of OpenApiRestCall_567668
proc url_ModelGetCustomEntityRole_568797(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetCustomEntityRole_568796(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568798 = path.getOrDefault("versionId")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "versionId", valid_568798
  var valid_568799 = path.getOrDefault("entityId")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "entityId", valid_568799
  var valid_568800 = path.getOrDefault("appId")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "appId", valid_568800
  var valid_568801 = path.getOrDefault("roleId")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "roleId", valid_568801
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568802: Call_ModelGetCustomEntityRole_568795; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568802.validator(path, query, header, formData, body)
  let scheme = call_568802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568802.url(scheme.get, call_568802.host, call_568802.base,
                         call_568802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568802, url, valid)

proc call*(call_568803: Call_ModelGetCustomEntityRole_568795; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetCustomEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_568804 = newJObject()
  add(path_568804, "versionId", newJString(versionId))
  add(path_568804, "entityId", newJString(entityId))
  add(path_568804, "appId", newJString(appId))
  add(path_568804, "roleId", newJString(roleId))
  result = call_568803.call(path_568804, nil, nil, nil, nil)

var modelGetCustomEntityRole* = Call_ModelGetCustomEntityRole_568795(
    name: "modelGetCustomEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetCustomEntityRole_568796, base: "",
    url: url_ModelGetCustomEntityRole_568797, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomEntityRole_568817 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteCustomEntityRole_568819(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteCustomEntityRole_568818(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568820 = path.getOrDefault("versionId")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "versionId", valid_568820
  var valid_568821 = path.getOrDefault("entityId")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "entityId", valid_568821
  var valid_568822 = path.getOrDefault("appId")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "appId", valid_568822
  var valid_568823 = path.getOrDefault("roleId")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "roleId", valid_568823
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568824: Call_ModelDeleteCustomEntityRole_568817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568824.validator(path, query, header, formData, body)
  let scheme = call_568824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568824.url(scheme.get, call_568824.host, call_568824.base,
                         call_568824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568824, url, valid)

proc call*(call_568825: Call_ModelDeleteCustomEntityRole_568817; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeleteCustomEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_568826 = newJObject()
  add(path_568826, "versionId", newJString(versionId))
  add(path_568826, "entityId", newJString(entityId))
  add(path_568826, "appId", newJString(appId))
  add(path_568826, "roleId", newJString(roleId))
  result = call_568825.call(path_568826, nil, nil, nil, nil)

var modelDeleteCustomEntityRole* = Call_ModelDeleteCustomEntityRole_568817(
    name: "modelDeleteCustomEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteCustomEntityRole_568818, base: "",
    url: url_ModelDeleteCustomEntityRole_568819, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_568835 = ref object of OpenApiRestCall_567668
proc url_ModelAddCustomPrebuiltIntent_568837(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltintents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddCustomPrebuiltIntent_568836(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a customizable prebuilt intent model to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568838 = path.getOrDefault("versionId")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "versionId", valid_568838
  var valid_568839 = path.getOrDefault("appId")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "appId", valid_568839
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the customizable prebuilt intent and the name of the domain to which this model belongs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568841: Call_ModelAddCustomPrebuiltIntent_568835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt intent model to a version of the application.
  ## 
  let valid = call_568841.validator(path, query, header, formData, body)
  let scheme = call_568841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568841.url(scheme.get, call_568841.host, call_568841.base,
                         call_568841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568841, url, valid)

proc call*(call_568842: Call_ModelAddCustomPrebuiltIntent_568835;
          prebuiltDomainModelCreateObject: JsonNode; versionId: string;
          appId: string): Recallable =
  ## modelAddCustomPrebuiltIntent
  ## Adds a customizable prebuilt intent model to a version of the application.
  ##   prebuiltDomainModelCreateObject: JObject (required)
  ##                                  : A model object containing the name of the customizable prebuilt intent and the name of the domain to which this model belongs.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568843 = newJObject()
  var body_568844 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_568844 = prebuiltDomainModelCreateObject
  add(path_568843, "versionId", newJString(versionId))
  add(path_568843, "appId", newJString(appId))
  result = call_568842.call(path_568843, nil, nil, nil, body_568844)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_568835(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_568836, base: "",
    url: url_ModelAddCustomPrebuiltIntent_568837, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_568827 = ref object of OpenApiRestCall_567668
proc url_ModelListCustomPrebuiltIntents_568829(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltintents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltIntents_568828(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568830 = path.getOrDefault("versionId")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "versionId", valid_568830
  var valid_568831 = path.getOrDefault("appId")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "appId", valid_568831
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568832: Call_ModelListCustomPrebuiltIntents_568827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ## 
  let valid = call_568832.validator(path, query, header, formData, body)
  let scheme = call_568832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568832.url(scheme.get, call_568832.host, call_568832.base,
                         call_568832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568832, url, valid)

proc call*(call_568833: Call_ModelListCustomPrebuiltIntents_568827;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568834 = newJObject()
  add(path_568834, "versionId", newJString(versionId))
  add(path_568834, "appId", newJString(appId))
  result = call_568833.call(path_568834, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_568827(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_568828, base: "",
    url: url_ModelListCustomPrebuiltIntents_568829, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_568845 = ref object of OpenApiRestCall_567668
proc url_ModelListCustomPrebuiltModels_568847(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/customprebuiltmodels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListCustomPrebuiltModels_568846(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568848 = path.getOrDefault("versionId")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "versionId", valid_568848
  var valid_568849 = path.getOrDefault("appId")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "appId", valid_568849
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568850: Call_ModelListCustomPrebuiltModels_568845; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ## 
  let valid = call_568850.validator(path, query, header, formData, body)
  let scheme = call_568850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568850.url(scheme.get, call_568850.host, call_568850.base,
                         call_568850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568850, url, valid)

proc call*(call_568851: Call_ModelListCustomPrebuiltModels_568845;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568852 = newJObject()
  add(path_568852, "versionId", newJString(versionId))
  add(path_568852, "appId", newJString(appId))
  result = call_568851.call(path_568852, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_568845(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_568846, base: "",
    url: url_ModelListCustomPrebuiltModels_568847, schemes: {Scheme.Https})
type
  Call_ModelAddEntity_568864 = ref object of OpenApiRestCall_567668
proc url_ModelAddEntity_568866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddEntity_568865(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds a simple entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568867 = path.getOrDefault("versionId")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "versionId", valid_568867
  var valid_568868 = path.getOrDefault("appId")
  valid_568868 = validateParameter(valid_568868, JString, required = true,
                                 default = nil)
  if valid_568868 != nil:
    section.add "appId", valid_568868
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new simple entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568870: Call_ModelAddEntity_568864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a simple entity extractor to a version of the application.
  ## 
  let valid = call_568870.validator(path, query, header, formData, body)
  let scheme = call_568870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568870.url(scheme.get, call_568870.host, call_568870.base,
                         call_568870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568870, url, valid)

proc call*(call_568871: Call_ModelAddEntity_568864; versionId: string; appId: string;
          modelCreateObject: JsonNode): Recallable =
  ## modelAddEntity
  ## Adds a simple entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new simple entity extractor.
  var path_568872 = newJObject()
  var body_568873 = newJObject()
  add(path_568872, "versionId", newJString(versionId))
  add(path_568872, "appId", newJString(appId))
  if modelCreateObject != nil:
    body_568873 = modelCreateObject
  result = call_568871.call(path_568872, nil, nil, nil, body_568873)

var modelAddEntity* = Call_ModelAddEntity_568864(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_568865, base: "", url: url_ModelAddEntity_568866,
    schemes: {Scheme.Https})
type
  Call_ModelListEntities_568853 = ref object of OpenApiRestCall_567668
proc url_ModelListEntities_568855(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntities_568854(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about all the simple entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568856 = path.getOrDefault("versionId")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "versionId", valid_568856
  var valid_568857 = path.getOrDefault("appId")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "appId", valid_568857
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568858 = query.getOrDefault("skip")
  valid_568858 = validateParameter(valid_568858, JInt, required = false,
                                 default = newJInt(0))
  if valid_568858 != nil:
    section.add "skip", valid_568858
  var valid_568859 = query.getOrDefault("take")
  valid_568859 = validateParameter(valid_568859, JInt, required = false,
                                 default = newJInt(100))
  if valid_568859 != nil:
    section.add "take", valid_568859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568860: Call_ModelListEntities_568853; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the simple entity models in a version of the application.
  ## 
  let valid = call_568860.validator(path, query, header, formData, body)
  let scheme = call_568860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568860.url(scheme.get, call_568860.host, call_568860.base,
                         call_568860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568860, url, valid)

proc call*(call_568861: Call_ModelListEntities_568853; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListEntities
  ## Gets information about all the simple entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568862 = newJObject()
  var query_568863 = newJObject()
  add(path_568862, "versionId", newJString(versionId))
  add(query_568863, "skip", newJInt(skip))
  add(query_568863, "take", newJInt(take))
  add(path_568862, "appId", newJString(appId))
  result = call_568861.call(path_568862, query_568863, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_568853(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_568854, base: "",
    url: url_ModelListEntities_568855, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_568883 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateEntity_568885(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateEntity_568884(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568886 = path.getOrDefault("versionId")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "versionId", valid_568886
  var valid_568887 = path.getOrDefault("entityId")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "entityId", valid_568887
  var valid_568888 = path.getOrDefault("appId")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "appId", valid_568888
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568890: Call_ModelUpdateEntity_568883; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity in a version of the application.
  ## 
  let valid = call_568890.validator(path, query, header, formData, body)
  let scheme = call_568890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568890.url(scheme.get, call_568890.host, call_568890.base,
                         call_568890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568890, url, valid)

proc call*(call_568891: Call_ModelUpdateEntity_568883; versionId: string;
          entityId: string; modelUpdateObject: JsonNode; appId: string): Recallable =
  ## modelUpdateEntity
  ## Updates the name of an entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new entity extractor name.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568892 = newJObject()
  var body_568893 = newJObject()
  add(path_568892, "versionId", newJString(versionId))
  add(path_568892, "entityId", newJString(entityId))
  if modelUpdateObject != nil:
    body_568893 = modelUpdateObject
  add(path_568892, "appId", newJString(appId))
  result = call_568891.call(path_568892, nil, nil, nil, body_568893)

var modelUpdateEntity* = Call_ModelUpdateEntity_568883(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_568884, base: "",
    url: url_ModelUpdateEntity_568885, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_568874 = ref object of OpenApiRestCall_567668
proc url_ModelGetEntity_568876(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetEntity_568875(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about an entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568877 = path.getOrDefault("versionId")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "versionId", valid_568877
  var valid_568878 = path.getOrDefault("entityId")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "entityId", valid_568878
  var valid_568879 = path.getOrDefault("appId")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "appId", valid_568879
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568880: Call_ModelGetEntity_568874; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an entity model in a version of the application.
  ## 
  let valid = call_568880.validator(path, query, header, formData, body)
  let scheme = call_568880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568880.url(scheme.get, call_568880.host, call_568880.base,
                         call_568880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568880, url, valid)

proc call*(call_568881: Call_ModelGetEntity_568874; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetEntity
  ## Gets information about an entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568882 = newJObject()
  add(path_568882, "versionId", newJString(versionId))
  add(path_568882, "entityId", newJString(entityId))
  add(path_568882, "appId", newJString(appId))
  result = call_568881.call(path_568882, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_568874(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_568875, base: "", url: url_ModelGetEntity_568876,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_568894 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteEntity_568896(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteEntity_568895(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568897 = path.getOrDefault("versionId")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "versionId", valid_568897
  var valid_568898 = path.getOrDefault("entityId")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "entityId", valid_568898
  var valid_568899 = path.getOrDefault("appId")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "appId", valid_568899
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568900: Call_ModelDeleteEntity_568894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity from a version of the application.
  ## 
  let valid = call_568900.validator(path, query, header, formData, body)
  let scheme = call_568900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568900.url(scheme.get, call_568900.host, call_568900.base,
                         call_568900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568900, url, valid)

proc call*(call_568901: Call_ModelDeleteEntity_568894; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568902 = newJObject()
  add(path_568902, "versionId", newJString(versionId))
  add(path_568902, "entityId", newJString(entityId))
  add(path_568902, "appId", newJString(appId))
  result = call_568901.call(path_568902, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_568894(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_568895, base: "",
    url: url_ModelDeleteEntity_568896, schemes: {Scheme.Https})
type
  Call_ModelCreateEntityRole_568912 = ref object of OpenApiRestCall_567668
proc url_ModelCreateEntityRole_568914(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateEntityRole_568913(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568915 = path.getOrDefault("versionId")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "versionId", valid_568915
  var valid_568916 = path.getOrDefault("entityId")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "entityId", valid_568916
  var valid_568917 = path.getOrDefault("appId")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "appId", valid_568917
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568919: Call_ModelCreateEntityRole_568912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568919.validator(path, query, header, formData, body)
  let scheme = call_568919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568919.url(scheme.get, call_568919.host, call_568919.base,
                         call_568919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568919, url, valid)

proc call*(call_568920: Call_ModelCreateEntityRole_568912; versionId: string;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string): Recallable =
  ## modelCreateEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568921 = newJObject()
  var body_568922 = newJObject()
  add(path_568921, "versionId", newJString(versionId))
  add(path_568921, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_568922 = entityRoleCreateObject
  add(path_568921, "appId", newJString(appId))
  result = call_568920.call(path_568921, nil, nil, nil, body_568922)

var modelCreateEntityRole* = Call_ModelCreateEntityRole_568912(
    name: "modelCreateEntityRole", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelCreateEntityRole_568913, base: "",
    url: url_ModelCreateEntityRole_568914, schemes: {Scheme.Https})
type
  Call_ModelListEntityRoles_568903 = ref object of OpenApiRestCall_567668
proc url_ModelListEntityRoles_568905(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntityRoles_568904(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568906 = path.getOrDefault("versionId")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "versionId", valid_568906
  var valid_568907 = path.getOrDefault("entityId")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "entityId", valid_568907
  var valid_568908 = path.getOrDefault("appId")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "appId", valid_568908
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568909: Call_ModelListEntityRoles_568903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568909.validator(path, query, header, formData, body)
  let scheme = call_568909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568909.url(scheme.get, call_568909.host, call_568909.base,
                         call_568909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568909, url, valid)

proc call*(call_568910: Call_ModelListEntityRoles_568903; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelListEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_568911 = newJObject()
  add(path_568911, "versionId", newJString(versionId))
  add(path_568911, "entityId", newJString(entityId))
  add(path_568911, "appId", newJString(appId))
  result = call_568910.call(path_568911, nil, nil, nil, nil)

var modelListEntityRoles* = Call_ModelListEntityRoles_568903(
    name: "modelListEntityRoles", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelListEntityRoles_568904, base: "",
    url: url_ModelListEntityRoles_568905, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntityRole_568933 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateEntityRole_568935(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateEntityRole_568934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568936 = path.getOrDefault("versionId")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "versionId", valid_568936
  var valid_568937 = path.getOrDefault("entityId")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "entityId", valid_568937
  var valid_568938 = path.getOrDefault("appId")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "appId", valid_568938
  var valid_568939 = path.getOrDefault("roleId")
  valid_568939 = validateParameter(valid_568939, JString, required = true,
                                 default = nil)
  if valid_568939 != nil:
    section.add "roleId", valid_568939
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568941: Call_ModelUpdateEntityRole_568933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568941.validator(path, query, header, formData, body)
  let scheme = call_568941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568941.url(scheme.get, call_568941.host, call_568941.base,
                         call_568941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568941, url, valid)

proc call*(call_568942: Call_ModelUpdateEntityRole_568933; versionId: string;
          entityRoleUpdateObject: JsonNode; entityId: string; appId: string;
          roleId: string): Recallable =
  ## modelUpdateEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_568943 = newJObject()
  var body_568944 = newJObject()
  add(path_568943, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_568944 = entityRoleUpdateObject
  add(path_568943, "entityId", newJString(entityId))
  add(path_568943, "appId", newJString(appId))
  add(path_568943, "roleId", newJString(roleId))
  result = call_568942.call(path_568943, nil, nil, nil, body_568944)

var modelUpdateEntityRole* = Call_ModelUpdateEntityRole_568933(
    name: "modelUpdateEntityRole", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateEntityRole_568934, base: "",
    url: url_ModelUpdateEntityRole_568935, schemes: {Scheme.Https})
type
  Call_ModelGetEntityRole_568923 = ref object of OpenApiRestCall_567668
proc url_ModelGetEntityRole_568925(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetEntityRole_568924(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568926 = path.getOrDefault("versionId")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "versionId", valid_568926
  var valid_568927 = path.getOrDefault("entityId")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "entityId", valid_568927
  var valid_568928 = path.getOrDefault("appId")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "appId", valid_568928
  var valid_568929 = path.getOrDefault("roleId")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "roleId", valid_568929
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568930: Call_ModelGetEntityRole_568923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568930.validator(path, query, header, formData, body)
  let scheme = call_568930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568930.url(scheme.get, call_568930.host, call_568930.base,
                         call_568930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568930, url, valid)

proc call*(call_568931: Call_ModelGetEntityRole_568923; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_568932 = newJObject()
  add(path_568932, "versionId", newJString(versionId))
  add(path_568932, "entityId", newJString(entityId))
  add(path_568932, "appId", newJString(appId))
  add(path_568932, "roleId", newJString(roleId))
  result = call_568931.call(path_568932, nil, nil, nil, nil)

var modelGetEntityRole* = Call_ModelGetEntityRole_568923(
    name: "modelGetEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetEntityRole_568924, base: "",
    url: url_ModelGetEntityRole_568925, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntityRole_568945 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteEntityRole_568947(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteEntityRole_568946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568948 = path.getOrDefault("versionId")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "versionId", valid_568948
  var valid_568949 = path.getOrDefault("entityId")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "entityId", valid_568949
  var valid_568950 = path.getOrDefault("appId")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "appId", valid_568950
  var valid_568951 = path.getOrDefault("roleId")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "roleId", valid_568951
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568952: Call_ModelDeleteEntityRole_568945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568952.validator(path, query, header, formData, body)
  let scheme = call_568952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568952.url(scheme.get, call_568952.host, call_568952.base,
                         call_568952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568952, url, valid)

proc call*(call_568953: Call_ModelDeleteEntityRole_568945; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeleteEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_568954 = newJObject()
  add(path_568954, "versionId", newJString(versionId))
  add(path_568954, "entityId", newJString(entityId))
  add(path_568954, "appId", newJString(appId))
  add(path_568954, "roleId", newJString(roleId))
  result = call_568953.call(path_568954, nil, nil, nil, nil)

var modelDeleteEntityRole* = Call_ModelDeleteEntityRole_568945(
    name: "modelDeleteEntityRole", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteEntityRole_568946, base: "",
    url: url_ModelDeleteEntityRole_568947, schemes: {Scheme.Https})
type
  Call_ModelListEntitySuggestions_568955 = ref object of OpenApiRestCall_567668
proc url_ModelListEntitySuggestions_568957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListEntitySuggestions_568956(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The target entity extractor model to enhance.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568958 = path.getOrDefault("versionId")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "versionId", valid_568958
  var valid_568959 = path.getOrDefault("entityId")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "entityId", valid_568959
  var valid_568960 = path.getOrDefault("appId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "appId", valid_568960
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568961 = query.getOrDefault("take")
  valid_568961 = validateParameter(valid_568961, JInt, required = false,
                                 default = newJInt(100))
  if valid_568961 != nil:
    section.add "take", valid_568961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568962: Call_ModelListEntitySuggestions_568955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ## 
  let valid = call_568962.validator(path, query, header, formData, body)
  let scheme = call_568962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568962.url(scheme.get, call_568962.host, call_568962.base,
                         call_568962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568962, url, valid)

proc call*(call_568963: Call_ModelListEntitySuggestions_568955; versionId: string;
          entityId: string; appId: string; take: int = 100): Recallable =
  ## modelListEntitySuggestions
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The target entity extractor model to enhance.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568964 = newJObject()
  var query_568965 = newJObject()
  add(path_568964, "versionId", newJString(versionId))
  add(path_568964, "entityId", newJString(entityId))
  add(query_568965, "take", newJInt(take))
  add(path_568964, "appId", newJString(appId))
  result = call_568963.call(path_568964, query_568965, nil, nil, nil)

var modelListEntitySuggestions* = Call_ModelListEntitySuggestions_568955(
    name: "modelListEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelListEntitySuggestions_568956, base: "",
    url: url_ModelListEntitySuggestions_568957, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_568966 = ref object of OpenApiRestCall_567668
proc url_ExamplesAdd_568968(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/example")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesAdd_568967(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a labeled example utterance in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568969 = path.getOrDefault("versionId")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "versionId", valid_568969
  var valid_568970 = path.getOrDefault("appId")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "appId", valid_568970
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObject: JObject (required)
  ##                     : A labeled example utterance with the expected intent and entities.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568972: Call_ExamplesAdd_568966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example utterance in a version of the application.
  ## 
  let valid = call_568972.validator(path, query, header, formData, body)
  let scheme = call_568972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568972.url(scheme.get, call_568972.host, call_568972.base,
                         call_568972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568972, url, valid)

proc call*(call_568973: Call_ExamplesAdd_568966; versionId: string; appId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example utterance in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : A labeled example utterance with the expected intent and entities.
  var path_568974 = newJObject()
  var body_568975 = newJObject()
  add(path_568974, "versionId", newJString(versionId))
  add(path_568974, "appId", newJString(appId))
  if exampleLabelObject != nil:
    body_568975 = exampleLabelObject
  result = call_568973.call(path_568974, nil, nil, nil, body_568975)

var examplesAdd* = Call_ExamplesAdd_568966(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_568967,
                                        base: "", url: url_ExamplesAdd_568968,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_568987 = ref object of OpenApiRestCall_567668
proc url_ExamplesBatch_568989(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesBatch_568988(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a batch of labeled example utterances to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568990 = path.getOrDefault("versionId")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "versionId", valid_568990
  var valid_568991 = path.getOrDefault("appId")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "appId", valid_568991
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of example utterances.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568993: Call_ExamplesBatch_568987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled example utterances to a version of the application.
  ## 
  let valid = call_568993.validator(path, query, header, formData, body)
  let scheme = call_568993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568993.url(scheme.get, call_568993.host, call_568993.base,
                         call_568993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568993, url, valid)

proc call*(call_568994: Call_ExamplesBatch_568987; versionId: string; appId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled example utterances to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of example utterances.
  var path_568995 = newJObject()
  var body_568996 = newJObject()
  add(path_568995, "versionId", newJString(versionId))
  add(path_568995, "appId", newJString(appId))
  if exampleLabelObjectArray != nil:
    body_568996 = exampleLabelObjectArray
  result = call_568994.call(path_568995, nil, nil, nil, body_568996)

var examplesBatch* = Call_ExamplesBatch_568987(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_568988, base: "", url: url_ExamplesBatch_568989,
    schemes: {Scheme.Https})
type
  Call_ExamplesList_568976 = ref object of OpenApiRestCall_567668
proc url_ExamplesList_568978(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesList_568977(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns example utterances to be reviewed from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_568979 = path.getOrDefault("versionId")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "versionId", valid_568979
  var valid_568980 = path.getOrDefault("appId")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "appId", valid_568980
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_568981 = query.getOrDefault("skip")
  valid_568981 = validateParameter(valid_568981, JInt, required = false,
                                 default = newJInt(0))
  if valid_568981 != nil:
    section.add "skip", valid_568981
  var valid_568982 = query.getOrDefault("take")
  valid_568982 = validateParameter(valid_568982, JInt, required = false,
                                 default = newJInt(100))
  if valid_568982 != nil:
    section.add "take", valid_568982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568983: Call_ExamplesList_568976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns example utterances to be reviewed from a version of the application.
  ## 
  let valid = call_568983.validator(path, query, header, formData, body)
  let scheme = call_568983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568983.url(scheme.get, call_568983.host, call_568983.base,
                         call_568983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568983, url, valid)

proc call*(call_568984: Call_ExamplesList_568976; versionId: string; appId: string;
          skip: int = 0; take: int = 100): Recallable =
  ## examplesList
  ## Returns example utterances to be reviewed from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_568985 = newJObject()
  var query_568986 = newJObject()
  add(path_568985, "versionId", newJString(versionId))
  add(query_568986, "skip", newJInt(skip))
  add(query_568986, "take", newJInt(take))
  add(path_568985, "appId", newJString(appId))
  result = call_568984.call(path_568985, query_568986, nil, nil, nil)

var examplesList* = Call_ExamplesList_568976(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_568977, base: "", url: url_ExamplesList_568978,
    schemes: {Scheme.Https})
type
  Call_ExamplesDelete_568997 = ref object of OpenApiRestCall_567668
proc url_ExamplesDelete_568999(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "exampleId" in path, "`exampleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/examples/"),
               (kind: VariableSegment, value: "exampleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExamplesDelete_568998(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   exampleId: JInt (required)
  ##            : The example ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569000 = path.getOrDefault("versionId")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "versionId", valid_569000
  var valid_569001 = path.getOrDefault("appId")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "appId", valid_569001
  var valid_569002 = path.getOrDefault("exampleId")
  valid_569002 = validateParameter(valid_569002, JInt, required = true, default = nil)
  if valid_569002 != nil:
    section.add "exampleId", valid_569002
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569003: Call_ExamplesDelete_568997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ## 
  let valid = call_569003.validator(path, query, header, formData, body)
  let scheme = call_569003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569003.url(scheme.get, call_569003.host, call_569003.base,
                         call_569003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569003, url, valid)

proc call*(call_569004: Call_ExamplesDelete_568997; versionId: string; appId: string;
          exampleId: int): Recallable =
  ## examplesDelete
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleId: int (required)
  ##            : The example ID.
  var path_569005 = newJObject()
  add(path_569005, "versionId", newJString(versionId))
  add(path_569005, "appId", newJString(appId))
  add(path_569005, "exampleId", newJInt(exampleId))
  result = call_569004.call(path_569005, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_568997(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_568998, base: "", url: url_ExamplesDelete_568999,
    schemes: {Scheme.Https})
type
  Call_VersionsExport_569006 = ref object of OpenApiRestCall_567668
proc url_VersionsExport_569008(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsExport_569007(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Exports a LUIS application to JSON format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569009 = path.getOrDefault("versionId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "versionId", valid_569009
  var valid_569010 = path.getOrDefault("appId")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "appId", valid_569010
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569011: Call_VersionsExport_569006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_569011.validator(path, query, header, formData, body)
  let scheme = call_569011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569011.url(scheme.get, call_569011.host, call_569011.base,
                         call_569011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569011, url, valid)

proc call*(call_569012: Call_VersionsExport_569006; versionId: string; appId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569013 = newJObject()
  add(path_569013, "versionId", newJString(versionId))
  add(path_569013, "appId", newJString(appId))
  result = call_569012.call(path_569013, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_569006(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_569007, base: "", url: url_VersionsExport_569008,
    schemes: {Scheme.Https})
type
  Call_FeaturesList_569014 = ref object of OpenApiRestCall_567668
proc url_FeaturesList_569016(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesList_569015(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569017 = path.getOrDefault("versionId")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "versionId", valid_569017
  var valid_569018 = path.getOrDefault("appId")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "appId", valid_569018
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569019 = query.getOrDefault("skip")
  valid_569019 = validateParameter(valid_569019, JInt, required = false,
                                 default = newJInt(0))
  if valid_569019 != nil:
    section.add "skip", valid_569019
  var valid_569020 = query.getOrDefault("take")
  valid_569020 = validateParameter(valid_569020, JInt, required = false,
                                 default = newJInt(100))
  if valid_569020 != nil:
    section.add "take", valid_569020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569021: Call_FeaturesList_569014; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ## 
  let valid = call_569021.validator(path, query, header, formData, body)
  let scheme = call_569021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569021.url(scheme.get, call_569021.host, call_569021.base,
                         call_569021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569021, url, valid)

proc call*(call_569022: Call_FeaturesList_569014; versionId: string; appId: string;
          skip: int = 0; take: int = 100): Recallable =
  ## featuresList
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569023 = newJObject()
  var query_569024 = newJObject()
  add(path_569023, "versionId", newJString(versionId))
  add(query_569024, "skip", newJInt(skip))
  add(query_569024, "take", newJInt(take))
  add(path_569023, "appId", newJString(appId))
  result = call_569022.call(path_569023, query_569024, nil, nil, nil)

var featuresList* = Call_FeaturesList_569014(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_569015, base: "", url: url_FeaturesList_569016,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_569036 = ref object of OpenApiRestCall_567668
proc url_ModelAddHierarchicalEntity_569038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddHierarchicalEntity_569037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a hierarchical entity extractor to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569039 = path.getOrDefault("versionId")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "versionId", valid_569039
  var valid_569040 = path.getOrDefault("appId")
  valid_569040 = validateParameter(valid_569040, JString, required = true,
                                 default = nil)
  if valid_569040 != nil:
    section.add "appId", valid_569040
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569042: Call_ModelAddHierarchicalEntity_569036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to a version of the application.
  ## 
  let valid = call_569042.validator(path, query, header, formData, body)
  let scheme = call_569042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569042.url(scheme.get, call_569042.host, call_569042.base,
                         call_569042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569042, url, valid)

proc call*(call_569043: Call_ModelAddHierarchicalEntity_569036; versionId: string;
          hierarchicalModelCreateObject: JsonNode; appId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569044 = newJObject()
  var body_569045 = newJObject()
  add(path_569044, "versionId", newJString(versionId))
  if hierarchicalModelCreateObject != nil:
    body_569045 = hierarchicalModelCreateObject
  add(path_569044, "appId", newJString(appId))
  result = call_569043.call(path_569044, nil, nil, nil, body_569045)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_569036(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_569037, base: "",
    url: url_ModelAddHierarchicalEntity_569038, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_569025 = ref object of OpenApiRestCall_567668
proc url_ModelListHierarchicalEntities_569027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListHierarchicalEntities_569026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about all the hierarchical entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569028 = path.getOrDefault("versionId")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "versionId", valid_569028
  var valid_569029 = path.getOrDefault("appId")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "appId", valid_569029
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569030 = query.getOrDefault("skip")
  valid_569030 = validateParameter(valid_569030, JInt, required = false,
                                 default = newJInt(0))
  if valid_569030 != nil:
    section.add "skip", valid_569030
  var valid_569031 = query.getOrDefault("take")
  valid_569031 = validateParameter(valid_569031, JInt, required = false,
                                 default = newJInt(100))
  if valid_569031 != nil:
    section.add "take", valid_569031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569032: Call_ModelListHierarchicalEntities_569025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the hierarchical entity models in a version of the application.
  ## 
  let valid = call_569032.validator(path, query, header, formData, body)
  let scheme = call_569032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569032.url(scheme.get, call_569032.host, call_569032.base,
                         call_569032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569032, url, valid)

proc call*(call_569033: Call_ModelListHierarchicalEntities_569025;
          versionId: string; appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListHierarchicalEntities
  ## Gets information about all the hierarchical entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569034 = newJObject()
  var query_569035 = newJObject()
  add(path_569034, "versionId", newJString(versionId))
  add(query_569035, "skip", newJInt(skip))
  add(query_569035, "take", newJInt(take))
  add(path_569034, "appId", newJString(appId))
  result = call_569033.call(path_569034, query_569035, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_569025(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_569026, base: "",
    url: url_ModelListHierarchicalEntities_569027, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_569055 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateHierarchicalEntity_569057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntity_569056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569058 = path.getOrDefault("versionId")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "versionId", valid_569058
  var valid_569059 = path.getOrDefault("appId")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "appId", valid_569059
  var valid_569060 = path.getOrDefault("hEntityId")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "hEntityId", valid_569060
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569062: Call_ModelUpdateHierarchicalEntity_569055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ## 
  let valid = call_569062.validator(path, query, header, formData, body)
  let scheme = call_569062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569062.url(scheme.get, call_569062.host, call_569062.base,
                         call_569062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569062, url, valid)

proc call*(call_569063: Call_ModelUpdateHierarchicalEntity_569055;
          versionId: string; appId: string; hierarchicalModelUpdateObject: JsonNode;
          hEntityId: string): Recallable =
  ## modelUpdateHierarchicalEntity
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hierarchicalModelUpdateObject: JObject (required)
  ##                                : Model containing names of the children of the hierarchical entity.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569064 = newJObject()
  var body_569065 = newJObject()
  add(path_569064, "versionId", newJString(versionId))
  add(path_569064, "appId", newJString(appId))
  if hierarchicalModelUpdateObject != nil:
    body_569065 = hierarchicalModelUpdateObject
  add(path_569064, "hEntityId", newJString(hEntityId))
  result = call_569063.call(path_569064, nil, nil, nil, body_569065)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_569055(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_569056, base: "",
    url: url_ModelUpdateHierarchicalEntity_569057, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_569046 = ref object of OpenApiRestCall_567668
proc url_ModelGetHierarchicalEntity_569048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntity_569047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a hierarchical entity in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569049 = path.getOrDefault("versionId")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "versionId", valid_569049
  var valid_569050 = path.getOrDefault("appId")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "appId", valid_569050
  var valid_569051 = path.getOrDefault("hEntityId")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "hEntityId", valid_569051
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_ModelGetHierarchicalEntity_569046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a hierarchical entity in a version of the application.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_ModelGetHierarchicalEntity_569046; versionId: string;
          appId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about a hierarchical entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569054 = newJObject()
  add(path_569054, "versionId", newJString(versionId))
  add(path_569054, "appId", newJString(appId))
  add(path_569054, "hEntityId", newJString(hEntityId))
  result = call_569053.call(path_569054, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_569046(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_569047, base: "",
    url: url_ModelGetHierarchicalEntity_569048, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_569066 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteHierarchicalEntity_569068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntity_569067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569069 = path.getOrDefault("versionId")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "versionId", valid_569069
  var valid_569070 = path.getOrDefault("appId")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "appId", valid_569070
  var valid_569071 = path.getOrDefault("hEntityId")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "hEntityId", valid_569071
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569072: Call_ModelDeleteHierarchicalEntity_569066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity from a version of the application.
  ## 
  let valid = call_569072.validator(path, query, header, formData, body)
  let scheme = call_569072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569072.url(scheme.get, call_569072.host, call_569072.base,
                         call_569072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569072, url, valid)

proc call*(call_569073: Call_ModelDeleteHierarchicalEntity_569066;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569074 = newJObject()
  add(path_569074, "versionId", newJString(versionId))
  add(path_569074, "appId", newJString(appId))
  add(path_569074, "hEntityId", newJString(hEntityId))
  result = call_569073.call(path_569074, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_569066(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_569067, base: "",
    url: url_ModelDeleteHierarchicalEntity_569068, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_569075 = ref object of OpenApiRestCall_567668
proc url_ModelAddHierarchicalEntityChild_569077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddHierarchicalEntityChild_569076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569078 = path.getOrDefault("versionId")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "versionId", valid_569078
  var valid_569079 = path.getOrDefault("appId")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "appId", valid_569079
  var valid_569080 = path.getOrDefault("hEntityId")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "hEntityId", valid_569080
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569082: Call_ModelAddHierarchicalEntityChild_569075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_569082.validator(path, query, header, formData, body)
  let scheme = call_569082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569082.url(scheme.get, call_569082.host, call_569082.base,
                         call_569082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569082, url, valid)

proc call*(call_569083: Call_ModelAddHierarchicalEntityChild_569075;
          versionId: string; hierarchicalChildModelCreateObject: JsonNode;
          appId: string; hEntityId: string): Recallable =
  ## modelAddHierarchicalEntityChild
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalChildModelCreateObject: JObject (required)
  ##                                     : A model object containing the name of the new hierarchical child model.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569084 = newJObject()
  var body_569085 = newJObject()
  add(path_569084, "versionId", newJString(versionId))
  if hierarchicalChildModelCreateObject != nil:
    body_569085 = hierarchicalChildModelCreateObject
  add(path_569084, "appId", newJString(appId))
  add(path_569084, "hEntityId", newJString(hEntityId))
  result = call_569083.call(path_569084, nil, nil, nil, body_569085)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_569075(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_569076, base: "",
    url: url_ModelAddHierarchicalEntityChild_569077, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_569096 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateHierarchicalEntityChild_569098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntityChild_569097(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569099 = path.getOrDefault("versionId")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "versionId", valid_569099
  var valid_569100 = path.getOrDefault("appId")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "appId", valid_569100
  var valid_569101 = path.getOrDefault("hChildId")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "hChildId", valid_569101
  var valid_569102 = path.getOrDefault("hEntityId")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "hEntityId", valid_569102
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   hierarchicalChildModelUpdateObject: JObject (required)
  ##                                     : Model object containing new name of the hierarchical entity child.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569104: Call_ModelUpdateHierarchicalEntityChild_569096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_569104.validator(path, query, header, formData, body)
  let scheme = call_569104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569104.url(scheme.get, call_569104.host, call_569104.base,
                         call_569104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569104, url, valid)

proc call*(call_569105: Call_ModelUpdateHierarchicalEntityChild_569096;
          versionId: string; hierarchicalChildModelUpdateObject: JsonNode;
          appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelUpdateHierarchicalEntityChild
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalChildModelUpdateObject: JObject (required)
  ##                                     : Model object containing new name of the hierarchical entity child.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569106 = newJObject()
  var body_569107 = newJObject()
  add(path_569106, "versionId", newJString(versionId))
  if hierarchicalChildModelUpdateObject != nil:
    body_569107 = hierarchicalChildModelUpdateObject
  add(path_569106, "appId", newJString(appId))
  add(path_569106, "hChildId", newJString(hChildId))
  add(path_569106, "hEntityId", newJString(hEntityId))
  result = call_569105.call(path_569106, nil, nil, nil, body_569107)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_569096(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_569097, base: "",
    url: url_ModelUpdateHierarchicalEntityChild_569098, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_569086 = ref object of OpenApiRestCall_567668
proc url_ModelGetHierarchicalEntityChild_569088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntityChild_569087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569089 = path.getOrDefault("versionId")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "versionId", valid_569089
  var valid_569090 = path.getOrDefault("appId")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "appId", valid_569090
  var valid_569091 = path.getOrDefault("hChildId")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "hChildId", valid_569091
  var valid_569092 = path.getOrDefault("hEntityId")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "hEntityId", valid_569092
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569093: Call_ModelGetHierarchicalEntityChild_569086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ## 
  let valid = call_569093.validator(path, query, header, formData, body)
  let scheme = call_569093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569093.url(scheme.get, call_569093.host, call_569093.base,
                         call_569093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569093, url, valid)

proc call*(call_569094: Call_ModelGetHierarchicalEntityChild_569086;
          versionId: string; appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntityChild
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569095 = newJObject()
  add(path_569095, "versionId", newJString(versionId))
  add(path_569095, "appId", newJString(appId))
  add(path_569095, "hChildId", newJString(hChildId))
  add(path_569095, "hEntityId", newJString(hEntityId))
  result = call_569094.call(path_569095, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_569086(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_569087, base: "",
    url: url_ModelGetHierarchicalEntityChild_569088, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_569108 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteHierarchicalEntityChild_569110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "hChildId" in path, "`hChildId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/children/"),
               (kind: VariableSegment, value: "hChildId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntityChild_569109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hChildId: JString (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569111 = path.getOrDefault("versionId")
  valid_569111 = validateParameter(valid_569111, JString, required = true,
                                 default = nil)
  if valid_569111 != nil:
    section.add "versionId", valid_569111
  var valid_569112 = path.getOrDefault("appId")
  valid_569112 = validateParameter(valid_569112, JString, required = true,
                                 default = nil)
  if valid_569112 != nil:
    section.add "appId", valid_569112
  var valid_569113 = path.getOrDefault("hChildId")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = nil)
  if valid_569113 != nil:
    section.add "hChildId", valid_569113
  var valid_569114 = path.getOrDefault("hEntityId")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "hEntityId", valid_569114
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569115: Call_ModelDeleteHierarchicalEntityChild_569108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ## 
  let valid = call_569115.validator(path, query, header, formData, body)
  let scheme = call_569115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569115.url(scheme.get, call_569115.host, call_569115.base,
                         call_569115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569115, url, valid)

proc call*(call_569116: Call_ModelDeleteHierarchicalEntityChild_569108;
          versionId: string; appId: string; hChildId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntityChild
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hChildId: string (required)
  ##           : The hierarchical entity extractor child ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569117 = newJObject()
  add(path_569117, "versionId", newJString(versionId))
  add(path_569117, "appId", newJString(appId))
  add(path_569117, "hChildId", newJString(hChildId))
  add(path_569117, "hEntityId", newJString(hEntityId))
  result = call_569116.call(path_569117, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_569108(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_569109, base: "",
    url: url_ModelDeleteHierarchicalEntityChild_569110, schemes: {Scheme.Https})
type
  Call_ModelCreateHierarchicalEntityRole_569127 = ref object of OpenApiRestCall_567668
proc url_ModelCreateHierarchicalEntityRole_569129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateHierarchicalEntityRole_569128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569130 = path.getOrDefault("versionId")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "versionId", valid_569130
  var valid_569131 = path.getOrDefault("appId")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "appId", valid_569131
  var valid_569132 = path.getOrDefault("hEntityId")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "hEntityId", valid_569132
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569134: Call_ModelCreateHierarchicalEntityRole_569127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569134.validator(path, query, header, formData, body)
  let scheme = call_569134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569134.url(scheme.get, call_569134.host, call_569134.base,
                         call_569134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569134, url, valid)

proc call*(call_569135: Call_ModelCreateHierarchicalEntityRole_569127;
          versionId: string; entityRoleCreateObject: JsonNode; appId: string;
          hEntityId: string): Recallable =
  ## modelCreateHierarchicalEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569136 = newJObject()
  var body_569137 = newJObject()
  add(path_569136, "versionId", newJString(versionId))
  if entityRoleCreateObject != nil:
    body_569137 = entityRoleCreateObject
  add(path_569136, "appId", newJString(appId))
  add(path_569136, "hEntityId", newJString(hEntityId))
  result = call_569135.call(path_569136, nil, nil, nil, body_569137)

var modelCreateHierarchicalEntityRole* = Call_ModelCreateHierarchicalEntityRole_569127(
    name: "modelCreateHierarchicalEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelCreateHierarchicalEntityRole_569128, base: "",
    url: url_ModelCreateHierarchicalEntityRole_569129, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntityRoles_569118 = ref object of OpenApiRestCall_567668
proc url_ModelListHierarchicalEntityRoles_569120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListHierarchicalEntityRoles_569119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569121 = path.getOrDefault("versionId")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "versionId", valid_569121
  var valid_569122 = path.getOrDefault("appId")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "appId", valid_569122
  var valid_569123 = path.getOrDefault("hEntityId")
  valid_569123 = validateParameter(valid_569123, JString, required = true,
                                 default = nil)
  if valid_569123 != nil:
    section.add "hEntityId", valid_569123
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569124: Call_ModelListHierarchicalEntityRoles_569118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569124.validator(path, query, header, formData, body)
  let scheme = call_569124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569124.url(scheme.get, call_569124.host, call_569124.base,
                         call_569124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569124, url, valid)

proc call*(call_569125: Call_ModelListHierarchicalEntityRoles_569118;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelListHierarchicalEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569126 = newJObject()
  add(path_569126, "versionId", newJString(versionId))
  add(path_569126, "appId", newJString(appId))
  add(path_569126, "hEntityId", newJString(hEntityId))
  result = call_569125.call(path_569126, nil, nil, nil, nil)

var modelListHierarchicalEntityRoles* = Call_ModelListHierarchicalEntityRoles_569118(
    name: "modelListHierarchicalEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelListHierarchicalEntityRoles_569119, base: "",
    url: url_ModelListHierarchicalEntityRoles_569120, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityRole_569148 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateHierarchicalEntityRole_569150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateHierarchicalEntityRole_569149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569151 = path.getOrDefault("versionId")
  valid_569151 = validateParameter(valid_569151, JString, required = true,
                                 default = nil)
  if valid_569151 != nil:
    section.add "versionId", valid_569151
  var valid_569152 = path.getOrDefault("appId")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "appId", valid_569152
  var valid_569153 = path.getOrDefault("roleId")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "roleId", valid_569153
  var valid_569154 = path.getOrDefault("hEntityId")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "hEntityId", valid_569154
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569156: Call_ModelUpdateHierarchicalEntityRole_569148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569156.validator(path, query, header, formData, body)
  let scheme = call_569156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569156.url(scheme.get, call_569156.host, call_569156.base,
                         call_569156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569156, url, valid)

proc call*(call_569157: Call_ModelUpdateHierarchicalEntityRole_569148;
          versionId: string; entityRoleUpdateObject: JsonNode; appId: string;
          roleId: string; hEntityId: string): Recallable =
  ## modelUpdateHierarchicalEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569158 = newJObject()
  var body_569159 = newJObject()
  add(path_569158, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_569159 = entityRoleUpdateObject
  add(path_569158, "appId", newJString(appId))
  add(path_569158, "roleId", newJString(roleId))
  add(path_569158, "hEntityId", newJString(hEntityId))
  result = call_569157.call(path_569158, nil, nil, nil, body_569159)

var modelUpdateHierarchicalEntityRole* = Call_ModelUpdateHierarchicalEntityRole_569148(
    name: "modelUpdateHierarchicalEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateHierarchicalEntityRole_569149, base: "",
    url: url_ModelUpdateHierarchicalEntityRole_569150, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityRole_569138 = ref object of OpenApiRestCall_567668
proc url_ModelGetHierarchicalEntityRole_569140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetHierarchicalEntityRole_569139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569141 = path.getOrDefault("versionId")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "versionId", valid_569141
  var valid_569142 = path.getOrDefault("appId")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "appId", valid_569142
  var valid_569143 = path.getOrDefault("roleId")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "roleId", valid_569143
  var valid_569144 = path.getOrDefault("hEntityId")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "hEntityId", valid_569144
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569145: Call_ModelGetHierarchicalEntityRole_569138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569145.validator(path, query, header, formData, body)
  let scheme = call_569145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569145.url(scheme.get, call_569145.host, call_569145.base,
                         call_569145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569145, url, valid)

proc call*(call_569146: Call_ModelGetHierarchicalEntityRole_569138;
          versionId: string; appId: string; roleId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569147 = newJObject()
  add(path_569147, "versionId", newJString(versionId))
  add(path_569147, "appId", newJString(appId))
  add(path_569147, "roleId", newJString(roleId))
  add(path_569147, "hEntityId", newJString(hEntityId))
  result = call_569146.call(path_569147, nil, nil, nil, nil)

var modelGetHierarchicalEntityRole* = Call_ModelGetHierarchicalEntityRole_569138(
    name: "modelGetHierarchicalEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelGetHierarchicalEntityRole_569139, base: "",
    url: url_ModelGetHierarchicalEntityRole_569140, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityRole_569160 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteHierarchicalEntityRole_569162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "hEntityId" in path, "`hEntityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/hierarchicalentities/"),
               (kind: VariableSegment, value: "hEntityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteHierarchicalEntityRole_569161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  ##   hEntityId: JString (required)
  ##            : The hierarchical entity extractor ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569163 = path.getOrDefault("versionId")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "versionId", valid_569163
  var valid_569164 = path.getOrDefault("appId")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "appId", valid_569164
  var valid_569165 = path.getOrDefault("roleId")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "roleId", valid_569165
  var valid_569166 = path.getOrDefault("hEntityId")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "hEntityId", valid_569166
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569167: Call_ModelDeleteHierarchicalEntityRole_569160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569167.validator(path, query, header, formData, body)
  let scheme = call_569167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569167.url(scheme.get, call_569167.host, call_569167.base,
                         call_569167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569167, url, valid)

proc call*(call_569168: Call_ModelDeleteHierarchicalEntityRole_569160;
          versionId: string; appId: string; roleId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_569169 = newJObject()
  add(path_569169, "versionId", newJString(versionId))
  add(path_569169, "appId", newJString(appId))
  add(path_569169, "roleId", newJString(roleId))
  add(path_569169, "hEntityId", newJString(hEntityId))
  result = call_569168.call(path_569169, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityRole* = Call_ModelDeleteHierarchicalEntityRole_569160(
    name: "modelDeleteHierarchicalEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteHierarchicalEntityRole_569161, base: "",
    url: url_ModelDeleteHierarchicalEntityRole_569162, schemes: {Scheme.Https})
type
  Call_ModelAddIntent_569181 = ref object of OpenApiRestCall_567668
proc url_ModelAddIntent_569183(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddIntent_569182(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an intent to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569184 = path.getOrDefault("versionId")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "versionId", valid_569184
  var valid_569185 = path.getOrDefault("appId")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "appId", valid_569185
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569187: Call_ModelAddIntent_569181; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent to a version of the application.
  ## 
  let valid = call_569187.validator(path, query, header, formData, body)
  let scheme = call_569187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569187.url(scheme.get, call_569187.host, call_569187.base,
                         call_569187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569187, url, valid)

proc call*(call_569188: Call_ModelAddIntent_569181; versionId: string; appId: string;
          intentCreateObject: JsonNode): Recallable =
  ## modelAddIntent
  ## Adds an intent to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent.
  var path_569189 = newJObject()
  var body_569190 = newJObject()
  add(path_569189, "versionId", newJString(versionId))
  add(path_569189, "appId", newJString(appId))
  if intentCreateObject != nil:
    body_569190 = intentCreateObject
  result = call_569188.call(path_569189, nil, nil, nil, body_569190)

var modelAddIntent* = Call_ModelAddIntent_569181(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_569182, base: "", url: url_ModelAddIntent_569183,
    schemes: {Scheme.Https})
type
  Call_ModelListIntents_569170 = ref object of OpenApiRestCall_567668
proc url_ModelListIntents_569172(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListIntents_569171(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the intent models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569173 = path.getOrDefault("versionId")
  valid_569173 = validateParameter(valid_569173, JString, required = true,
                                 default = nil)
  if valid_569173 != nil:
    section.add "versionId", valid_569173
  var valid_569174 = path.getOrDefault("appId")
  valid_569174 = validateParameter(valid_569174, JString, required = true,
                                 default = nil)
  if valid_569174 != nil:
    section.add "appId", valid_569174
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569175 = query.getOrDefault("skip")
  valid_569175 = validateParameter(valid_569175, JInt, required = false,
                                 default = newJInt(0))
  if valid_569175 != nil:
    section.add "skip", valid_569175
  var valid_569176 = query.getOrDefault("take")
  valid_569176 = validateParameter(valid_569176, JInt, required = false,
                                 default = newJInt(100))
  if valid_569176 != nil:
    section.add "take", valid_569176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569177: Call_ModelListIntents_569170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models in a version of the application.
  ## 
  let valid = call_569177.validator(path, query, header, formData, body)
  let scheme = call_569177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569177.url(scheme.get, call_569177.host, call_569177.base,
                         call_569177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569177, url, valid)

proc call*(call_569178: Call_ModelListIntents_569170; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListIntents
  ## Gets information about the intent models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569179 = newJObject()
  var query_569180 = newJObject()
  add(path_569179, "versionId", newJString(versionId))
  add(query_569180, "skip", newJInt(skip))
  add(query_569180, "take", newJInt(take))
  add(path_569179, "appId", newJString(appId))
  result = call_569178.call(path_569179, query_569180, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_569170(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_569171, base: "",
    url: url_ModelListIntents_569172, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_569200 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateIntent_569202(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateIntent_569201(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the name of an intent in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569203 = path.getOrDefault("versionId")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "versionId", valid_569203
  var valid_569204 = path.getOrDefault("appId")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "appId", valid_569204
  var valid_569205 = path.getOrDefault("intentId")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "intentId", valid_569205
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569207: Call_ModelUpdateIntent_569200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent in a version of the application.
  ## 
  let valid = call_569207.validator(path, query, header, formData, body)
  let scheme = call_569207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569207.url(scheme.get, call_569207.host, call_569207.base,
                         call_569207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569207, url, valid)

proc call*(call_569208: Call_ModelUpdateIntent_569200; versionId: string;
          modelUpdateObject: JsonNode; appId: string; intentId: string): Recallable =
  ## modelUpdateIntent
  ## Updates the name of an intent in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   modelUpdateObject: JObject (required)
  ##                    : A model object containing the new intent name.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_569209 = newJObject()
  var body_569210 = newJObject()
  add(path_569209, "versionId", newJString(versionId))
  if modelUpdateObject != nil:
    body_569210 = modelUpdateObject
  add(path_569209, "appId", newJString(appId))
  add(path_569209, "intentId", newJString(intentId))
  result = call_569208.call(path_569209, nil, nil, nil, body_569210)

var modelUpdateIntent* = Call_ModelUpdateIntent_569200(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_569201, base: "",
    url: url_ModelUpdateIntent_569202, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_569191 = ref object of OpenApiRestCall_567668
proc url_ModelGetIntent_569193(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetIntent_569192(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets information about the intent model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569194 = path.getOrDefault("versionId")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "versionId", valid_569194
  var valid_569195 = path.getOrDefault("appId")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "appId", valid_569195
  var valid_569196 = path.getOrDefault("intentId")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "intentId", valid_569196
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569197: Call_ModelGetIntent_569191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model in a version of the application.
  ## 
  let valid = call_569197.validator(path, query, header, formData, body)
  let scheme = call_569197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569197.url(scheme.get, call_569197.host, call_569197.base,
                         call_569197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569197, url, valid)

proc call*(call_569198: Call_ModelGetIntent_569191; versionId: string; appId: string;
          intentId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_569199 = newJObject()
  add(path_569199, "versionId", newJString(versionId))
  add(path_569199, "appId", newJString(appId))
  add(path_569199, "intentId", newJString(intentId))
  result = call_569198.call(path_569199, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_569191(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_569192, base: "", url: url_ModelGetIntent_569193,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_569211 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteIntent_569213(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteIntent_569212(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an intent from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569214 = path.getOrDefault("versionId")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = nil)
  if valid_569214 != nil:
    section.add "versionId", valid_569214
  var valid_569215 = path.getOrDefault("appId")
  valid_569215 = validateParameter(valid_569215, JString, required = true,
                                 default = nil)
  if valid_569215 != nil:
    section.add "appId", valid_569215
  var valid_569216 = path.getOrDefault("intentId")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "intentId", valid_569216
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : If true, deletes the intent's example utterances. If false, moves the example utterances to the None intent. The default value is false.
  section = newJObject()
  var valid_569217 = query.getOrDefault("deleteUtterances")
  valid_569217 = validateParameter(valid_569217, JBool, required = false,
                                 default = newJBool(false))
  if valid_569217 != nil:
    section.add "deleteUtterances", valid_569217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569218: Call_ModelDeleteIntent_569211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent from a version of the application.
  ## 
  let valid = call_569218.validator(path, query, header, formData, body)
  let scheme = call_569218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569218.url(scheme.get, call_569218.host, call_569218.base,
                         call_569218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569218, url, valid)

proc call*(call_569219: Call_ModelDeleteIntent_569211; versionId: string;
          appId: string; intentId: string; deleteUtterances: bool = false): Recallable =
  ## modelDeleteIntent
  ## Deletes an intent from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   deleteUtterances: bool
  ##                   : If true, deletes the intent's example utterances. If false, moves the example utterances to the None intent. The default value is false.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_569220 = newJObject()
  var query_569221 = newJObject()
  add(path_569220, "versionId", newJString(versionId))
  add(query_569221, "deleteUtterances", newJBool(deleteUtterances))
  add(path_569220, "appId", newJString(appId))
  add(path_569220, "intentId", newJString(intentId))
  result = call_569219.call(path_569220, query_569221, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_569211(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_569212, base: "",
    url: url_ModelDeleteIntent_569213, schemes: {Scheme.Https})
type
  Call_PatternListIntentPatterns_569222 = ref object of OpenApiRestCall_567668
proc url_PatternListIntentPatterns_569224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternListIntentPatterns_569223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569225 = path.getOrDefault("versionId")
  valid_569225 = validateParameter(valid_569225, JString, required = true,
                                 default = nil)
  if valid_569225 != nil:
    section.add "versionId", valid_569225
  var valid_569226 = path.getOrDefault("appId")
  valid_569226 = validateParameter(valid_569226, JString, required = true,
                                 default = nil)
  if valid_569226 != nil:
    section.add "appId", valid_569226
  var valid_569227 = path.getOrDefault("intentId")
  valid_569227 = validateParameter(valid_569227, JString, required = true,
                                 default = nil)
  if valid_569227 != nil:
    section.add "intentId", valid_569227
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569228 = query.getOrDefault("skip")
  valid_569228 = validateParameter(valid_569228, JInt, required = false,
                                 default = newJInt(0))
  if valid_569228 != nil:
    section.add "skip", valid_569228
  var valid_569229 = query.getOrDefault("take")
  valid_569229 = validateParameter(valid_569229, JInt, required = false,
                                 default = newJInt(100))
  if valid_569229 != nil:
    section.add "take", valid_569229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569230: Call_PatternListIntentPatterns_569222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569230.validator(path, query, header, formData, body)
  let scheme = call_569230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569230.url(scheme.get, call_569230.host, call_569230.base,
                         call_569230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569230, url, valid)

proc call*(call_569231: Call_PatternListIntentPatterns_569222; versionId: string;
          appId: string; intentId: string; skip: int = 0; take: int = 100): Recallable =
  ## patternListIntentPatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_569232 = newJObject()
  var query_569233 = newJObject()
  add(path_569232, "versionId", newJString(versionId))
  add(query_569233, "skip", newJInt(skip))
  add(query_569233, "take", newJInt(take))
  add(path_569232, "appId", newJString(appId))
  add(path_569232, "intentId", newJString(intentId))
  result = call_569231.call(path_569232, query_569233, nil, nil, nil)

var patternListIntentPatterns* = Call_PatternListIntentPatterns_569222(
    name: "patternListIntentPatterns", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/patternrules",
    validator: validate_PatternListIntentPatterns_569223, base: "",
    url: url_PatternListIntentPatterns_569224, schemes: {Scheme.Https})
type
  Call_ModelListIntentSuggestions_569234 = ref object of OpenApiRestCall_567668
proc url_ModelListIntentSuggestions_569236(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "intentId" in path, "`intentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/intents/"),
               (kind: VariableSegment, value: "intentId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListIntentSuggestions_569235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   intentId: JString (required)
  ##           : The intent classifier ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569237 = path.getOrDefault("versionId")
  valid_569237 = validateParameter(valid_569237, JString, required = true,
                                 default = nil)
  if valid_569237 != nil:
    section.add "versionId", valid_569237
  var valid_569238 = path.getOrDefault("appId")
  valid_569238 = validateParameter(valid_569238, JString, required = true,
                                 default = nil)
  if valid_569238 != nil:
    section.add "appId", valid_569238
  var valid_569239 = path.getOrDefault("intentId")
  valid_569239 = validateParameter(valid_569239, JString, required = true,
                                 default = nil)
  if valid_569239 != nil:
    section.add "intentId", valid_569239
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569240 = query.getOrDefault("take")
  valid_569240 = validateParameter(valid_569240, JInt, required = false,
                                 default = newJInt(100))
  if valid_569240 != nil:
    section.add "take", valid_569240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569241: Call_ModelListIntentSuggestions_569234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ## 
  let valid = call_569241.validator(path, query, header, formData, body)
  let scheme = call_569241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569241.url(scheme.get, call_569241.host, call_569241.base,
                         call_569241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569241, url, valid)

proc call*(call_569242: Call_ModelListIntentSuggestions_569234; versionId: string;
          appId: string; intentId: string; take: int = 100): Recallable =
  ## modelListIntentSuggestions
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_569243 = newJObject()
  var query_569244 = newJObject()
  add(path_569243, "versionId", newJString(versionId))
  add(query_569244, "take", newJInt(take))
  add(path_569243, "appId", newJString(appId))
  add(path_569243, "intentId", newJString(intentId))
  result = call_569242.call(path_569243, query_569244, nil, nil, nil)

var modelListIntentSuggestions* = Call_ModelListIntentSuggestions_569234(
    name: "modelListIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelListIntentSuggestions_569235, base: "",
    url: url_ModelListIntentSuggestions_569236, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_569245 = ref object of OpenApiRestCall_567668
proc url_ModelListPrebuiltEntities_569247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/listprebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuiltEntities_569246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the available prebuilt entities in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569248 = path.getOrDefault("versionId")
  valid_569248 = validateParameter(valid_569248, JString, required = true,
                                 default = nil)
  if valid_569248 != nil:
    section.add "versionId", valid_569248
  var valid_569249 = path.getOrDefault("appId")
  valid_569249 = validateParameter(valid_569249, JString, required = true,
                                 default = nil)
  if valid_569249 != nil:
    section.add "appId", valid_569249
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569250: Call_ModelListPrebuiltEntities_569245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entities in a version of the application.
  ## 
  let valid = call_569250.validator(path, query, header, formData, body)
  let scheme = call_569250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569250.url(scheme.get, call_569250.host, call_569250.base,
                         call_569250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569250, url, valid)

proc call*(call_569251: Call_ModelListPrebuiltEntities_569245; versionId: string;
          appId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entities in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569252 = newJObject()
  add(path_569252, "versionId", newJString(versionId))
  add(path_569252, "appId", newJString(appId))
  result = call_569251.call(path_569252, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_569245(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_569246, base: "",
    url: url_ModelListPrebuiltEntities_569247, schemes: {Scheme.Https})
type
  Call_ModelListModels_569253 = ref object of OpenApiRestCall_567668
proc url_ModelListModels_569255(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListModels_569254(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about all the intent and entity models in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569256 = path.getOrDefault("versionId")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "versionId", valid_569256
  var valid_569257 = path.getOrDefault("appId")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "appId", valid_569257
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569258 = query.getOrDefault("skip")
  valid_569258 = validateParameter(valid_569258, JInt, required = false,
                                 default = newJInt(0))
  if valid_569258 != nil:
    section.add "skip", valid_569258
  var valid_569259 = query.getOrDefault("take")
  valid_569259 = validateParameter(valid_569259, JInt, required = false,
                                 default = newJInt(100))
  if valid_569259 != nil:
    section.add "take", valid_569259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569260: Call_ModelListModels_569253; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the intent and entity models in a version of the application.
  ## 
  let valid = call_569260.validator(path, query, header, formData, body)
  let scheme = call_569260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569260.url(scheme.get, call_569260.host, call_569260.base,
                         call_569260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569260, url, valid)

proc call*(call_569261: Call_ModelListModels_569253; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListModels
  ## Gets information about all the intent and entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569262 = newJObject()
  var query_569263 = newJObject()
  add(path_569262, "versionId", newJString(versionId))
  add(query_569263, "skip", newJInt(skip))
  add(query_569263, "take", newJInt(take))
  add(path_569262, "appId", newJString(appId))
  result = call_569261.call(path_569262, query_569263, nil, nil, nil)

var modelListModels* = Call_ModelListModels_569253(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_569254, base: "", url: url_ModelListModels_569255,
    schemes: {Scheme.Https})
type
  Call_ModelExamples_569264 = ref object of OpenApiRestCall_567668
proc url_ModelExamples_569266(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "modelId" in path, "`modelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "modelId"),
               (kind: ConstantSegment, value: "/examples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelExamples_569265(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   modelId: JString (required)
  ##          : The ID (GUID) of the model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569267 = path.getOrDefault("versionId")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "versionId", valid_569267
  var valid_569268 = path.getOrDefault("appId")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "appId", valid_569268
  var valid_569269 = path.getOrDefault("modelId")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "modelId", valid_569269
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569270 = query.getOrDefault("skip")
  valid_569270 = validateParameter(valid_569270, JInt, required = false,
                                 default = newJInt(0))
  if valid_569270 != nil:
    section.add "skip", valid_569270
  var valid_569271 = query.getOrDefault("take")
  valid_569271 = validateParameter(valid_569271, JInt, required = false,
                                 default = newJInt(100))
  if valid_569271 != nil:
    section.add "take", valid_569271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569272: Call_ModelExamples_569264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ## 
  let valid = call_569272.validator(path, query, header, formData, body)
  let scheme = call_569272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569272.url(scheme.get, call_569272.host, call_569272.base,
                         call_569272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569272, url, valid)

proc call*(call_569273: Call_ModelExamples_569264; versionId: string; appId: string;
          modelId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelExamples
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelId: string (required)
  ##          : The ID (GUID) of the model.
  var path_569274 = newJObject()
  var query_569275 = newJObject()
  add(path_569274, "versionId", newJString(versionId))
  add(query_569275, "skip", newJInt(skip))
  add(query_569275, "take", newJInt(take))
  add(path_569274, "appId", newJString(appId))
  add(path_569274, "modelId", newJString(modelId))
  result = call_569273.call(path_569274, query_569275, nil, nil, nil)

var modelExamples* = Call_ModelExamples_569264(name: "modelExamples",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models/{modelId}/examples",
    validator: validate_ModelExamples_569265, base: "", url: url_ModelExamples_569266,
    schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityModel_569287 = ref object of OpenApiRestCall_567668
proc url_ModelCreatePatternAnyEntityModel_569289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePatternAnyEntityModel_569288(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569290 = path.getOrDefault("versionId")
  valid_569290 = validateParameter(valid_569290, JString, required = true,
                                 default = nil)
  if valid_569290 != nil:
    section.add "versionId", valid_569290
  var valid_569291 = path.getOrDefault("appId")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "appId", valid_569291
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extractorCreateObject: JObject (required)
  ##                        : A model object containing the name and explicit list for the new Pattern.Any entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569293: Call_ModelCreatePatternAnyEntityModel_569287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569293.validator(path, query, header, formData, body)
  let scheme = call_569293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569293.url(scheme.get, call_569293.host, call_569293.base,
                         call_569293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569293, url, valid)

proc call*(call_569294: Call_ModelCreatePatternAnyEntityModel_569287;
          versionId: string; extractorCreateObject: JsonNode; appId: string): Recallable =
  ## modelCreatePatternAnyEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   extractorCreateObject: JObject (required)
  ##                        : A model object containing the name and explicit list for the new Pattern.Any entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569295 = newJObject()
  var body_569296 = newJObject()
  add(path_569295, "versionId", newJString(versionId))
  if extractorCreateObject != nil:
    body_569296 = extractorCreateObject
  add(path_569295, "appId", newJString(appId))
  result = call_569294.call(path_569295, nil, nil, nil, body_569296)

var modelCreatePatternAnyEntityModel* = Call_ModelCreatePatternAnyEntityModel_569287(
    name: "modelCreatePatternAnyEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelCreatePatternAnyEntityModel_569288, base: "",
    url: url_ModelCreatePatternAnyEntityModel_569289, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityInfos_569276 = ref object of OpenApiRestCall_567668
proc url_ModelListPatternAnyEntityInfos_569278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPatternAnyEntityInfos_569277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569279 = path.getOrDefault("versionId")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "versionId", valid_569279
  var valid_569280 = path.getOrDefault("appId")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "appId", valid_569280
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569281 = query.getOrDefault("skip")
  valid_569281 = validateParameter(valid_569281, JInt, required = false,
                                 default = newJInt(0))
  if valid_569281 != nil:
    section.add "skip", valid_569281
  var valid_569282 = query.getOrDefault("take")
  valid_569282 = validateParameter(valid_569282, JInt, required = false,
                                 default = newJInt(100))
  if valid_569282 != nil:
    section.add "take", valid_569282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569283: Call_ModelListPatternAnyEntityInfos_569276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569283.validator(path, query, header, formData, body)
  let scheme = call_569283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569283.url(scheme.get, call_569283.host, call_569283.base,
                         call_569283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569283, url, valid)

proc call*(call_569284: Call_ModelListPatternAnyEntityInfos_569276;
          versionId: string; appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListPatternAnyEntityInfos
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569285 = newJObject()
  var query_569286 = newJObject()
  add(path_569285, "versionId", newJString(versionId))
  add(query_569286, "skip", newJInt(skip))
  add(query_569286, "take", newJInt(take))
  add(path_569285, "appId", newJString(appId))
  result = call_569284.call(path_569285, query_569286, nil, nil, nil)

var modelListPatternAnyEntityInfos* = Call_ModelListPatternAnyEntityInfos_569276(
    name: "modelListPatternAnyEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelListPatternAnyEntityInfos_569277, base: "",
    url: url_ModelListPatternAnyEntityInfos_569278, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityModel_569306 = ref object of OpenApiRestCall_567668
proc url_ModelUpdatePatternAnyEntityModel_569308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePatternAnyEntityModel_569307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569309 = path.getOrDefault("versionId")
  valid_569309 = validateParameter(valid_569309, JString, required = true,
                                 default = nil)
  if valid_569309 != nil:
    section.add "versionId", valid_569309
  var valid_569310 = path.getOrDefault("entityId")
  valid_569310 = validateParameter(valid_569310, JString, required = true,
                                 default = nil)
  if valid_569310 != nil:
    section.add "entityId", valid_569310
  var valid_569311 = path.getOrDefault("appId")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "appId", valid_569311
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternAnyUpdateObject: JObject (required)
  ##                         : An object containing the explicit list of the Pattern.Any entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569313: Call_ModelUpdatePatternAnyEntityModel_569306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569313.validator(path, query, header, formData, body)
  let scheme = call_569313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569313.url(scheme.get, call_569313.host, call_569313.base,
                         call_569313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569313, url, valid)

proc call*(call_569314: Call_ModelUpdatePatternAnyEntityModel_569306;
          versionId: string; entityId: string; appId: string;
          patternAnyUpdateObject: JsonNode): Recallable =
  ## modelUpdatePatternAnyEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   patternAnyUpdateObject: JObject (required)
  ##                         : An object containing the explicit list of the Pattern.Any entity.
  var path_569315 = newJObject()
  var body_569316 = newJObject()
  add(path_569315, "versionId", newJString(versionId))
  add(path_569315, "entityId", newJString(entityId))
  add(path_569315, "appId", newJString(appId))
  if patternAnyUpdateObject != nil:
    body_569316 = patternAnyUpdateObject
  result = call_569314.call(path_569315, nil, nil, nil, body_569316)

var modelUpdatePatternAnyEntityModel* = Call_ModelUpdatePatternAnyEntityModel_569306(
    name: "modelUpdatePatternAnyEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelUpdatePatternAnyEntityModel_569307, base: "",
    url: url_ModelUpdatePatternAnyEntityModel_569308, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityInfo_569297 = ref object of OpenApiRestCall_567668
proc url_ModelGetPatternAnyEntityInfo_569299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPatternAnyEntityInfo_569298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569300 = path.getOrDefault("versionId")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "versionId", valid_569300
  var valid_569301 = path.getOrDefault("entityId")
  valid_569301 = validateParameter(valid_569301, JString, required = true,
                                 default = nil)
  if valid_569301 != nil:
    section.add "entityId", valid_569301
  var valid_569302 = path.getOrDefault("appId")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "appId", valid_569302
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569303: Call_ModelGetPatternAnyEntityInfo_569297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569303.validator(path, query, header, formData, body)
  let scheme = call_569303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569303.url(scheme.get, call_569303.host, call_569303.base,
                         call_569303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569303, url, valid)

proc call*(call_569304: Call_ModelGetPatternAnyEntityInfo_569297;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelGetPatternAnyEntityInfo
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569305 = newJObject()
  add(path_569305, "versionId", newJString(versionId))
  add(path_569305, "entityId", newJString(entityId))
  add(path_569305, "appId", newJString(appId))
  result = call_569304.call(path_569305, nil, nil, nil, nil)

var modelGetPatternAnyEntityInfo* = Call_ModelGetPatternAnyEntityInfo_569297(
    name: "modelGetPatternAnyEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelGetPatternAnyEntityInfo_569298, base: "",
    url: url_ModelGetPatternAnyEntityInfo_569299, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityModel_569317 = ref object of OpenApiRestCall_567668
proc url_ModelDeletePatternAnyEntityModel_569319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePatternAnyEntityModel_569318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569320 = path.getOrDefault("versionId")
  valid_569320 = validateParameter(valid_569320, JString, required = true,
                                 default = nil)
  if valid_569320 != nil:
    section.add "versionId", valid_569320
  var valid_569321 = path.getOrDefault("entityId")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = nil)
  if valid_569321 != nil:
    section.add "entityId", valid_569321
  var valid_569322 = path.getOrDefault("appId")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "appId", valid_569322
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569323: Call_ModelDeletePatternAnyEntityModel_569317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569323.validator(path, query, header, formData, body)
  let scheme = call_569323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569323.url(scheme.get, call_569323.host, call_569323.base,
                         call_569323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569323, url, valid)

proc call*(call_569324: Call_ModelDeletePatternAnyEntityModel_569317;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelDeletePatternAnyEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569325 = newJObject()
  add(path_569325, "versionId", newJString(versionId))
  add(path_569325, "entityId", newJString(entityId))
  add(path_569325, "appId", newJString(appId))
  result = call_569324.call(path_569325, nil, nil, nil, nil)

var modelDeletePatternAnyEntityModel* = Call_ModelDeletePatternAnyEntityModel_569317(
    name: "modelDeletePatternAnyEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelDeletePatternAnyEntityModel_569318, base: "",
    url: url_ModelDeletePatternAnyEntityModel_569319, schemes: {Scheme.Https})
type
  Call_ModelAddExplicitListItem_569335 = ref object of OpenApiRestCall_567668
proc url_ModelAddExplicitListItem_569337(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddExplicitListItem_569336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569338 = path.getOrDefault("versionId")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "versionId", valid_569338
  var valid_569339 = path.getOrDefault("entityId")
  valid_569339 = validateParameter(valid_569339, JString, required = true,
                                 default = nil)
  if valid_569339 != nil:
    section.add "entityId", valid_569339
  var valid_569340 = path.getOrDefault("appId")
  valid_569340 = validateParameter(valid_569340, JString, required = true,
                                 default = nil)
  if valid_569340 != nil:
    section.add "appId", valid_569340
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   item: JObject (required)
  ##       : The new explicit list item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569342: Call_ModelAddExplicitListItem_569335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569342.validator(path, query, header, formData, body)
  let scheme = call_569342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569342.url(scheme.get, call_569342.host, call_569342.base,
                         call_569342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569342, url, valid)

proc call*(call_569343: Call_ModelAddExplicitListItem_569335; versionId: string;
          entityId: string; item: JsonNode; appId: string): Recallable =
  ## modelAddExplicitListItem
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   item: JObject (required)
  ##       : The new explicit list item.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569344 = newJObject()
  var body_569345 = newJObject()
  add(path_569344, "versionId", newJString(versionId))
  add(path_569344, "entityId", newJString(entityId))
  if item != nil:
    body_569345 = item
  add(path_569344, "appId", newJString(appId))
  result = call_569343.call(path_569344, nil, nil, nil, body_569345)

var modelAddExplicitListItem* = Call_ModelAddExplicitListItem_569335(
    name: "modelAddExplicitListItem", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelAddExplicitListItem_569336, base: "",
    url: url_ModelAddExplicitListItem_569337, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitList_569326 = ref object of OpenApiRestCall_567668
proc url_ModelGetExplicitList_569328(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetExplicitList_569327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity id.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569329 = path.getOrDefault("versionId")
  valid_569329 = validateParameter(valid_569329, JString, required = true,
                                 default = nil)
  if valid_569329 != nil:
    section.add "versionId", valid_569329
  var valid_569330 = path.getOrDefault("entityId")
  valid_569330 = validateParameter(valid_569330, JString, required = true,
                                 default = nil)
  if valid_569330 != nil:
    section.add "entityId", valid_569330
  var valid_569331 = path.getOrDefault("appId")
  valid_569331 = validateParameter(valid_569331, JString, required = true,
                                 default = nil)
  if valid_569331 != nil:
    section.add "appId", valid_569331
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569332: Call_ModelGetExplicitList_569326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569332.validator(path, query, header, formData, body)
  let scheme = call_569332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569332.url(scheme.get, call_569332.host, call_569332.base,
                         call_569332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569332, url, valid)

proc call*(call_569333: Call_ModelGetExplicitList_569326; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetExplicitList
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity id.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569334 = newJObject()
  add(path_569334, "versionId", newJString(versionId))
  add(path_569334, "entityId", newJString(entityId))
  add(path_569334, "appId", newJString(appId))
  result = call_569333.call(path_569334, nil, nil, nil, nil)

var modelGetExplicitList* = Call_ModelGetExplicitList_569326(
    name: "modelGetExplicitList", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelGetExplicitList_569327, base: "",
    url: url_ModelGetExplicitList_569328, schemes: {Scheme.Https})
type
  Call_ModelUpdateExplicitListItem_569356 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateExplicitListItem_569358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateExplicitListItem_569357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569359 = path.getOrDefault("versionId")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "versionId", valid_569359
  var valid_569360 = path.getOrDefault("entityId")
  valid_569360 = validateParameter(valid_569360, JString, required = true,
                                 default = nil)
  if valid_569360 != nil:
    section.add "entityId", valid_569360
  var valid_569361 = path.getOrDefault("appId")
  valid_569361 = validateParameter(valid_569361, JString, required = true,
                                 default = nil)
  if valid_569361 != nil:
    section.add "appId", valid_569361
  var valid_569362 = path.getOrDefault("itemId")
  valid_569362 = validateParameter(valid_569362, JInt, required = true, default = nil)
  if valid_569362 != nil:
    section.add "itemId", valid_569362
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   item: JObject (required)
  ##       : The new explicit list item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569364: Call_ModelUpdateExplicitListItem_569356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569364.validator(path, query, header, formData, body)
  let scheme = call_569364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569364.url(scheme.get, call_569364.host, call_569364.base,
                         call_569364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569364, url, valid)

proc call*(call_569365: Call_ModelUpdateExplicitListItem_569356; versionId: string;
          entityId: string; item: JsonNode; appId: string; itemId: int): Recallable =
  ## modelUpdateExplicitListItem
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   item: JObject (required)
  ##       : The new explicit list item.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item ID.
  var path_569366 = newJObject()
  var body_569367 = newJObject()
  add(path_569366, "versionId", newJString(versionId))
  add(path_569366, "entityId", newJString(entityId))
  if item != nil:
    body_569367 = item
  add(path_569366, "appId", newJString(appId))
  add(path_569366, "itemId", newJInt(itemId))
  result = call_569365.call(path_569366, nil, nil, nil, body_569367)

var modelUpdateExplicitListItem* = Call_ModelUpdateExplicitListItem_569356(
    name: "modelUpdateExplicitListItem", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelUpdateExplicitListItem_569357, base: "",
    url: url_ModelUpdateExplicitListItem_569358, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitListItem_569346 = ref object of OpenApiRestCall_567668
proc url_ModelGetExplicitListItem_569348(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetExplicitListItem_569347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The Pattern.Any entity Id.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569349 = path.getOrDefault("versionId")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "versionId", valid_569349
  var valid_569350 = path.getOrDefault("entityId")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "entityId", valid_569350
  var valid_569351 = path.getOrDefault("appId")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "appId", valid_569351
  var valid_569352 = path.getOrDefault("itemId")
  valid_569352 = validateParameter(valid_569352, JInt, required = true, default = nil)
  if valid_569352 != nil:
    section.add "itemId", valid_569352
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569353: Call_ModelGetExplicitListItem_569346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569353.validator(path, query, header, formData, body)
  let scheme = call_569353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569353.url(scheme.get, call_569353.host, call_569353.base,
                         call_569353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569353, url, valid)

proc call*(call_569354: Call_ModelGetExplicitListItem_569346; versionId: string;
          entityId: string; appId: string; itemId: int): Recallable =
  ## modelGetExplicitListItem
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity Id.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item Id.
  var path_569355 = newJObject()
  add(path_569355, "versionId", newJString(versionId))
  add(path_569355, "entityId", newJString(entityId))
  add(path_569355, "appId", newJString(appId))
  add(path_569355, "itemId", newJInt(itemId))
  result = call_569354.call(path_569355, nil, nil, nil, nil)

var modelGetExplicitListItem* = Call_ModelGetExplicitListItem_569346(
    name: "modelGetExplicitListItem", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelGetExplicitListItem_569347, base: "",
    url: url_ModelGetExplicitListItem_569348, schemes: {Scheme.Https})
type
  Call_ModelDeleteExplicitListItem_569368 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteExplicitListItem_569370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/explicitlist/"),
               (kind: VariableSegment, value: "itemId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteExplicitListItem_569369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The pattern.any entity id.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   itemId: JInt (required)
  ##         : The explicit list item which will be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569371 = path.getOrDefault("versionId")
  valid_569371 = validateParameter(valid_569371, JString, required = true,
                                 default = nil)
  if valid_569371 != nil:
    section.add "versionId", valid_569371
  var valid_569372 = path.getOrDefault("entityId")
  valid_569372 = validateParameter(valid_569372, JString, required = true,
                                 default = nil)
  if valid_569372 != nil:
    section.add "entityId", valid_569372
  var valid_569373 = path.getOrDefault("appId")
  valid_569373 = validateParameter(valid_569373, JString, required = true,
                                 default = nil)
  if valid_569373 != nil:
    section.add "appId", valid_569373
  var valid_569374 = path.getOrDefault("itemId")
  valid_569374 = validateParameter(valid_569374, JInt, required = true, default = nil)
  if valid_569374 != nil:
    section.add "itemId", valid_569374
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569375: Call_ModelDeleteExplicitListItem_569368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569375.validator(path, query, header, formData, body)
  let scheme = call_569375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569375.url(scheme.get, call_569375.host, call_569375.base,
                         call_569375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569375, url, valid)

proc call*(call_569376: Call_ModelDeleteExplicitListItem_569368; versionId: string;
          entityId: string; appId: string; itemId: int): Recallable =
  ## modelDeleteExplicitListItem
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The pattern.any entity id.
  ##   appId: string (required)
  ##        : The application ID.
  ##   itemId: int (required)
  ##         : The explicit list item which will be deleted.
  var path_569377 = newJObject()
  add(path_569377, "versionId", newJString(versionId))
  add(path_569377, "entityId", newJString(entityId))
  add(path_569377, "appId", newJString(appId))
  add(path_569377, "itemId", newJInt(itemId))
  result = call_569376.call(path_569377, nil, nil, nil, nil)

var modelDeleteExplicitListItem* = Call_ModelDeleteExplicitListItem_569368(
    name: "modelDeleteExplicitListItem", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelDeleteExplicitListItem_569369, base: "",
    url: url_ModelDeleteExplicitListItem_569370, schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityRole_569387 = ref object of OpenApiRestCall_567668
proc url_ModelCreatePatternAnyEntityRole_569389(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePatternAnyEntityRole_569388(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569390 = path.getOrDefault("versionId")
  valid_569390 = validateParameter(valid_569390, JString, required = true,
                                 default = nil)
  if valid_569390 != nil:
    section.add "versionId", valid_569390
  var valid_569391 = path.getOrDefault("entityId")
  valid_569391 = validateParameter(valid_569391, JString, required = true,
                                 default = nil)
  if valid_569391 != nil:
    section.add "entityId", valid_569391
  var valid_569392 = path.getOrDefault("appId")
  valid_569392 = validateParameter(valid_569392, JString, required = true,
                                 default = nil)
  if valid_569392 != nil:
    section.add "appId", valid_569392
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569394: Call_ModelCreatePatternAnyEntityRole_569387;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569394.validator(path, query, header, formData, body)
  let scheme = call_569394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569394.url(scheme.get, call_569394.host, call_569394.base,
                         call_569394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569394, url, valid)

proc call*(call_569395: Call_ModelCreatePatternAnyEntityRole_569387;
          versionId: string; entityId: string; entityRoleCreateObject: JsonNode;
          appId: string): Recallable =
  ## modelCreatePatternAnyEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569396 = newJObject()
  var body_569397 = newJObject()
  add(path_569396, "versionId", newJString(versionId))
  add(path_569396, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_569397 = entityRoleCreateObject
  add(path_569396, "appId", newJString(appId))
  result = call_569395.call(path_569396, nil, nil, nil, body_569397)

var modelCreatePatternAnyEntityRole* = Call_ModelCreatePatternAnyEntityRole_569387(
    name: "modelCreatePatternAnyEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelCreatePatternAnyEntityRole_569388, base: "",
    url: url_ModelCreatePatternAnyEntityRole_569389, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityRoles_569378 = ref object of OpenApiRestCall_567668
proc url_ModelListPatternAnyEntityRoles_569380(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPatternAnyEntityRoles_569379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569381 = path.getOrDefault("versionId")
  valid_569381 = validateParameter(valid_569381, JString, required = true,
                                 default = nil)
  if valid_569381 != nil:
    section.add "versionId", valid_569381
  var valid_569382 = path.getOrDefault("entityId")
  valid_569382 = validateParameter(valid_569382, JString, required = true,
                                 default = nil)
  if valid_569382 != nil:
    section.add "entityId", valid_569382
  var valid_569383 = path.getOrDefault("appId")
  valid_569383 = validateParameter(valid_569383, JString, required = true,
                                 default = nil)
  if valid_569383 != nil:
    section.add "appId", valid_569383
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569384: Call_ModelListPatternAnyEntityRoles_569378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569384.validator(path, query, header, formData, body)
  let scheme = call_569384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569384.url(scheme.get, call_569384.host, call_569384.base,
                         call_569384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569384, url, valid)

proc call*(call_569385: Call_ModelListPatternAnyEntityRoles_569378;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListPatternAnyEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_569386 = newJObject()
  add(path_569386, "versionId", newJString(versionId))
  add(path_569386, "entityId", newJString(entityId))
  add(path_569386, "appId", newJString(appId))
  result = call_569385.call(path_569386, nil, nil, nil, nil)

var modelListPatternAnyEntityRoles* = Call_ModelListPatternAnyEntityRoles_569378(
    name: "modelListPatternAnyEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelListPatternAnyEntityRoles_569379, base: "",
    url: url_ModelListPatternAnyEntityRoles_569380, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityRole_569408 = ref object of OpenApiRestCall_567668
proc url_ModelUpdatePatternAnyEntityRole_569410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePatternAnyEntityRole_569409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569411 = path.getOrDefault("versionId")
  valid_569411 = validateParameter(valid_569411, JString, required = true,
                                 default = nil)
  if valid_569411 != nil:
    section.add "versionId", valid_569411
  var valid_569412 = path.getOrDefault("entityId")
  valid_569412 = validateParameter(valid_569412, JString, required = true,
                                 default = nil)
  if valid_569412 != nil:
    section.add "entityId", valid_569412
  var valid_569413 = path.getOrDefault("appId")
  valid_569413 = validateParameter(valid_569413, JString, required = true,
                                 default = nil)
  if valid_569413 != nil:
    section.add "appId", valid_569413
  var valid_569414 = path.getOrDefault("roleId")
  valid_569414 = validateParameter(valid_569414, JString, required = true,
                                 default = nil)
  if valid_569414 != nil:
    section.add "roleId", valid_569414
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569416: Call_ModelUpdatePatternAnyEntityRole_569408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569416.validator(path, query, header, formData, body)
  let scheme = call_569416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569416.url(scheme.get, call_569416.host, call_569416.base,
                         call_569416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569416, url, valid)

proc call*(call_569417: Call_ModelUpdatePatternAnyEntityRole_569408;
          versionId: string; entityRoleUpdateObject: JsonNode; entityId: string;
          appId: string; roleId: string): Recallable =
  ## modelUpdatePatternAnyEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_569418 = newJObject()
  var body_569419 = newJObject()
  add(path_569418, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_569419 = entityRoleUpdateObject
  add(path_569418, "entityId", newJString(entityId))
  add(path_569418, "appId", newJString(appId))
  add(path_569418, "roleId", newJString(roleId))
  result = call_569417.call(path_569418, nil, nil, nil, body_569419)

var modelUpdatePatternAnyEntityRole* = Call_ModelUpdatePatternAnyEntityRole_569408(
    name: "modelUpdatePatternAnyEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePatternAnyEntityRole_569409, base: "",
    url: url_ModelUpdatePatternAnyEntityRole_569410, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityRole_569398 = ref object of OpenApiRestCall_567668
proc url_ModelGetPatternAnyEntityRole_569400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPatternAnyEntityRole_569399(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569401 = path.getOrDefault("versionId")
  valid_569401 = validateParameter(valid_569401, JString, required = true,
                                 default = nil)
  if valid_569401 != nil:
    section.add "versionId", valid_569401
  var valid_569402 = path.getOrDefault("entityId")
  valid_569402 = validateParameter(valid_569402, JString, required = true,
                                 default = nil)
  if valid_569402 != nil:
    section.add "entityId", valid_569402
  var valid_569403 = path.getOrDefault("appId")
  valid_569403 = validateParameter(valid_569403, JString, required = true,
                                 default = nil)
  if valid_569403 != nil:
    section.add "appId", valid_569403
  var valid_569404 = path.getOrDefault("roleId")
  valid_569404 = validateParameter(valid_569404, JString, required = true,
                                 default = nil)
  if valid_569404 != nil:
    section.add "roleId", valid_569404
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569405: Call_ModelGetPatternAnyEntityRole_569398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569405.validator(path, query, header, formData, body)
  let scheme = call_569405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569405.url(scheme.get, call_569405.host, call_569405.base,
                         call_569405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569405, url, valid)

proc call*(call_569406: Call_ModelGetPatternAnyEntityRole_569398;
          versionId: string; entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetPatternAnyEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_569407 = newJObject()
  add(path_569407, "versionId", newJString(versionId))
  add(path_569407, "entityId", newJString(entityId))
  add(path_569407, "appId", newJString(appId))
  add(path_569407, "roleId", newJString(roleId))
  result = call_569406.call(path_569407, nil, nil, nil, nil)

var modelGetPatternAnyEntityRole* = Call_ModelGetPatternAnyEntityRole_569398(
    name: "modelGetPatternAnyEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPatternAnyEntityRole_569399, base: "",
    url: url_ModelGetPatternAnyEntityRole_569400, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityRole_569420 = ref object of OpenApiRestCall_567668
proc url_ModelDeletePatternAnyEntityRole_569422(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternanyentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePatternAnyEntityRole_569421(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569423 = path.getOrDefault("versionId")
  valid_569423 = validateParameter(valid_569423, JString, required = true,
                                 default = nil)
  if valid_569423 != nil:
    section.add "versionId", valid_569423
  var valid_569424 = path.getOrDefault("entityId")
  valid_569424 = validateParameter(valid_569424, JString, required = true,
                                 default = nil)
  if valid_569424 != nil:
    section.add "entityId", valid_569424
  var valid_569425 = path.getOrDefault("appId")
  valid_569425 = validateParameter(valid_569425, JString, required = true,
                                 default = nil)
  if valid_569425 != nil:
    section.add "appId", valid_569425
  var valid_569426 = path.getOrDefault("roleId")
  valid_569426 = validateParameter(valid_569426, JString, required = true,
                                 default = nil)
  if valid_569426 != nil:
    section.add "roleId", valid_569426
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569427: Call_ModelDeletePatternAnyEntityRole_569420;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_569427.validator(path, query, header, formData, body)
  let scheme = call_569427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569427.url(scheme.get, call_569427.host, call_569427.base,
                         call_569427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569427, url, valid)

proc call*(call_569428: Call_ModelDeletePatternAnyEntityRole_569420;
          versionId: string; entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeletePatternAnyEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_569429 = newJObject()
  add(path_569429, "versionId", newJString(versionId))
  add(path_569429, "entityId", newJString(entityId))
  add(path_569429, "appId", newJString(appId))
  add(path_569429, "roleId", newJString(roleId))
  result = call_569428.call(path_569429, nil, nil, nil, nil)

var modelDeletePatternAnyEntityRole* = Call_ModelDeletePatternAnyEntityRole_569420(
    name: "modelDeletePatternAnyEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePatternAnyEntityRole_569421, base: "",
    url: url_ModelDeletePatternAnyEntityRole_569422, schemes: {Scheme.Https})
type
  Call_PatternAddPattern_569430 = ref object of OpenApiRestCall_567668
proc url_PatternAddPattern_569432(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrule")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternAddPattern_569431(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569433 = path.getOrDefault("versionId")
  valid_569433 = validateParameter(valid_569433, JString, required = true,
                                 default = nil)
  if valid_569433 != nil:
    section.add "versionId", valid_569433
  var valid_569434 = path.getOrDefault("appId")
  valid_569434 = validateParameter(valid_569434, JString, required = true,
                                 default = nil)
  if valid_569434 != nil:
    section.add "appId", valid_569434
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pattern: JObject (required)
  ##          : The input pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569436: Call_PatternAddPattern_569430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569436.validator(path, query, header, formData, body)
  let scheme = call_569436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569436.url(scheme.get, call_569436.host, call_569436.base,
                         call_569436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569436, url, valid)

proc call*(call_569437: Call_PatternAddPattern_569430; versionId: string;
          pattern: JsonNode; appId: string): Recallable =
  ## patternAddPattern
  ##   versionId: string (required)
  ##            : The version ID.
  ##   pattern: JObject (required)
  ##          : The input pattern.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569438 = newJObject()
  var body_569439 = newJObject()
  add(path_569438, "versionId", newJString(versionId))
  if pattern != nil:
    body_569439 = pattern
  add(path_569438, "appId", newJString(appId))
  result = call_569437.call(path_569438, nil, nil, nil, body_569439)

var patternAddPattern* = Call_PatternAddPattern_569430(name: "patternAddPattern",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrule",
    validator: validate_PatternAddPattern_569431, base: "",
    url: url_PatternAddPattern_569432, schemes: {Scheme.Https})
type
  Call_PatternUpdatePatterns_569451 = ref object of OpenApiRestCall_567668
proc url_PatternUpdatePatterns_569453(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternUpdatePatterns_569452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569454 = path.getOrDefault("versionId")
  valid_569454 = validateParameter(valid_569454, JString, required = true,
                                 default = nil)
  if valid_569454 != nil:
    section.add "versionId", valid_569454
  var valid_569455 = path.getOrDefault("appId")
  valid_569455 = validateParameter(valid_569455, JString, required = true,
                                 default = nil)
  if valid_569455 != nil:
    section.add "appId", valid_569455
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patterns: JArray (required)
  ##           : An array represents the patterns.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569457: Call_PatternUpdatePatterns_569451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569457.validator(path, query, header, formData, body)
  let scheme = call_569457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569457.url(scheme.get, call_569457.host, call_569457.base,
                         call_569457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569457, url, valid)

proc call*(call_569458: Call_PatternUpdatePatterns_569451; versionId: string;
          patterns: JsonNode; appId: string): Recallable =
  ## patternUpdatePatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patterns: JArray (required)
  ##           : An array represents the patterns.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569459 = newJObject()
  var body_569460 = newJObject()
  add(path_569459, "versionId", newJString(versionId))
  if patterns != nil:
    body_569460 = patterns
  add(path_569459, "appId", newJString(appId))
  result = call_569458.call(path_569459, nil, nil, nil, body_569460)

var patternUpdatePatterns* = Call_PatternUpdatePatterns_569451(
    name: "patternUpdatePatterns", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternUpdatePatterns_569452, base: "",
    url: url_PatternUpdatePatterns_569453, schemes: {Scheme.Https})
type
  Call_PatternBatchAddPatterns_569461 = ref object of OpenApiRestCall_567668
proc url_PatternBatchAddPatterns_569463(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternBatchAddPatterns_569462(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569464 = path.getOrDefault("versionId")
  valid_569464 = validateParameter(valid_569464, JString, required = true,
                                 default = nil)
  if valid_569464 != nil:
    section.add "versionId", valid_569464
  var valid_569465 = path.getOrDefault("appId")
  valid_569465 = validateParameter(valid_569465, JString, required = true,
                                 default = nil)
  if valid_569465 != nil:
    section.add "appId", valid_569465
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patterns: JArray (required)
  ##           : A JSON array containing patterns.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569467: Call_PatternBatchAddPatterns_569461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569467.validator(path, query, header, formData, body)
  let scheme = call_569467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569467.url(scheme.get, call_569467.host, call_569467.base,
                         call_569467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569467, url, valid)

proc call*(call_569468: Call_PatternBatchAddPatterns_569461; versionId: string;
          patterns: JsonNode; appId: string): Recallable =
  ## patternBatchAddPatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patterns: JArray (required)
  ##           : A JSON array containing patterns.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569469 = newJObject()
  var body_569470 = newJObject()
  add(path_569469, "versionId", newJString(versionId))
  if patterns != nil:
    body_569470 = patterns
  add(path_569469, "appId", newJString(appId))
  result = call_569468.call(path_569469, nil, nil, nil, body_569470)

var patternBatchAddPatterns* = Call_PatternBatchAddPatterns_569461(
    name: "patternBatchAddPatterns", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternBatchAddPatterns_569462, base: "",
    url: url_PatternBatchAddPatterns_569463, schemes: {Scheme.Https})
type
  Call_PatternListPatterns_569440 = ref object of OpenApiRestCall_567668
proc url_PatternListPatterns_569442(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternListPatterns_569441(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569443 = path.getOrDefault("versionId")
  valid_569443 = validateParameter(valid_569443, JString, required = true,
                                 default = nil)
  if valid_569443 != nil:
    section.add "versionId", valid_569443
  var valid_569444 = path.getOrDefault("appId")
  valid_569444 = validateParameter(valid_569444, JString, required = true,
                                 default = nil)
  if valid_569444 != nil:
    section.add "appId", valid_569444
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569445 = query.getOrDefault("skip")
  valid_569445 = validateParameter(valid_569445, JInt, required = false,
                                 default = newJInt(0))
  if valid_569445 != nil:
    section.add "skip", valid_569445
  var valid_569446 = query.getOrDefault("take")
  valid_569446 = validateParameter(valid_569446, JInt, required = false,
                                 default = newJInt(100))
  if valid_569446 != nil:
    section.add "take", valid_569446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569447: Call_PatternListPatterns_569440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569447.validator(path, query, header, formData, body)
  let scheme = call_569447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569447.url(scheme.get, call_569447.host, call_569447.base,
                         call_569447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569447, url, valid)

proc call*(call_569448: Call_PatternListPatterns_569440; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## patternListPatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569449 = newJObject()
  var query_569450 = newJObject()
  add(path_569449, "versionId", newJString(versionId))
  add(query_569450, "skip", newJInt(skip))
  add(query_569450, "take", newJInt(take))
  add(path_569449, "appId", newJString(appId))
  result = call_569448.call(path_569449, query_569450, nil, nil, nil)

var patternListPatterns* = Call_PatternListPatterns_569440(
    name: "patternListPatterns", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternListPatterns_569441, base: "",
    url: url_PatternListPatterns_569442, schemes: {Scheme.Https})
type
  Call_PatternDeletePatterns_569471 = ref object of OpenApiRestCall_567668
proc url_PatternDeletePatterns_569473(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternDeletePatterns_569472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569474 = path.getOrDefault("versionId")
  valid_569474 = validateParameter(valid_569474, JString, required = true,
                                 default = nil)
  if valid_569474 != nil:
    section.add "versionId", valid_569474
  var valid_569475 = path.getOrDefault("appId")
  valid_569475 = validateParameter(valid_569475, JString, required = true,
                                 default = nil)
  if valid_569475 != nil:
    section.add "appId", valid_569475
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternIds: JArray (required)
  ##             : The patterns IDs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569477: Call_PatternDeletePatterns_569471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569477.validator(path, query, header, formData, body)
  let scheme = call_569477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569477.url(scheme.get, call_569477.host, call_569477.base,
                         call_569477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569477, url, valid)

proc call*(call_569478: Call_PatternDeletePatterns_569471; versionId: string;
          patternIds: JsonNode; appId: string): Recallable =
  ## patternDeletePatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternIds: JArray (required)
  ##             : The patterns IDs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569479 = newJObject()
  var body_569480 = newJObject()
  add(path_569479, "versionId", newJString(versionId))
  if patternIds != nil:
    body_569480 = patternIds
  add(path_569479, "appId", newJString(appId))
  result = call_569478.call(path_569479, nil, nil, nil, body_569480)

var patternDeletePatterns* = Call_PatternDeletePatterns_569471(
    name: "patternDeletePatterns", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternDeletePatterns_569472, base: "",
    url: url_PatternDeletePatterns_569473, schemes: {Scheme.Https})
type
  Call_PatternUpdatePattern_569481 = ref object of OpenApiRestCall_567668
proc url_PatternUpdatePattern_569483(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternUpdatePattern_569482(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JString (required)
  ##            : The pattern ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569484 = path.getOrDefault("versionId")
  valid_569484 = validateParameter(valid_569484, JString, required = true,
                                 default = nil)
  if valid_569484 != nil:
    section.add "versionId", valid_569484
  var valid_569485 = path.getOrDefault("patternId")
  valid_569485 = validateParameter(valid_569485, JString, required = true,
                                 default = nil)
  if valid_569485 != nil:
    section.add "patternId", valid_569485
  var valid_569486 = path.getOrDefault("appId")
  valid_569486 = validateParameter(valid_569486, JString, required = true,
                                 default = nil)
  if valid_569486 != nil:
    section.add "appId", valid_569486
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pattern: JObject (required)
  ##          : An object representing a pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569488: Call_PatternUpdatePattern_569481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569488.validator(path, query, header, formData, body)
  let scheme = call_569488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569488.url(scheme.get, call_569488.host, call_569488.base,
                         call_569488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569488, url, valid)

proc call*(call_569489: Call_PatternUpdatePattern_569481; versionId: string;
          patternId: string; pattern: JsonNode; appId: string): Recallable =
  ## patternUpdatePattern
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: string (required)
  ##            : The pattern ID.
  ##   pattern: JObject (required)
  ##          : An object representing a pattern.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569490 = newJObject()
  var body_569491 = newJObject()
  add(path_569490, "versionId", newJString(versionId))
  add(path_569490, "patternId", newJString(patternId))
  if pattern != nil:
    body_569491 = pattern
  add(path_569490, "appId", newJString(appId))
  result = call_569489.call(path_569490, nil, nil, nil, body_569491)

var patternUpdatePattern* = Call_PatternUpdatePattern_569481(
    name: "patternUpdatePattern", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternUpdatePattern_569482, base: "",
    url: url_PatternUpdatePattern_569483, schemes: {Scheme.Https})
type
  Call_PatternDeletePattern_569492 = ref object of OpenApiRestCall_567668
proc url_PatternDeletePattern_569494(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patternrules/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PatternDeletePattern_569493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JString (required)
  ##            : The pattern ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569495 = path.getOrDefault("versionId")
  valid_569495 = validateParameter(valid_569495, JString, required = true,
                                 default = nil)
  if valid_569495 != nil:
    section.add "versionId", valid_569495
  var valid_569496 = path.getOrDefault("patternId")
  valid_569496 = validateParameter(valid_569496, JString, required = true,
                                 default = nil)
  if valid_569496 != nil:
    section.add "patternId", valid_569496
  var valid_569497 = path.getOrDefault("appId")
  valid_569497 = validateParameter(valid_569497, JString, required = true,
                                 default = nil)
  if valid_569497 != nil:
    section.add "appId", valid_569497
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569498: Call_PatternDeletePattern_569492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569498.validator(path, query, header, formData, body)
  let scheme = call_569498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569498.url(scheme.get, call_569498.host, call_569498.base,
                         call_569498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569498, url, valid)

proc call*(call_569499: Call_PatternDeletePattern_569492; versionId: string;
          patternId: string; appId: string): Recallable =
  ## patternDeletePattern
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: string (required)
  ##            : The pattern ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569500 = newJObject()
  add(path_569500, "versionId", newJString(versionId))
  add(path_569500, "patternId", newJString(patternId))
  add(path_569500, "appId", newJString(appId))
  result = call_569499.call(path_569500, nil, nil, nil, nil)

var patternDeletePattern* = Call_PatternDeletePattern_569492(
    name: "patternDeletePattern", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternDeletePattern_569493, base: "",
    url: url_PatternDeletePattern_569494, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_569512 = ref object of OpenApiRestCall_567668
proc url_FeaturesCreatePatternFeature_569514(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesCreatePatternFeature_569513(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569515 = path.getOrDefault("versionId")
  valid_569515 = validateParameter(valid_569515, JString, required = true,
                                 default = nil)
  if valid_569515 != nil:
    section.add "versionId", valid_569515
  var valid_569516 = path.getOrDefault("appId")
  valid_569516 = validateParameter(valid_569516, JString, required = true,
                                 default = nil)
  if valid_569516 != nil:
    section.add "appId", valid_569516
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569518: Call_FeaturesCreatePatternFeature_569512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ## 
  let valid = call_569518.validator(path, query, header, formData, body)
  let scheme = call_569518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569518.url(scheme.get, call_569518.host, call_569518.base,
                         call_569518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569518, url, valid)

proc call*(call_569519: Call_FeaturesCreatePatternFeature_569512;
          patternCreateObject: JsonNode; versionId: string; appId: string): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569520 = newJObject()
  var body_569521 = newJObject()
  if patternCreateObject != nil:
    body_569521 = patternCreateObject
  add(path_569520, "versionId", newJString(versionId))
  add(path_569520, "appId", newJString(appId))
  result = call_569519.call(path_569520, nil, nil, nil, body_569521)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_569512(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_569513, base: "",
    url: url_FeaturesCreatePatternFeature_569514, schemes: {Scheme.Https})
type
  Call_FeaturesListApplicationVersionPatternFeatures_569501 = ref object of OpenApiRestCall_567668
proc url_FeaturesListApplicationVersionPatternFeatures_569503(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesListApplicationVersionPatternFeatures_569502(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569504 = path.getOrDefault("versionId")
  valid_569504 = validateParameter(valid_569504, JString, required = true,
                                 default = nil)
  if valid_569504 != nil:
    section.add "versionId", valid_569504
  var valid_569505 = path.getOrDefault("appId")
  valid_569505 = validateParameter(valid_569505, JString, required = true,
                                 default = nil)
  if valid_569505 != nil:
    section.add "appId", valid_569505
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569506 = query.getOrDefault("skip")
  valid_569506 = validateParameter(valid_569506, JInt, required = false,
                                 default = newJInt(0))
  if valid_569506 != nil:
    section.add "skip", valid_569506
  var valid_569507 = query.getOrDefault("take")
  valid_569507 = validateParameter(valid_569507, JInt, required = false,
                                 default = newJInt(100))
  if valid_569507 != nil:
    section.add "take", valid_569507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569508: Call_FeaturesListApplicationVersionPatternFeatures_569501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_569508.validator(path, query, header, formData, body)
  let scheme = call_569508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569508.url(scheme.get, call_569508.host, call_569508.base,
                         call_569508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569508, url, valid)

proc call*(call_569509: Call_FeaturesListApplicationVersionPatternFeatures_569501;
          versionId: string; appId: string; skip: int = 0; take: int = 100): Recallable =
  ## featuresListApplicationVersionPatternFeatures
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569510 = newJObject()
  var query_569511 = newJObject()
  add(path_569510, "versionId", newJString(versionId))
  add(query_569511, "skip", newJInt(skip))
  add(query_569511, "take", newJInt(take))
  add(path_569510, "appId", newJString(appId))
  result = call_569509.call(path_569510, query_569511, nil, nil, nil)

var featuresListApplicationVersionPatternFeatures* = Call_FeaturesListApplicationVersionPatternFeatures_569501(
    name: "featuresListApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesListApplicationVersionPatternFeatures_569502,
    base: "", url: url_FeaturesListApplicationVersionPatternFeatures_569503,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_569531 = ref object of OpenApiRestCall_567668
proc url_FeaturesUpdatePatternFeature_569533(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesUpdatePatternFeature_569532(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569534 = path.getOrDefault("versionId")
  valid_569534 = validateParameter(valid_569534, JString, required = true,
                                 default = nil)
  if valid_569534 != nil:
    section.add "versionId", valid_569534
  var valid_569535 = path.getOrDefault("patternId")
  valid_569535 = validateParameter(valid_569535, JInt, required = true, default = nil)
  if valid_569535 != nil:
    section.add "patternId", valid_569535
  var valid_569536 = path.getOrDefault("appId")
  valid_569536 = validateParameter(valid_569536, JString, required = true,
                                 default = nil)
  if valid_569536 != nil:
    section.add "appId", valid_569536
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569538: Call_FeaturesUpdatePatternFeature_569531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ## 
  let valid = call_569538.validator(path, query, header, formData, body)
  let scheme = call_569538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569538.url(scheme.get, call_569538.host, call_569538.base,
                         call_569538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569538, url, valid)

proc call*(call_569539: Call_FeaturesUpdatePatternFeature_569531;
          versionId: string; patternId: int; appId: string;
          patternUpdateObject: JsonNode): Recallable =
  ## featuresUpdatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   patternUpdateObject: JObject (required)
  ##                      : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern and a boolean called IsActive to update the feature.
  var path_569540 = newJObject()
  var body_569541 = newJObject()
  add(path_569540, "versionId", newJString(versionId))
  add(path_569540, "patternId", newJInt(patternId))
  add(path_569540, "appId", newJString(appId))
  if patternUpdateObject != nil:
    body_569541 = patternUpdateObject
  result = call_569539.call(path_569540, nil, nil, nil, body_569541)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_569531(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_569532, base: "",
    url: url_FeaturesUpdatePatternFeature_569533, schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_569522 = ref object of OpenApiRestCall_567668
proc url_FeaturesGetPatternFeatureInfo_569524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesGetPatternFeatureInfo_569523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569525 = path.getOrDefault("versionId")
  valid_569525 = validateParameter(valid_569525, JString, required = true,
                                 default = nil)
  if valid_569525 != nil:
    section.add "versionId", valid_569525
  var valid_569526 = path.getOrDefault("patternId")
  valid_569526 = validateParameter(valid_569526, JInt, required = true, default = nil)
  if valid_569526 != nil:
    section.add "patternId", valid_569526
  var valid_569527 = path.getOrDefault("appId")
  valid_569527 = validateParameter(valid_569527, JString, required = true,
                                 default = nil)
  if valid_569527 != nil:
    section.add "appId", valid_569527
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569528: Call_FeaturesGetPatternFeatureInfo_569522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ## 
  let valid = call_569528.validator(path, query, header, formData, body)
  let scheme = call_569528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569528.url(scheme.get, call_569528.host, call_569528.base,
                         call_569528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569528, url, valid)

proc call*(call_569529: Call_FeaturesGetPatternFeatureInfo_569522;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569530 = newJObject()
  add(path_569530, "versionId", newJString(versionId))
  add(path_569530, "patternId", newJInt(patternId))
  add(path_569530, "appId", newJString(appId))
  result = call_569529.call(path_569530, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_569522(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_569523, base: "",
    url: url_FeaturesGetPatternFeatureInfo_569524, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_569542 = ref object of OpenApiRestCall_567668
proc url_FeaturesDeletePatternFeature_569544(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "patternId" in path, "`patternId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/patterns/"),
               (kind: VariableSegment, value: "patternId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesDeletePatternFeature_569543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   patternId: JInt (required)
  ##            : The pattern feature ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569545 = path.getOrDefault("versionId")
  valid_569545 = validateParameter(valid_569545, JString, required = true,
                                 default = nil)
  if valid_569545 != nil:
    section.add "versionId", valid_569545
  var valid_569546 = path.getOrDefault("patternId")
  valid_569546 = validateParameter(valid_569546, JInt, required = true, default = nil)
  if valid_569546 != nil:
    section.add "patternId", valid_569546
  var valid_569547 = path.getOrDefault("appId")
  valid_569547 = validateParameter(valid_569547, JString, required = true,
                                 default = nil)
  if valid_569547 != nil:
    section.add "appId", valid_569547
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569548: Call_FeaturesDeletePatternFeature_569542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ## 
  let valid = call_569548.validator(path, query, header, formData, body)
  let scheme = call_569548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569548.url(scheme.get, call_569548.host, call_569548.base,
                         call_569548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569548, url, valid)

proc call*(call_569549: Call_FeaturesDeletePatternFeature_569542;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569550 = newJObject()
  add(path_569550, "versionId", newJString(versionId))
  add(path_569550, "patternId", newJInt(patternId))
  add(path_569550, "appId", newJString(appId))
  result = call_569549.call(path_569550, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_569542(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_569543, base: "",
    url: url_FeaturesDeletePatternFeature_569544, schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_569562 = ref object of OpenApiRestCall_567668
proc url_FeaturesAddPhraseList_569564(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesAddPhraseList_569563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new phraselist feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569565 = path.getOrDefault("versionId")
  valid_569565 = validateParameter(valid_569565, JString, required = true,
                                 default = nil)
  if valid_569565 != nil:
    section.add "versionId", valid_569565
  var valid_569566 = path.getOrDefault("appId")
  valid_569566 = validateParameter(valid_569566, JString, required = true,
                                 default = nil)
  if valid_569566 != nil:
    section.add "appId", valid_569566
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569568: Call_FeaturesAddPhraseList_569562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature in a version of the application.
  ## 
  let valid = call_569568.validator(path, query, header, formData, body)
  let scheme = call_569568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569568.url(scheme.get, call_569568.host, call_569568.base,
                         call_569568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569568, url, valid)

proc call*(call_569569: Call_FeaturesAddPhraseList_569562; versionId: string;
          phraselistCreateObject: JsonNode; appId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569570 = newJObject()
  var body_569571 = newJObject()
  add(path_569570, "versionId", newJString(versionId))
  if phraselistCreateObject != nil:
    body_569571 = phraselistCreateObject
  add(path_569570, "appId", newJString(appId))
  result = call_569569.call(path_569570, nil, nil, nil, body_569571)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_569562(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_569563, base: "",
    url: url_FeaturesAddPhraseList_569564, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_569551 = ref object of OpenApiRestCall_567668
proc url_FeaturesListPhraseLists_569553(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesListPhraseLists_569552(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the phraselist features in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569554 = path.getOrDefault("versionId")
  valid_569554 = validateParameter(valid_569554, JString, required = true,
                                 default = nil)
  if valid_569554 != nil:
    section.add "versionId", valid_569554
  var valid_569555 = path.getOrDefault("appId")
  valid_569555 = validateParameter(valid_569555, JString, required = true,
                                 default = nil)
  if valid_569555 != nil:
    section.add "appId", valid_569555
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569556 = query.getOrDefault("skip")
  valid_569556 = validateParameter(valid_569556, JInt, required = false,
                                 default = newJInt(0))
  if valid_569556 != nil:
    section.add "skip", valid_569556
  var valid_569557 = query.getOrDefault("take")
  valid_569557 = validateParameter(valid_569557, JInt, required = false,
                                 default = newJInt(100))
  if valid_569557 != nil:
    section.add "take", valid_569557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569558: Call_FeaturesListPhraseLists_569551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features in a version of the application.
  ## 
  let valid = call_569558.validator(path, query, header, formData, body)
  let scheme = call_569558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569558.url(scheme.get, call_569558.host, call_569558.base,
                         call_569558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569558, url, valid)

proc call*(call_569559: Call_FeaturesListPhraseLists_569551; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## featuresListPhraseLists
  ## Gets all the phraselist features in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569560 = newJObject()
  var query_569561 = newJObject()
  add(path_569560, "versionId", newJString(versionId))
  add(query_569561, "skip", newJInt(skip))
  add(query_569561, "take", newJInt(take))
  add(path_569560, "appId", newJString(appId))
  result = call_569559.call(path_569560, query_569561, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_569551(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_569552, base: "",
    url: url_FeaturesListPhraseLists_569553, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_569581 = ref object of OpenApiRestCall_567668
proc url_FeaturesUpdatePhraseList_569583(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesUpdatePhraseList_569582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be updated.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569584 = path.getOrDefault("versionId")
  valid_569584 = validateParameter(valid_569584, JString, required = true,
                                 default = nil)
  if valid_569584 != nil:
    section.add "versionId", valid_569584
  var valid_569585 = path.getOrDefault("phraselistId")
  valid_569585 = validateParameter(valid_569585, JInt, required = true, default = nil)
  if valid_569585 != nil:
    section.add "phraselistId", valid_569585
  var valid_569586 = path.getOrDefault("appId")
  valid_569586 = validateParameter(valid_569586, JString, required = true,
                                 default = nil)
  if valid_569586 != nil:
    section.add "appId", valid_569586
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569588: Call_FeaturesUpdatePhraseList_569581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ## 
  let valid = call_569588.validator(path, query, header, formData, body)
  let scheme = call_569588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569588.url(scheme.get, call_569588.host, call_569588.base,
                         call_569588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569588, url, valid)

proc call*(call_569589: Call_FeaturesUpdatePhraseList_569581; versionId: string;
          phraselistId: int; appId: string; phraselistUpdateObject: JsonNode = nil): Recallable =
  ## featuresUpdatePhraseList
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be updated.
  ##   appId: string (required)
  ##        : The application ID.
  ##   phraselistUpdateObject: JObject
  ##                         : The new values for: - Just a boolean called IsActive, in which case the status of the feature will be changed. - Name, Pattern, Mode, and a boolean called IsActive to update the feature.
  var path_569590 = newJObject()
  var body_569591 = newJObject()
  add(path_569590, "versionId", newJString(versionId))
  add(path_569590, "phraselistId", newJInt(phraselistId))
  add(path_569590, "appId", newJString(appId))
  if phraselistUpdateObject != nil:
    body_569591 = phraselistUpdateObject
  result = call_569589.call(path_569590, nil, nil, nil, body_569591)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_569581(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_569582, base: "",
    url: url_FeaturesUpdatePhraseList_569583, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_569572 = ref object of OpenApiRestCall_567668
proc url_FeaturesGetPhraseList_569574(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesGetPhraseList_569573(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets phraselist feature info in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569575 = path.getOrDefault("versionId")
  valid_569575 = validateParameter(valid_569575, JString, required = true,
                                 default = nil)
  if valid_569575 != nil:
    section.add "versionId", valid_569575
  var valid_569576 = path.getOrDefault("phraselistId")
  valid_569576 = validateParameter(valid_569576, JInt, required = true, default = nil)
  if valid_569576 != nil:
    section.add "phraselistId", valid_569576
  var valid_569577 = path.getOrDefault("appId")
  valid_569577 = validateParameter(valid_569577, JString, required = true,
                                 default = nil)
  if valid_569577 != nil:
    section.add "appId", valid_569577
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569578: Call_FeaturesGetPhraseList_569572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info in a version of the application.
  ## 
  let valid = call_569578.validator(path, query, header, formData, body)
  let scheme = call_569578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569578.url(scheme.get, call_569578.host, call_569578.base,
                         call_569578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569578, url, valid)

proc call*(call_569579: Call_FeaturesGetPhraseList_569572; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569580 = newJObject()
  add(path_569580, "versionId", newJString(versionId))
  add(path_569580, "phraselistId", newJInt(phraselistId))
  add(path_569580, "appId", newJString(appId))
  result = call_569579.call(path_569580, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_569572(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_569573, base: "",
    url: url_FeaturesGetPhraseList_569574, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_569592 = ref object of OpenApiRestCall_567668
proc url_FeaturesDeletePhraseList_569594(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "phraselistId" in path, "`phraselistId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/phraselists/"),
               (kind: VariableSegment, value: "phraselistId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FeaturesDeletePhraseList_569593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a phraselist feature from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   phraselistId: JInt (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569595 = path.getOrDefault("versionId")
  valid_569595 = validateParameter(valid_569595, JString, required = true,
                                 default = nil)
  if valid_569595 != nil:
    section.add "versionId", valid_569595
  var valid_569596 = path.getOrDefault("phraselistId")
  valid_569596 = validateParameter(valid_569596, JInt, required = true, default = nil)
  if valid_569596 != nil:
    section.add "phraselistId", valid_569596
  var valid_569597 = path.getOrDefault("appId")
  valid_569597 = validateParameter(valid_569597, JString, required = true,
                                 default = nil)
  if valid_569597 != nil:
    section.add "appId", valid_569597
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569598: Call_FeaturesDeletePhraseList_569592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature from a version of the application.
  ## 
  let valid = call_569598.validator(path, query, header, formData, body)
  let scheme = call_569598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569598.url(scheme.get, call_569598.host, call_569598.base,
                         call_569598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569598, url, valid)

proc call*(call_569599: Call_FeaturesDeletePhraseList_569592; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569600 = newJObject()
  add(path_569600, "versionId", newJString(versionId))
  add(path_569600, "phraselistId", newJInt(phraselistId))
  add(path_569600, "appId", newJString(appId))
  result = call_569599.call(path_569600, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_569592(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_569593, base: "",
    url: url_FeaturesDeletePhraseList_569594, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_569612 = ref object of OpenApiRestCall_567668
proc url_ModelAddPrebuilt_569614(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelAddPrebuilt_569613(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Adds a list of prebuilt entities to a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569615 = path.getOrDefault("versionId")
  valid_569615 = validateParameter(valid_569615, JString, required = true,
                                 default = nil)
  if valid_569615 != nil:
    section.add "versionId", valid_569615
  var valid_569616 = path.getOrDefault("appId")
  valid_569616 = validateParameter(valid_569616, JString, required = true,
                                 default = nil)
  if valid_569616 != nil:
    section.add "appId", valid_569616
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569618: Call_ModelAddPrebuilt_569612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entities to a version of the application.
  ## 
  let valid = call_569618.validator(path, query, header, formData, body)
  let scheme = call_569618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569618.url(scheme.get, call_569618.host, call_569618.base,
                         call_569618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569618, url, valid)

proc call*(call_569619: Call_ModelAddPrebuilt_569612; versionId: string;
          appId: string; prebuiltExtractorNames: JsonNode): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entities to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  var path_569620 = newJObject()
  var body_569621 = newJObject()
  add(path_569620, "versionId", newJString(versionId))
  add(path_569620, "appId", newJString(appId))
  if prebuiltExtractorNames != nil:
    body_569621 = prebuiltExtractorNames
  result = call_569619.call(path_569620, nil, nil, nil, body_569621)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_569612(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_569613, base: "",
    url: url_ModelAddPrebuilt_569614, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_569601 = ref object of OpenApiRestCall_567668
proc url_ModelListPrebuilts_569603(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuilts_569602(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about all the prebuilt entities in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569604 = path.getOrDefault("versionId")
  valid_569604 = validateParameter(valid_569604, JString, required = true,
                                 default = nil)
  if valid_569604 != nil:
    section.add "versionId", valid_569604
  var valid_569605 = path.getOrDefault("appId")
  valid_569605 = validateParameter(valid_569605, JString, required = true,
                                 default = nil)
  if valid_569605 != nil:
    section.add "appId", valid_569605
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569606 = query.getOrDefault("skip")
  valid_569606 = validateParameter(valid_569606, JInt, required = false,
                                 default = newJInt(0))
  if valid_569606 != nil:
    section.add "skip", valid_569606
  var valid_569607 = query.getOrDefault("take")
  valid_569607 = validateParameter(valid_569607, JInt, required = false,
                                 default = newJInt(100))
  if valid_569607 != nil:
    section.add "take", valid_569607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569608: Call_ModelListPrebuilts_569601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the prebuilt entities in a version of the application.
  ## 
  let valid = call_569608.validator(path, query, header, formData, body)
  let scheme = call_569608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569608.url(scheme.get, call_569608.host, call_569608.base,
                         call_569608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569608, url, valid)

proc call*(call_569609: Call_ModelListPrebuilts_569601; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListPrebuilts
  ## Gets information about all the prebuilt entities in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569610 = newJObject()
  var query_569611 = newJObject()
  add(path_569610, "versionId", newJString(versionId))
  add(query_569611, "skip", newJInt(skip))
  add(query_569611, "take", newJInt(take))
  add(path_569610, "appId", newJString(appId))
  result = call_569609.call(path_569610, query_569611, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_569601(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_569602, base: "",
    url: url_ModelListPrebuilts_569603, schemes: {Scheme.Https})
type
  Call_ModelCreatePrebuiltEntityRole_569631 = ref object of OpenApiRestCall_567668
proc url_ModelCreatePrebuiltEntityRole_569633(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreatePrebuiltEntityRole_569632(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569634 = path.getOrDefault("versionId")
  valid_569634 = validateParameter(valid_569634, JString, required = true,
                                 default = nil)
  if valid_569634 != nil:
    section.add "versionId", valid_569634
  var valid_569635 = path.getOrDefault("entityId")
  valid_569635 = validateParameter(valid_569635, JString, required = true,
                                 default = nil)
  if valid_569635 != nil:
    section.add "entityId", valid_569635
  var valid_569636 = path.getOrDefault("appId")
  valid_569636 = validateParameter(valid_569636, JString, required = true,
                                 default = nil)
  if valid_569636 != nil:
    section.add "appId", valid_569636
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569638: Call_ModelCreatePrebuiltEntityRole_569631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569638.validator(path, query, header, formData, body)
  let scheme = call_569638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569638.url(scheme.get, call_569638.host, call_569638.base,
                         call_569638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569638, url, valid)

proc call*(call_569639: Call_ModelCreatePrebuiltEntityRole_569631;
          versionId: string; entityId: string; entityRoleCreateObject: JsonNode;
          appId: string): Recallable =
  ## modelCreatePrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569640 = newJObject()
  var body_569641 = newJObject()
  add(path_569640, "versionId", newJString(versionId))
  add(path_569640, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_569641 = entityRoleCreateObject
  add(path_569640, "appId", newJString(appId))
  result = call_569639.call(path_569640, nil, nil, nil, body_569641)

var modelCreatePrebuiltEntityRole* = Call_ModelCreatePrebuiltEntityRole_569631(
    name: "modelCreatePrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelCreatePrebuiltEntityRole_569632, base: "",
    url: url_ModelCreatePrebuiltEntityRole_569633, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntityRoles_569622 = ref object of OpenApiRestCall_567668
proc url_ModelListPrebuiltEntityRoles_569624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListPrebuiltEntityRoles_569623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569625 = path.getOrDefault("versionId")
  valid_569625 = validateParameter(valid_569625, JString, required = true,
                                 default = nil)
  if valid_569625 != nil:
    section.add "versionId", valid_569625
  var valid_569626 = path.getOrDefault("entityId")
  valid_569626 = validateParameter(valid_569626, JString, required = true,
                                 default = nil)
  if valid_569626 != nil:
    section.add "entityId", valid_569626
  var valid_569627 = path.getOrDefault("appId")
  valid_569627 = validateParameter(valid_569627, JString, required = true,
                                 default = nil)
  if valid_569627 != nil:
    section.add "appId", valid_569627
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569628: Call_ModelListPrebuiltEntityRoles_569622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569628.validator(path, query, header, formData, body)
  let scheme = call_569628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569628.url(scheme.get, call_569628.host, call_569628.base,
                         call_569628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569628, url, valid)

proc call*(call_569629: Call_ModelListPrebuiltEntityRoles_569622;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListPrebuiltEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_569630 = newJObject()
  add(path_569630, "versionId", newJString(versionId))
  add(path_569630, "entityId", newJString(entityId))
  add(path_569630, "appId", newJString(appId))
  result = call_569629.call(path_569630, nil, nil, nil, nil)

var modelListPrebuiltEntityRoles* = Call_ModelListPrebuiltEntityRoles_569622(
    name: "modelListPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelListPrebuiltEntityRoles_569623, base: "",
    url: url_ModelListPrebuiltEntityRoles_569624, schemes: {Scheme.Https})
type
  Call_ModelUpdatePrebuiltEntityRole_569652 = ref object of OpenApiRestCall_567668
proc url_ModelUpdatePrebuiltEntityRole_569654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdatePrebuiltEntityRole_569653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569655 = path.getOrDefault("versionId")
  valid_569655 = validateParameter(valid_569655, JString, required = true,
                                 default = nil)
  if valid_569655 != nil:
    section.add "versionId", valid_569655
  var valid_569656 = path.getOrDefault("entityId")
  valid_569656 = validateParameter(valid_569656, JString, required = true,
                                 default = nil)
  if valid_569656 != nil:
    section.add "entityId", valid_569656
  var valid_569657 = path.getOrDefault("appId")
  valid_569657 = validateParameter(valid_569657, JString, required = true,
                                 default = nil)
  if valid_569657 != nil:
    section.add "appId", valid_569657
  var valid_569658 = path.getOrDefault("roleId")
  valid_569658 = validateParameter(valid_569658, JString, required = true,
                                 default = nil)
  if valid_569658 != nil:
    section.add "roleId", valid_569658
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569660: Call_ModelUpdatePrebuiltEntityRole_569652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569660.validator(path, query, header, formData, body)
  let scheme = call_569660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569660.url(scheme.get, call_569660.host, call_569660.base,
                         call_569660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569660, url, valid)

proc call*(call_569661: Call_ModelUpdatePrebuiltEntityRole_569652;
          versionId: string; entityRoleUpdateObject: JsonNode; entityId: string;
          appId: string; roleId: string): Recallable =
  ## modelUpdatePrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_569662 = newJObject()
  var body_569663 = newJObject()
  add(path_569662, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_569663 = entityRoleUpdateObject
  add(path_569662, "entityId", newJString(entityId))
  add(path_569662, "appId", newJString(appId))
  add(path_569662, "roleId", newJString(roleId))
  result = call_569661.call(path_569662, nil, nil, nil, body_569663)

var modelUpdatePrebuiltEntityRole* = Call_ModelUpdatePrebuiltEntityRole_569652(
    name: "modelUpdatePrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePrebuiltEntityRole_569653, base: "",
    url: url_ModelUpdatePrebuiltEntityRole_569654, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuiltEntityRole_569642 = ref object of OpenApiRestCall_567668
proc url_ModelGetPrebuiltEntityRole_569644(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPrebuiltEntityRole_569643(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569645 = path.getOrDefault("versionId")
  valid_569645 = validateParameter(valid_569645, JString, required = true,
                                 default = nil)
  if valid_569645 != nil:
    section.add "versionId", valid_569645
  var valid_569646 = path.getOrDefault("entityId")
  valid_569646 = validateParameter(valid_569646, JString, required = true,
                                 default = nil)
  if valid_569646 != nil:
    section.add "entityId", valid_569646
  var valid_569647 = path.getOrDefault("appId")
  valid_569647 = validateParameter(valid_569647, JString, required = true,
                                 default = nil)
  if valid_569647 != nil:
    section.add "appId", valid_569647
  var valid_569648 = path.getOrDefault("roleId")
  valid_569648 = validateParameter(valid_569648, JString, required = true,
                                 default = nil)
  if valid_569648 != nil:
    section.add "roleId", valid_569648
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569649: Call_ModelGetPrebuiltEntityRole_569642; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569649.validator(path, query, header, formData, body)
  let scheme = call_569649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569649.url(scheme.get, call_569649.host, call_569649.base,
                         call_569649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569649, url, valid)

proc call*(call_569650: Call_ModelGetPrebuiltEntityRole_569642; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetPrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_569651 = newJObject()
  add(path_569651, "versionId", newJString(versionId))
  add(path_569651, "entityId", newJString(entityId))
  add(path_569651, "appId", newJString(appId))
  add(path_569651, "roleId", newJString(roleId))
  result = call_569650.call(path_569651, nil, nil, nil, nil)

var modelGetPrebuiltEntityRole* = Call_ModelGetPrebuiltEntityRole_569642(
    name: "modelGetPrebuiltEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPrebuiltEntityRole_569643, base: "",
    url: url_ModelGetPrebuiltEntityRole_569644, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuiltEntityRole_569664 = ref object of OpenApiRestCall_567668
proc url_ModelDeletePrebuiltEntityRole_569666(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePrebuiltEntityRole_569665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569667 = path.getOrDefault("versionId")
  valid_569667 = validateParameter(valid_569667, JString, required = true,
                                 default = nil)
  if valid_569667 != nil:
    section.add "versionId", valid_569667
  var valid_569668 = path.getOrDefault("entityId")
  valid_569668 = validateParameter(valid_569668, JString, required = true,
                                 default = nil)
  if valid_569668 != nil:
    section.add "entityId", valid_569668
  var valid_569669 = path.getOrDefault("appId")
  valid_569669 = validateParameter(valid_569669, JString, required = true,
                                 default = nil)
  if valid_569669 != nil:
    section.add "appId", valid_569669
  var valid_569670 = path.getOrDefault("roleId")
  valid_569670 = validateParameter(valid_569670, JString, required = true,
                                 default = nil)
  if valid_569670 != nil:
    section.add "roleId", valid_569670
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569671: Call_ModelDeletePrebuiltEntityRole_569664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569671.validator(path, query, header, formData, body)
  let scheme = call_569671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569671.url(scheme.get, call_569671.host, call_569671.base,
                         call_569671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569671, url, valid)

proc call*(call_569672: Call_ModelDeletePrebuiltEntityRole_569664;
          versionId: string; entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeletePrebuiltEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_569673 = newJObject()
  add(path_569673, "versionId", newJString(versionId))
  add(path_569673, "entityId", newJString(entityId))
  add(path_569673, "appId", newJString(appId))
  add(path_569673, "roleId", newJString(roleId))
  result = call_569672.call(path_569673, nil, nil, nil, nil)

var modelDeletePrebuiltEntityRole* = Call_ModelDeletePrebuiltEntityRole_569664(
    name: "modelDeletePrebuiltEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePrebuiltEntityRole_569665, base: "",
    url: url_ModelDeletePrebuiltEntityRole_569666, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_569674 = ref object of OpenApiRestCall_567668
proc url_ModelGetPrebuilt_569676(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "prebuiltId" in path, "`prebuiltId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "prebuiltId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetPrebuilt_569675(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about a prebuilt entity model in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569677 = path.getOrDefault("versionId")
  valid_569677 = validateParameter(valid_569677, JString, required = true,
                                 default = nil)
  if valid_569677 != nil:
    section.add "versionId", valid_569677
  var valid_569678 = path.getOrDefault("prebuiltId")
  valid_569678 = validateParameter(valid_569678, JString, required = true,
                                 default = nil)
  if valid_569678 != nil:
    section.add "prebuiltId", valid_569678
  var valid_569679 = path.getOrDefault("appId")
  valid_569679 = validateParameter(valid_569679, JString, required = true,
                                 default = nil)
  if valid_569679 != nil:
    section.add "appId", valid_569679
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569680: Call_ModelGetPrebuilt_569674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a prebuilt entity model in a version of the application.
  ## 
  let valid = call_569680.validator(path, query, header, formData, body)
  let scheme = call_569680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569680.url(scheme.get, call_569680.host, call_569680.base,
                         call_569680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569680, url, valid)

proc call*(call_569681: Call_ModelGetPrebuilt_569674; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about a prebuilt entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569682 = newJObject()
  add(path_569682, "versionId", newJString(versionId))
  add(path_569682, "prebuiltId", newJString(prebuiltId))
  add(path_569682, "appId", newJString(appId))
  result = call_569681.call(path_569682, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_569674(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_569675, base: "",
    url: url_ModelGetPrebuilt_569676, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_569683 = ref object of OpenApiRestCall_567668
proc url_ModelDeletePrebuilt_569685(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "prebuiltId" in path, "`prebuiltId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/prebuilts/"),
               (kind: VariableSegment, value: "prebuiltId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeletePrebuilt_569684(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a prebuilt entity extractor from a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   prebuiltId: JString (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569686 = path.getOrDefault("versionId")
  valid_569686 = validateParameter(valid_569686, JString, required = true,
                                 default = nil)
  if valid_569686 != nil:
    section.add "versionId", valid_569686
  var valid_569687 = path.getOrDefault("prebuiltId")
  valid_569687 = validateParameter(valid_569687, JString, required = true,
                                 default = nil)
  if valid_569687 != nil:
    section.add "prebuiltId", valid_569687
  var valid_569688 = path.getOrDefault("appId")
  valid_569688 = validateParameter(valid_569688, JString, required = true,
                                 default = nil)
  if valid_569688 != nil:
    section.add "appId", valid_569688
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569689: Call_ModelDeletePrebuilt_569683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from a version of the application.
  ## 
  let valid = call_569689.validator(path, query, header, formData, body)
  let scheme = call_569689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569689.url(scheme.get, call_569689.host, call_569689.base,
                         call_569689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569689, url, valid)

proc call*(call_569690: Call_ModelDeletePrebuilt_569683; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569691 = newJObject()
  add(path_569691, "versionId", newJString(versionId))
  add(path_569691, "prebuiltId", newJString(prebuiltId))
  add(path_569691, "appId", newJString(appId))
  result = call_569690.call(path_569691, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_569683(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_569684, base: "",
    url: url_ModelDeletePrebuilt_569685, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityModel_569703 = ref object of OpenApiRestCall_567668
proc url_ModelCreateRegexEntityModel_569705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateRegexEntityModel_569704(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569706 = path.getOrDefault("versionId")
  valid_569706 = validateParameter(valid_569706, JString, required = true,
                                 default = nil)
  if valid_569706 != nil:
    section.add "versionId", valid_569706
  var valid_569707 = path.getOrDefault("appId")
  valid_569707 = validateParameter(valid_569707, JString, required = true,
                                 default = nil)
  if valid_569707 != nil:
    section.add "appId", valid_569707
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regexEntityExtractorCreateObj: JObject (required)
  ##                                : A model object containing the name and regex pattern for the new regular expression entity extractor.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569709: Call_ModelCreateRegexEntityModel_569703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569709.validator(path, query, header, formData, body)
  let scheme = call_569709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569709.url(scheme.get, call_569709.host, call_569709.base,
                         call_569709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569709, url, valid)

proc call*(call_569710: Call_ModelCreateRegexEntityModel_569703;
          regexEntityExtractorCreateObj: JsonNode; versionId: string; appId: string): Recallable =
  ## modelCreateRegexEntityModel
  ##   regexEntityExtractorCreateObj: JObject (required)
  ##                                : A model object containing the name and regex pattern for the new regular expression entity extractor.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569711 = newJObject()
  var body_569712 = newJObject()
  if regexEntityExtractorCreateObj != nil:
    body_569712 = regexEntityExtractorCreateObj
  add(path_569711, "versionId", newJString(versionId))
  add(path_569711, "appId", newJString(appId))
  result = call_569710.call(path_569711, nil, nil, nil, body_569712)

var modelCreateRegexEntityModel* = Call_ModelCreateRegexEntityModel_569703(
    name: "modelCreateRegexEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelCreateRegexEntityModel_569704, base: "",
    url: url_ModelCreateRegexEntityModel_569705, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityInfos_569692 = ref object of OpenApiRestCall_567668
proc url_ModelListRegexEntityInfos_569694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListRegexEntityInfos_569693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569695 = path.getOrDefault("versionId")
  valid_569695 = validateParameter(valid_569695, JString, required = true,
                                 default = nil)
  if valid_569695 != nil:
    section.add "versionId", valid_569695
  var valid_569696 = path.getOrDefault("appId")
  valid_569696 = validateParameter(valid_569696, JString, required = true,
                                 default = nil)
  if valid_569696 != nil:
    section.add "appId", valid_569696
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_569697 = query.getOrDefault("skip")
  valid_569697 = validateParameter(valid_569697, JInt, required = false,
                                 default = newJInt(0))
  if valid_569697 != nil:
    section.add "skip", valid_569697
  var valid_569698 = query.getOrDefault("take")
  valid_569698 = validateParameter(valid_569698, JInt, required = false,
                                 default = newJInt(100))
  if valid_569698 != nil:
    section.add "take", valid_569698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569699: Call_ModelListRegexEntityInfos_569692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569699.validator(path, query, header, formData, body)
  let scheme = call_569699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569699.url(scheme.get, call_569699.host, call_569699.base,
                         call_569699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569699, url, valid)

proc call*(call_569700: Call_ModelListRegexEntityInfos_569692; versionId: string;
          appId: string; skip: int = 0; take: int = 100): Recallable =
  ## modelListRegexEntityInfos
  ##   versionId: string (required)
  ##            : The version ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569701 = newJObject()
  var query_569702 = newJObject()
  add(path_569701, "versionId", newJString(versionId))
  add(query_569702, "skip", newJInt(skip))
  add(query_569702, "take", newJInt(take))
  add(path_569701, "appId", newJString(appId))
  result = call_569700.call(path_569701, query_569702, nil, nil, nil)

var modelListRegexEntityInfos* = Call_ModelListRegexEntityInfos_569692(
    name: "modelListRegexEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelListRegexEntityInfos_569693, base: "",
    url: url_ModelListRegexEntityInfos_569694, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityRole_569722 = ref object of OpenApiRestCall_567668
proc url_ModelCreateRegexEntityRole_569724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelCreateRegexEntityRole_569723(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569725 = path.getOrDefault("versionId")
  valid_569725 = validateParameter(valid_569725, JString, required = true,
                                 default = nil)
  if valid_569725 != nil:
    section.add "versionId", valid_569725
  var valid_569726 = path.getOrDefault("entityId")
  valid_569726 = validateParameter(valid_569726, JString, required = true,
                                 default = nil)
  if valid_569726 != nil:
    section.add "entityId", valid_569726
  var valid_569727 = path.getOrDefault("appId")
  valid_569727 = validateParameter(valid_569727, JString, required = true,
                                 default = nil)
  if valid_569727 != nil:
    section.add "appId", valid_569727
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569729: Call_ModelCreateRegexEntityRole_569722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569729.validator(path, query, header, formData, body)
  let scheme = call_569729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569729.url(scheme.get, call_569729.host, call_569729.base,
                         call_569729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569729, url, valid)

proc call*(call_569730: Call_ModelCreateRegexEntityRole_569722; versionId: string;
          entityId: string; entityRoleCreateObject: JsonNode; appId: string): Recallable =
  ## modelCreateRegexEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity model ID.
  ##   entityRoleCreateObject: JObject (required)
  ##                         : An entity role object containing the name of role.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569731 = newJObject()
  var body_569732 = newJObject()
  add(path_569731, "versionId", newJString(versionId))
  add(path_569731, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_569732 = entityRoleCreateObject
  add(path_569731, "appId", newJString(appId))
  result = call_569730.call(path_569731, nil, nil, nil, body_569732)

var modelCreateRegexEntityRole* = Call_ModelCreateRegexEntityRole_569722(
    name: "modelCreateRegexEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelCreateRegexEntityRole_569723, base: "",
    url: url_ModelCreateRegexEntityRole_569724, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityRoles_569713 = ref object of OpenApiRestCall_567668
proc url_ModelListRegexEntityRoles_569715(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelListRegexEntityRoles_569714(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity Id
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569716 = path.getOrDefault("versionId")
  valid_569716 = validateParameter(valid_569716, JString, required = true,
                                 default = nil)
  if valid_569716 != nil:
    section.add "versionId", valid_569716
  var valid_569717 = path.getOrDefault("entityId")
  valid_569717 = validateParameter(valid_569717, JString, required = true,
                                 default = nil)
  if valid_569717 != nil:
    section.add "entityId", valid_569717
  var valid_569718 = path.getOrDefault("appId")
  valid_569718 = validateParameter(valid_569718, JString, required = true,
                                 default = nil)
  if valid_569718 != nil:
    section.add "appId", valid_569718
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569719: Call_ModelListRegexEntityRoles_569713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569719.validator(path, query, header, formData, body)
  let scheme = call_569719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569719.url(scheme.get, call_569719.host, call_569719.base,
                         call_569719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569719, url, valid)

proc call*(call_569720: Call_ModelListRegexEntityRoles_569713; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelListRegexEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_569721 = newJObject()
  add(path_569721, "versionId", newJString(versionId))
  add(path_569721, "entityId", newJString(entityId))
  add(path_569721, "appId", newJString(appId))
  result = call_569720.call(path_569721, nil, nil, nil, nil)

var modelListRegexEntityRoles* = Call_ModelListRegexEntityRoles_569713(
    name: "modelListRegexEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelListRegexEntityRoles_569714, base: "",
    url: url_ModelListRegexEntityRoles_569715, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityRole_569743 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateRegexEntityRole_569745(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateRegexEntityRole_569744(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569746 = path.getOrDefault("versionId")
  valid_569746 = validateParameter(valid_569746, JString, required = true,
                                 default = nil)
  if valid_569746 != nil:
    section.add "versionId", valid_569746
  var valid_569747 = path.getOrDefault("entityId")
  valid_569747 = validateParameter(valid_569747, JString, required = true,
                                 default = nil)
  if valid_569747 != nil:
    section.add "entityId", valid_569747
  var valid_569748 = path.getOrDefault("appId")
  valid_569748 = validateParameter(valid_569748, JString, required = true,
                                 default = nil)
  if valid_569748 != nil:
    section.add "appId", valid_569748
  var valid_569749 = path.getOrDefault("roleId")
  valid_569749 = validateParameter(valid_569749, JString, required = true,
                                 default = nil)
  if valid_569749 != nil:
    section.add "roleId", valid_569749
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569751: Call_ModelUpdateRegexEntityRole_569743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569751.validator(path, query, header, formData, body)
  let scheme = call_569751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569751.url(scheme.get, call_569751.host, call_569751.base,
                         call_569751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569751, url, valid)

proc call*(call_569752: Call_ModelUpdateRegexEntityRole_569743; versionId: string;
          entityRoleUpdateObject: JsonNode; entityId: string; appId: string;
          roleId: string): Recallable =
  ## modelUpdateRegexEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityRoleUpdateObject: JObject (required)
  ##                         : The new entity role.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role ID.
  var path_569753 = newJObject()
  var body_569754 = newJObject()
  add(path_569753, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_569754 = entityRoleUpdateObject
  add(path_569753, "entityId", newJString(entityId))
  add(path_569753, "appId", newJString(appId))
  add(path_569753, "roleId", newJString(roleId))
  result = call_569752.call(path_569753, nil, nil, nil, body_569754)

var modelUpdateRegexEntityRole* = Call_ModelUpdateRegexEntityRole_569743(
    name: "modelUpdateRegexEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateRegexEntityRole_569744, base: "",
    url: url_ModelUpdateRegexEntityRole_569745, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityRole_569733 = ref object of OpenApiRestCall_567668
proc url_ModelGetRegexEntityRole_569735(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetRegexEntityRole_569734(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : entity role ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569736 = path.getOrDefault("versionId")
  valid_569736 = validateParameter(valid_569736, JString, required = true,
                                 default = nil)
  if valid_569736 != nil:
    section.add "versionId", valid_569736
  var valid_569737 = path.getOrDefault("entityId")
  valid_569737 = validateParameter(valid_569737, JString, required = true,
                                 default = nil)
  if valid_569737 != nil:
    section.add "entityId", valid_569737
  var valid_569738 = path.getOrDefault("appId")
  valid_569738 = validateParameter(valid_569738, JString, required = true,
                                 default = nil)
  if valid_569738 != nil:
    section.add "appId", valid_569738
  var valid_569739 = path.getOrDefault("roleId")
  valid_569739 = validateParameter(valid_569739, JString, required = true,
                                 default = nil)
  if valid_569739 != nil:
    section.add "roleId", valid_569739
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569740: Call_ModelGetRegexEntityRole_569733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569740.validator(path, query, header, formData, body)
  let scheme = call_569740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569740.url(scheme.get, call_569740.host, call_569740.base,
                         call_569740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569740, url, valid)

proc call*(call_569741: Call_ModelGetRegexEntityRole_569733; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelGetRegexEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : entity role ID.
  var path_569742 = newJObject()
  add(path_569742, "versionId", newJString(versionId))
  add(path_569742, "entityId", newJString(entityId))
  add(path_569742, "appId", newJString(appId))
  add(path_569742, "roleId", newJString(roleId))
  result = call_569741.call(path_569742, nil, nil, nil, nil)

var modelGetRegexEntityRole* = Call_ModelGetRegexEntityRole_569733(
    name: "modelGetRegexEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetRegexEntityRole_569734, base: "",
    url: url_ModelGetRegexEntityRole_569735, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityRole_569755 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteRegexEntityRole_569757(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteRegexEntityRole_569756(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   entityId: JString (required)
  ##           : The entity ID.
  ##   appId: JString (required)
  ##        : The application ID.
  ##   roleId: JString (required)
  ##         : The entity role Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569758 = path.getOrDefault("versionId")
  valid_569758 = validateParameter(valid_569758, JString, required = true,
                                 default = nil)
  if valid_569758 != nil:
    section.add "versionId", valid_569758
  var valid_569759 = path.getOrDefault("entityId")
  valid_569759 = validateParameter(valid_569759, JString, required = true,
                                 default = nil)
  if valid_569759 != nil:
    section.add "entityId", valid_569759
  var valid_569760 = path.getOrDefault("appId")
  valid_569760 = validateParameter(valid_569760, JString, required = true,
                                 default = nil)
  if valid_569760 != nil:
    section.add "appId", valid_569760
  var valid_569761 = path.getOrDefault("roleId")
  valid_569761 = validateParameter(valid_569761, JString, required = true,
                                 default = nil)
  if valid_569761 != nil:
    section.add "roleId", valid_569761
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569762: Call_ModelDeleteRegexEntityRole_569755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569762.validator(path, query, header, formData, body)
  let scheme = call_569762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569762.url(scheme.get, call_569762.host, call_569762.base,
                         call_569762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569762, url, valid)

proc call*(call_569763: Call_ModelDeleteRegexEntityRole_569755; versionId: string;
          entityId: string; appId: string; roleId: string): Recallable =
  ## modelDeleteRegexEntityRole
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   roleId: string (required)
  ##         : The entity role Id.
  var path_569764 = newJObject()
  add(path_569764, "versionId", newJString(versionId))
  add(path_569764, "entityId", newJString(entityId))
  add(path_569764, "appId", newJString(appId))
  add(path_569764, "roleId", newJString(roleId))
  result = call_569763.call(path_569764, nil, nil, nil, nil)

var modelDeleteRegexEntityRole* = Call_ModelDeleteRegexEntityRole_569755(
    name: "modelDeleteRegexEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteRegexEntityRole_569756, base: "",
    url: url_ModelDeleteRegexEntityRole_569757, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityModel_569774 = ref object of OpenApiRestCall_567668
proc url_ModelUpdateRegexEntityModel_569776(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelUpdateRegexEntityModel_569775(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569777 = path.getOrDefault("versionId")
  valid_569777 = validateParameter(valid_569777, JString, required = true,
                                 default = nil)
  if valid_569777 != nil:
    section.add "versionId", valid_569777
  var valid_569778 = path.getOrDefault("regexEntityId")
  valid_569778 = validateParameter(valid_569778, JString, required = true,
                                 default = nil)
  if valid_569778 != nil:
    section.add "regexEntityId", valid_569778
  var valid_569779 = path.getOrDefault("appId")
  valid_569779 = validateParameter(valid_569779, JString, required = true,
                                 default = nil)
  if valid_569779 != nil:
    section.add "appId", valid_569779
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regexEntityUpdateObject: JObject (required)
  ##                          : An object containing the new entity name and regex pattern.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569781: Call_ModelUpdateRegexEntityModel_569774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569781.validator(path, query, header, formData, body)
  let scheme = call_569781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569781.url(scheme.get, call_569781.host, call_569781.base,
                         call_569781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569781, url, valid)

proc call*(call_569782: Call_ModelUpdateRegexEntityModel_569774; versionId: string;
          regexEntityId: string; appId: string; regexEntityUpdateObject: JsonNode): Recallable =
  ## modelUpdateRegexEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityId: string (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   regexEntityUpdateObject: JObject (required)
  ##                          : An object containing the new entity name and regex pattern.
  var path_569783 = newJObject()
  var body_569784 = newJObject()
  add(path_569783, "versionId", newJString(versionId))
  add(path_569783, "regexEntityId", newJString(regexEntityId))
  add(path_569783, "appId", newJString(appId))
  if regexEntityUpdateObject != nil:
    body_569784 = regexEntityUpdateObject
  result = call_569782.call(path_569783, nil, nil, nil, body_569784)

var modelUpdateRegexEntityModel* = Call_ModelUpdateRegexEntityModel_569774(
    name: "modelUpdateRegexEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelUpdateRegexEntityModel_569775, base: "",
    url: url_ModelUpdateRegexEntityModel_569776, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityEntityInfo_569765 = ref object of OpenApiRestCall_567668
proc url_ModelGetRegexEntityEntityInfo_569767(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelGetRegexEntityEntityInfo_569766(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity model ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569768 = path.getOrDefault("versionId")
  valid_569768 = validateParameter(valid_569768, JString, required = true,
                                 default = nil)
  if valid_569768 != nil:
    section.add "versionId", valid_569768
  var valid_569769 = path.getOrDefault("regexEntityId")
  valid_569769 = validateParameter(valid_569769, JString, required = true,
                                 default = nil)
  if valid_569769 != nil:
    section.add "regexEntityId", valid_569769
  var valid_569770 = path.getOrDefault("appId")
  valid_569770 = validateParameter(valid_569770, JString, required = true,
                                 default = nil)
  if valid_569770 != nil:
    section.add "appId", valid_569770
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569771: Call_ModelGetRegexEntityEntityInfo_569765; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569771.validator(path, query, header, formData, body)
  let scheme = call_569771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569771.url(scheme.get, call_569771.host, call_569771.base,
                         call_569771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569771, url, valid)

proc call*(call_569772: Call_ModelGetRegexEntityEntityInfo_569765;
          versionId: string; regexEntityId: string; appId: string): Recallable =
  ## modelGetRegexEntityEntityInfo
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityId: string (required)
  ##                : The regular expression entity model ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569773 = newJObject()
  add(path_569773, "versionId", newJString(versionId))
  add(path_569773, "regexEntityId", newJString(regexEntityId))
  add(path_569773, "appId", newJString(appId))
  result = call_569772.call(path_569773, nil, nil, nil, nil)

var modelGetRegexEntityEntityInfo* = Call_ModelGetRegexEntityEntityInfo_569765(
    name: "modelGetRegexEntityEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelGetRegexEntityEntityInfo_569766, base: "",
    url: url_ModelGetRegexEntityEntityInfo_569767, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityModel_569785 = ref object of OpenApiRestCall_567668
proc url_ModelDeleteRegexEntityModel_569787(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "regexEntityId" in path, "`regexEntityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/regexentities/"),
               (kind: VariableSegment, value: "regexEntityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ModelDeleteRegexEntityModel_569786(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   regexEntityId: JString (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569788 = path.getOrDefault("versionId")
  valid_569788 = validateParameter(valid_569788, JString, required = true,
                                 default = nil)
  if valid_569788 != nil:
    section.add "versionId", valid_569788
  var valid_569789 = path.getOrDefault("regexEntityId")
  valid_569789 = validateParameter(valid_569789, JString, required = true,
                                 default = nil)
  if valid_569789 != nil:
    section.add "regexEntityId", valid_569789
  var valid_569790 = path.getOrDefault("appId")
  valid_569790 = validateParameter(valid_569790, JString, required = true,
                                 default = nil)
  if valid_569790 != nil:
    section.add "appId", valid_569790
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569791: Call_ModelDeleteRegexEntityModel_569785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569791.validator(path, query, header, formData, body)
  let scheme = call_569791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569791.url(scheme.get, call_569791.host, call_569791.base,
                         call_569791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569791, url, valid)

proc call*(call_569792: Call_ModelDeleteRegexEntityModel_569785; versionId: string;
          regexEntityId: string; appId: string): Recallable =
  ## modelDeleteRegexEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityId: string (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569793 = newJObject()
  add(path_569793, "versionId", newJString(versionId))
  add(path_569793, "regexEntityId", newJString(regexEntityId))
  add(path_569793, "appId", newJString(appId))
  result = call_569792.call(path_569793, nil, nil, nil, nil)

var modelDeleteRegexEntityModel* = Call_ModelDeleteRegexEntityModel_569785(
    name: "modelDeleteRegexEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelDeleteRegexEntityModel_569786, base: "",
    url: url_ModelDeleteRegexEntityModel_569787, schemes: {Scheme.Https})
type
  Call_SettingsUpdate_569802 = ref object of OpenApiRestCall_567668
proc url_SettingsUpdate_569804(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsUpdate_569803(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the settings in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569805 = path.getOrDefault("versionId")
  valid_569805 = validateParameter(valid_569805, JString, required = true,
                                 default = nil)
  if valid_569805 != nil:
    section.add "versionId", valid_569805
  var valid_569806 = path.getOrDefault("appId")
  valid_569806 = validateParameter(valid_569806, JString, required = true,
                                 default = nil)
  if valid_569806 != nil:
    section.add "appId", valid_569806
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listOfAppVersionSettingObject: JArray (required)
  ##                                : A list of the updated application version settings.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569808: Call_SettingsUpdate_569802; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings in a version of the application.
  ## 
  let valid = call_569808.validator(path, query, header, formData, body)
  let scheme = call_569808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569808.url(scheme.get, call_569808.host, call_569808.base,
                         call_569808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569808, url, valid)

proc call*(call_569809: Call_SettingsUpdate_569802; versionId: string; appId: string;
          listOfAppVersionSettingObject: JsonNode): Recallable =
  ## settingsUpdate
  ## Updates the settings in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   listOfAppVersionSettingObject: JArray (required)
  ##                                : A list of the updated application version settings.
  var path_569810 = newJObject()
  var body_569811 = newJObject()
  add(path_569810, "versionId", newJString(versionId))
  add(path_569810, "appId", newJString(appId))
  if listOfAppVersionSettingObject != nil:
    body_569811 = listOfAppVersionSettingObject
  result = call_569809.call(path_569810, nil, nil, nil, body_569811)

var settingsUpdate* = Call_SettingsUpdate_569802(name: "settingsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsUpdate_569803, base: "", url: url_SettingsUpdate_569804,
    schemes: {Scheme.Https})
type
  Call_SettingsList_569794 = ref object of OpenApiRestCall_567668
proc url_SettingsList_569796(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsList_569795(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the settings in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569797 = path.getOrDefault("versionId")
  valid_569797 = validateParameter(valid_569797, JString, required = true,
                                 default = nil)
  if valid_569797 != nil:
    section.add "versionId", valid_569797
  var valid_569798 = path.getOrDefault("appId")
  valid_569798 = validateParameter(valid_569798, JString, required = true,
                                 default = nil)
  if valid_569798 != nil:
    section.add "appId", valid_569798
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569799: Call_SettingsList_569794; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the settings in a version of the application.
  ## 
  let valid = call_569799.validator(path, query, header, formData, body)
  let scheme = call_569799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569799.url(scheme.get, call_569799.host, call_569799.base,
                         call_569799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569799, url, valid)

proc call*(call_569800: Call_SettingsList_569794; versionId: string; appId: string): Recallable =
  ## settingsList
  ## Gets the settings in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569801 = newJObject()
  add(path_569801, "versionId", newJString(versionId))
  add(path_569801, "appId", newJString(appId))
  result = call_569800.call(path_569801, nil, nil, nil, nil)

var settingsList* = Call_SettingsList_569794(name: "settingsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsList_569795, base: "", url: url_SettingsList_569796,
    schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_569812 = ref object of OpenApiRestCall_567668
proc url_VersionsDeleteUnlabelledUtterance_569814(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/suggest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VersionsDeleteUnlabelledUtterance_569813(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an unlabelled utterance in a version of the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569815 = path.getOrDefault("versionId")
  valid_569815 = validateParameter(valid_569815, JString, required = true,
                                 default = nil)
  if valid_569815 != nil:
    section.add "versionId", valid_569815
  var valid_569816 = path.getOrDefault("appId")
  valid_569816 = validateParameter(valid_569816, JString, required = true,
                                 default = nil)
  if valid_569816 != nil:
    section.add "appId", valid_569816
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569818: Call_VersionsDeleteUnlabelledUtterance_569812;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance in a version of the application.
  ## 
  let valid = call_569818.validator(path, query, header, formData, body)
  let scheme = call_569818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569818.url(scheme.get, call_569818.host, call_569818.base,
                         call_569818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569818, url, valid)

proc call*(call_569819: Call_VersionsDeleteUnlabelledUtterance_569812;
          versionId: string; appId: string; utterance: JsonNode): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  var path_569820 = newJObject()
  var body_569821 = newJObject()
  add(path_569820, "versionId", newJString(versionId))
  add(path_569820, "appId", newJString(appId))
  if utterance != nil:
    body_569821 = utterance
  result = call_569819.call(path_569820, nil, nil, nil, body_569821)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_569812(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_569813, base: "",
    url: url_VersionsDeleteUnlabelledUtterance_569814, schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_569830 = ref object of OpenApiRestCall_567668
proc url_TrainTrainVersion_569832(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrainTrainVersion_569831(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569833 = path.getOrDefault("versionId")
  valid_569833 = validateParameter(valid_569833, JString, required = true,
                                 default = nil)
  if valid_569833 != nil:
    section.add "versionId", valid_569833
  var valid_569834 = path.getOrDefault("appId")
  valid_569834 = validateParameter(valid_569834, JString, required = true,
                                 default = nil)
  if valid_569834 != nil:
    section.add "appId", valid_569834
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569835: Call_TrainTrainVersion_569830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_569835.validator(path, query, header, formData, body)
  let scheme = call_569835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569835.url(scheme.get, call_569835.host, call_569835.base,
                         call_569835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569835, url, valid)

proc call*(call_569836: Call_TrainTrainVersion_569830; versionId: string;
          appId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569837 = newJObject()
  add(path_569837, "versionId", newJString(versionId))
  add(path_569837, "appId", newJString(appId))
  result = call_569836.call(path_569837, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_569830(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_569831, base: "",
    url: url_TrainTrainVersion_569832, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_569822 = ref object of OpenApiRestCall_567668
proc url_TrainGetStatus_569824(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TrainGetStatus_569823(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569825 = path.getOrDefault("versionId")
  valid_569825 = validateParameter(valid_569825, JString, required = true,
                                 default = nil)
  if valid_569825 != nil:
    section.add "versionId", valid_569825
  var valid_569826 = path.getOrDefault("appId")
  valid_569826 = validateParameter(valid_569826, JString, required = true,
                                 default = nil)
  if valid_569826 != nil:
    section.add "appId", valid_569826
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569827: Call_TrainGetStatus_569822; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_569827.validator(path, query, header, formData, body)
  let scheme = call_569827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569827.url(scheme.get, call_569827.host, call_569827.base,
                         call_569827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569827, url, valid)

proc call*(call_569828: Call_TrainGetStatus_569822; versionId: string; appId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569829 = newJObject()
  add(path_569829, "versionId", newJString(versionId))
  add(path_569829, "appId", newJString(appId))
  result = call_569828.call(path_569829, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_569822(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_569823, base: "", url: url_TrainGetStatus_569824,
    schemes: {Scheme.Https})
type
  Call_AzureAccountsListUserLUISAccounts_569838 = ref object of OpenApiRestCall_567668
proc url_AzureAccountsListUserLUISAccounts_569840(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AzureAccountsListUserLUISAccounts_569839(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_569841 = header.getOrDefault("Authorization")
  valid_569841 = validateParameter(valid_569841, JString, required = true,
                                 default = nil)
  if valid_569841 != nil:
    section.add "Authorization", valid_569841
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569842: Call_AzureAccountsListUserLUISAccounts_569838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  ## 
  let valid = call_569842.validator(path, query, header, formData, body)
  let scheme = call_569842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569842.url(scheme.get, call_569842.host, call_569842.base,
                         call_569842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569842, url, valid)

proc call*(call_569843: Call_AzureAccountsListUserLUISAccounts_569838): Recallable =
  ## azureAccountsListUserLUISAccounts
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  result = call_569843.call(nil, nil, nil, nil, nil)

var azureAccountsListUserLUISAccounts* = Call_AzureAccountsListUserLUISAccounts_569838(
    name: "azureAccountsListUserLUISAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/azureaccounts",
    validator: validate_AzureAccountsListUserLUISAccounts_569839, base: "",
    url: url_AzureAccountsListUserLUISAccounts_569840, schemes: {Scheme.Https})
type
  Call_AppsPackagePublishedApplicationAsGzip_569844 = ref object of OpenApiRestCall_567668
proc url_AppsPackagePublishedApplicationAsGzip_569846(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "slotName" in path, "`slotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/package/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/slot/"),
               (kind: VariableSegment, value: "slotName"),
               (kind: ConstantSegment, value: "/gzip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPackagePublishedApplicationAsGzip_569845(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   slotName: JString (required)
  ##           : The publishing slot name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_569847 = path.getOrDefault("appId")
  valid_569847 = validateParameter(valid_569847, JString, required = true,
                                 default = nil)
  if valid_569847 != nil:
    section.add "appId", valid_569847
  var valid_569848 = path.getOrDefault("slotName")
  valid_569848 = validateParameter(valid_569848, JString, required = true,
                                 default = nil)
  if valid_569848 != nil:
    section.add "slotName", valid_569848
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569849: Call_AppsPackagePublishedApplicationAsGzip_569844;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ## 
  let valid = call_569849.validator(path, query, header, formData, body)
  let scheme = call_569849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569849.url(scheme.get, call_569849.host, call_569849.base,
                         call_569849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569849, url, valid)

proc call*(call_569850: Call_AppsPackagePublishedApplicationAsGzip_569844;
          appId: string; slotName: string): Recallable =
  ## appsPackagePublishedApplicationAsGzip
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ##   appId: string (required)
  ##        : The application ID.
  ##   slotName: string (required)
  ##           : The publishing slot name.
  var path_569851 = newJObject()
  add(path_569851, "appId", newJString(appId))
  add(path_569851, "slotName", newJString(slotName))
  result = call_569850.call(path_569851, nil, nil, nil, nil)

var appsPackagePublishedApplicationAsGzip* = Call_AppsPackagePublishedApplicationAsGzip_569844(
    name: "appsPackagePublishedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/slot/{slotName}/gzip",
    validator: validate_AppsPackagePublishedApplicationAsGzip_569845, base: "",
    url: url_AppsPackagePublishedApplicationAsGzip_569846, schemes: {Scheme.Https})
type
  Call_AppsPackageTrainedApplicationAsGzip_569852 = ref object of OpenApiRestCall_567668
proc url_AppsPackageTrainedApplicationAsGzip_569854(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/package/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/gzip")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsPackageTrainedApplicationAsGzip_569853(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_569855 = path.getOrDefault("versionId")
  valid_569855 = validateParameter(valid_569855, JString, required = true,
                                 default = nil)
  if valid_569855 != nil:
    section.add "versionId", valid_569855
  var valid_569856 = path.getOrDefault("appId")
  valid_569856 = validateParameter(valid_569856, JString, required = true,
                                 default = nil)
  if valid_569856 != nil:
    section.add "appId", valid_569856
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569857: Call_AppsPackageTrainedApplicationAsGzip_569852;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ## 
  let valid = call_569857.validator(path, query, header, formData, body)
  let scheme = call_569857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569857.url(scheme.get, call_569857.host, call_569857.base,
                         call_569857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569857, url, valid)

proc call*(call_569858: Call_AppsPackageTrainedApplicationAsGzip_569852;
          versionId: string; appId: string): Recallable =
  ## appsPackageTrainedApplicationAsGzip
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_569859 = newJObject()
  add(path_569859, "versionId", newJString(versionId))
  add(path_569859, "appId", newJString(appId))
  result = call_569858.call(path_569859, nil, nil, nil, nil)

var appsPackageTrainedApplicationAsGzip* = Call_AppsPackageTrainedApplicationAsGzip_569852(
    name: "appsPackageTrainedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/versions/{versionId}/gzip",
    validator: validate_AppsPackageTrainedApplicationAsGzip_569853, base: "",
    url: url_AppsPackageTrainedApplicationAsGzip_569854, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
