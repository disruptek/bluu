
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_AppsAdd_593972 = ref object of OpenApiRestCall_593439
proc url_AppsAdd_593974(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAdd_593973(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_593976: Call_AppsAdd_593972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new LUIS app.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_AppsAdd_593972; applicationCreateObject: JsonNode): Recallable =
  ## appsAdd
  ## Creates a new LUIS app.
  ##   applicationCreateObject: JObject (required)
  ##                          : An application containing Name, Description (optional), Culture, Usage Scenario (optional), Domain (optional) and initial version ID (optional) of the application. Default value for the version ID is "0.1". Note: the culture cannot be changed after the app is created.
  var body_593978 = newJObject()
  if applicationCreateObject != nil:
    body_593978 = applicationCreateObject
  result = call_593977.call(nil, nil, nil, nil, body_593978)

var appsAdd* = Call_AppsAdd_593972(name: "appsAdd", meth: HttpMethod.HttpPost,
                                host: "azure.local", route: "/apps/",
                                validator: validate_AppsAdd_593973, base: "",
                                url: url_AppsAdd_593974, schemes: {Scheme.Https})
type
  Call_AppsList_593661 = ref object of OpenApiRestCall_593439
proc url_AppsList_593663(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsList_593662(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593836 = query.getOrDefault("skip")
  valid_593836 = validateParameter(valid_593836, JInt, required = false,
                                 default = newJInt(0))
  if valid_593836 != nil:
    section.add "skip", valid_593836
  var valid_593837 = query.getOrDefault("take")
  valid_593837 = validateParameter(valid_593837, JInt, required = false,
                                 default = newJInt(100))
  if valid_593837 != nil:
    section.add "take", valid_593837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593860: Call_AppsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the user's applications.
  ## 
  let valid = call_593860.validator(path, query, header, formData, body)
  let scheme = call_593860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593860.url(scheme.get, call_593860.host, call_593860.base,
                         call_593860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593860, url, valid)

proc call*(call_593931: Call_AppsList_593661; skip: int = 0; take: int = 100): Recallable =
  ## appsList
  ## Lists all of the user's applications.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  var query_593932 = newJObject()
  add(query_593932, "skip", newJInt(skip))
  add(query_593932, "take", newJInt(take))
  result = call_593931.call(nil, query_593932, nil, nil, nil)

var appsList* = Call_AppsList_593661(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/apps/",
                                  validator: validate_AppsList_593662, base: "",
                                  url: url_AppsList_593663,
                                  schemes: {Scheme.Https})
type
  Call_AppsListCortanaEndpoints_593979 = ref object of OpenApiRestCall_593439
proc url_AppsListCortanaEndpoints_593981(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListCortanaEndpoints_593980(path: JsonNode; query: JsonNode;
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

proc call*(call_593982: Call_AppsListCortanaEndpoints_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_AppsListCortanaEndpoints_593979): Recallable =
  ## appsListCortanaEndpoints
  ## Gets the endpoint URLs for the prebuilt Cortana applications.
  result = call_593983.call(nil, nil, nil, nil, nil)

var appsListCortanaEndpoints* = Call_AppsListCortanaEndpoints_593979(
    name: "appsListCortanaEndpoints", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/assistants", validator: validate_AppsListCortanaEndpoints_593980,
    base: "", url: url_AppsListCortanaEndpoints_593981, schemes: {Scheme.Https})
type
  Call_AppsListSupportedCultures_593984 = ref object of OpenApiRestCall_593439
proc url_AppsListSupportedCultures_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListSupportedCultures_593985(path: JsonNode; query: JsonNode;
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

proc call*(call_593987: Call_AppsListSupportedCultures_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_AppsListSupportedCultures_593984): Recallable =
  ## appsListSupportedCultures
  ## Gets a list of supported cultures. Cultures are equivalent to the written language and locale. For example,"en-us" represents the U.S. variation of English.
  result = call_593988.call(nil, nil, nil, nil, nil)

var appsListSupportedCultures* = Call_AppsListSupportedCultures_593984(
    name: "appsListSupportedCultures", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/cultures",
    validator: validate_AppsListSupportedCultures_593985, base: "",
    url: url_AppsListSupportedCultures_593986, schemes: {Scheme.Https})
type
  Call_AppsAddCustomPrebuiltDomain_593994 = ref object of OpenApiRestCall_593439
proc url_AppsAddCustomPrebuiltDomain_593996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsAddCustomPrebuiltDomain_593995(path: JsonNode; query: JsonNode;
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

proc call*(call_593998: Call_AppsAddCustomPrebuiltDomain_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_AppsAddCustomPrebuiltDomain_593994;
          prebuiltDomainCreateObject: JsonNode): Recallable =
  ## appsAddCustomPrebuiltDomain
  ## Adds a prebuilt domain along with its intent and entity models as a new application.
  ##   prebuiltDomainCreateObject: JObject (required)
  ##                             : A prebuilt domain create object containing the name and culture of the domain.
  var body_594000 = newJObject()
  if prebuiltDomainCreateObject != nil:
    body_594000 = prebuiltDomainCreateObject
  result = call_593999.call(nil, nil, nil, nil, body_594000)

var appsAddCustomPrebuiltDomain* = Call_AppsAddCustomPrebuiltDomain_593994(
    name: "appsAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsAddCustomPrebuiltDomain_593995, base: "",
    url: url_AppsAddCustomPrebuiltDomain_593996, schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomains_593989 = ref object of OpenApiRestCall_593439
proc url_AppsListAvailableCustomPrebuiltDomains_593991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListAvailableCustomPrebuiltDomains_593990(path: JsonNode;
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

proc call*(call_593992: Call_AppsListAvailableCustomPrebuiltDomains_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available custom prebuilt domains for all cultures.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_AppsListAvailableCustomPrebuiltDomains_593989): Recallable =
  ## appsListAvailableCustomPrebuiltDomains
  ## Gets all the available custom prebuilt domains for all cultures.
  result = call_593993.call(nil, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomains* = Call_AppsListAvailableCustomPrebuiltDomains_593989(
    name: "appsListAvailableCustomPrebuiltDomains", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/customprebuiltdomains",
    validator: validate_AppsListAvailableCustomPrebuiltDomains_593990, base: "",
    url: url_AppsListAvailableCustomPrebuiltDomains_593991,
    schemes: {Scheme.Https})
type
  Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594001 = ref object of OpenApiRestCall_593439
proc url_AppsListAvailableCustomPrebuiltDomainsForCulture_594003(
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

proc validate_AppsListAvailableCustomPrebuiltDomainsForCulture_594002(
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
  var valid_594018 = path.getOrDefault("culture")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "culture", valid_594018
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the available prebuilt domains for a specific culture.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594001;
          culture: string): Recallable =
  ## appsListAvailableCustomPrebuiltDomainsForCulture
  ## Gets all the available prebuilt domains for a specific culture.
  ##   culture: string (required)
  ##          : Culture.
  var path_594021 = newJObject()
  add(path_594021, "culture", newJString(culture))
  result = call_594020.call(path_594021, nil, nil, nil, nil)

var appsListAvailableCustomPrebuiltDomainsForCulture* = Call_AppsListAvailableCustomPrebuiltDomainsForCulture_594001(
    name: "appsListAvailableCustomPrebuiltDomainsForCulture",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/customprebuiltdomains/{culture}",
    validator: validate_AppsListAvailableCustomPrebuiltDomainsForCulture_594002,
    base: "", url: url_AppsListAvailableCustomPrebuiltDomainsForCulture_594003,
    schemes: {Scheme.Https})
type
  Call_AppsListDomains_594022 = ref object of OpenApiRestCall_593439
proc url_AppsListDomains_594024(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListDomains_594023(path: JsonNode; query: JsonNode;
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

proc call*(call_594025: Call_AppsListDomains_594022; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available application domains.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_AppsListDomains_594022): Recallable =
  ## appsListDomains
  ## Gets the available application domains.
  result = call_594026.call(nil, nil, nil, nil, nil)

var appsListDomains* = Call_AppsListDomains_594022(name: "appsListDomains",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/domains",
    validator: validate_AppsListDomains_594023, base: "", url: url_AppsListDomains_594024,
    schemes: {Scheme.Https})
type
  Call_AppsImport_594027 = ref object of OpenApiRestCall_593439
proc url_AppsImport_594029(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsImport_594028(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594030 = query.getOrDefault("appName")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "appName", valid_594030
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

proc call*(call_594032: Call_AppsImport_594027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_AppsImport_594027; luisApp: JsonNode;
          appName: string = ""): Recallable =
  ## appsImport
  ## Imports an application to LUIS, the application's structure is included in the request body.
  ##   appName: string
  ##          : The application name to create. If not specified, the application name will be read from the imported object. If the application name already exists, an error is returned.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(query_594034, "appName", newJString(appName))
  if luisApp != nil:
    body_594035 = luisApp
  result = call_594033.call(nil, query_594034, nil, nil, body_594035)

var appsImport* = Call_AppsImport_594027(name: "appsImport",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/apps/import",
                                      validator: validate_AppsImport_594028,
                                      base: "", url: url_AppsImport_594029,
                                      schemes: {Scheme.Https})
type
  Call_AppsListUsageScenarios_594036 = ref object of OpenApiRestCall_593439
proc url_AppsListUsageScenarios_594038(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppsListUsageScenarios_594037(path: JsonNode; query: JsonNode;
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

proc call*(call_594039: Call_AppsListUsageScenarios_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application available usage scenarios.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_AppsListUsageScenarios_594036): Recallable =
  ## appsListUsageScenarios
  ## Gets the application available usage scenarios.
  result = call_594040.call(nil, nil, nil, nil, nil)

var appsListUsageScenarios* = Call_AppsListUsageScenarios_594036(
    name: "appsListUsageScenarios", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/usagescenarios", validator: validate_AppsListUsageScenarios_594037,
    base: "", url: url_AppsListUsageScenarios_594038, schemes: {Scheme.Https})
type
  Call_AppsUpdate_594048 = ref object of OpenApiRestCall_593439
proc url_AppsUpdate_594050(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsUpdate_594049(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594051 = path.getOrDefault("appId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "appId", valid_594051
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

proc call*(call_594053: Call_AppsUpdate_594048; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_AppsUpdate_594048; appId: string;
          applicationUpdateObject: JsonNode): Recallable =
  ## appsUpdate
  ## Updates the name or description of the application.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationUpdateObject: JObject (required)
  ##                          : A model containing Name and Description of the application.
  var path_594055 = newJObject()
  var body_594056 = newJObject()
  add(path_594055, "appId", newJString(appId))
  if applicationUpdateObject != nil:
    body_594056 = applicationUpdateObject
  result = call_594054.call(path_594055, nil, nil, nil, body_594056)

var appsUpdate* = Call_AppsUpdate_594048(name: "appsUpdate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsUpdate_594049,
                                      base: "", url: url_AppsUpdate_594050,
                                      schemes: {Scheme.Https})
type
  Call_AppsGet_594041 = ref object of OpenApiRestCall_593439
proc url_AppsGet_594043(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsGet_594042(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594044 = path.getOrDefault("appId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "appId", valid_594044
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_AppsGet_594041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the application info.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_AppsGet_594041; appId: string): Recallable =
  ## appsGet
  ## Gets the application info.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594047 = newJObject()
  add(path_594047, "appId", newJString(appId))
  result = call_594046.call(path_594047, nil, nil, nil, nil)

var appsGet* = Call_AppsGet_594041(name: "appsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apps/{appId}",
                                validator: validate_AppsGet_594042, base: "",
                                url: url_AppsGet_594043, schemes: {Scheme.Https})
type
  Call_AppsDelete_594057 = ref object of OpenApiRestCall_593439
proc url_AppsDelete_594059(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsDelete_594058(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594060 = path.getOrDefault("appId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "appId", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : A flag to indicate whether to force an operation.
  section = newJObject()
  var valid_594061 = query.getOrDefault("force")
  valid_594061 = validateParameter(valid_594061, JBool, required = false,
                                 default = newJBool(false))
  if valid_594061 != nil:
    section.add "force", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_AppsDelete_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_AppsDelete_594057; appId: string; force: bool = false): Recallable =
  ## appsDelete
  ## Deletes an application.
  ##   force: bool
  ##        : A flag to indicate whether to force an operation.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(query_594065, "force", newJBool(force))
  add(path_594064, "appId", newJString(appId))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var appsDelete* = Call_AppsDelete_594057(name: "appsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local", route: "/apps/{appId}",
                                      validator: validate_AppsDelete_594058,
                                      base: "", url: url_AppsDelete_594059,
                                      schemes: {Scheme.Https})
type
  Call_AzureAccountsAssignToApp_594074 = ref object of OpenApiRestCall_593439
proc url_AzureAccountsAssignToApp_594076(protocol: Scheme; host: string;
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

proc validate_AzureAccountsAssignToApp_594075(path: JsonNode; query: JsonNode;
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
  var valid_594077 = path.getOrDefault("appId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "appId", valid_594077
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_594078 = header.getOrDefault("Authorization")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "Authorization", valid_594078
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_AzureAccountsAssignToApp_594074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assigns an Azure account to the application.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_AzureAccountsAssignToApp_594074; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsAssignToApp
  ## Assigns an Azure account to the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594082 = newJObject()
  var body_594083 = newJObject()
  if azureAccountInfoObject != nil:
    body_594083 = azureAccountInfoObject
  add(path_594082, "appId", newJString(appId))
  result = call_594081.call(path_594082, nil, nil, nil, body_594083)

var azureAccountsAssignToApp* = Call_AzureAccountsAssignToApp_594074(
    name: "azureAccountsAssignToApp", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsAssignToApp_594075, base: "",
    url: url_AzureAccountsAssignToApp_594076, schemes: {Scheme.Https})
type
  Call_AzureAccountsGetAssigned_594066 = ref object of OpenApiRestCall_593439
proc url_AzureAccountsGetAssigned_594068(protocol: Scheme; host: string;
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

proc validate_AzureAccountsGetAssigned_594067(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("appId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "appId", valid_594069
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_594070 = header.getOrDefault("Authorization")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "Authorization", valid_594070
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_AzureAccountsGetAssigned_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_AzureAccountsGetAssigned_594066; appId: string): Recallable =
  ## azureAccountsGetAssigned
  ## Gets the LUIS Azure accounts assigned to the application for the user using his ARM token.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594073 = newJObject()
  add(path_594073, "appId", newJString(appId))
  result = call_594072.call(path_594073, nil, nil, nil, nil)

var azureAccountsGetAssigned* = Call_AzureAccountsGetAssigned_594066(
    name: "azureAccountsGetAssigned", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsGetAssigned_594067, base: "",
    url: url_AzureAccountsGetAssigned_594068, schemes: {Scheme.Https})
type
  Call_AzureAccountsRemoveFromApp_594084 = ref object of OpenApiRestCall_593439
proc url_AzureAccountsRemoveFromApp_594086(protocol: Scheme; host: string;
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

proc validate_AzureAccountsRemoveFromApp_594085(path: JsonNode; query: JsonNode;
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
  var valid_594087 = path.getOrDefault("appId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "appId", valid_594087
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Authorization: JString (required)
  ##                : The bearer authorization header to use; containing the user's ARM token used to validate Azure accounts information.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Authorization` field"
  var valid_594088 = header.getOrDefault("Authorization")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "Authorization", valid_594088
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_AzureAccountsRemoveFromApp_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes assigned Azure account from the application.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_AzureAccountsRemoveFromApp_594084; appId: string;
          azureAccountInfoObject: JsonNode = nil): Recallable =
  ## azureAccountsRemoveFromApp
  ## Removes assigned Azure account from the application.
  ##   azureAccountInfoObject: JObject
  ##                         : The Azure account information object.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594092 = newJObject()
  var body_594093 = newJObject()
  if azureAccountInfoObject != nil:
    body_594093 = azureAccountInfoObject
  add(path_594092, "appId", newJString(appId))
  result = call_594091.call(path_594092, nil, nil, nil, body_594093)

var azureAccountsRemoveFromApp* = Call_AzureAccountsRemoveFromApp_594084(
    name: "azureAccountsRemoveFromApp", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/azureaccounts",
    validator: validate_AzureAccountsRemoveFromApp_594085, base: "",
    url: url_AzureAccountsRemoveFromApp_594086, schemes: {Scheme.Https})
type
  Call_AppsListEndpoints_594094 = ref object of OpenApiRestCall_593439
proc url_AppsListEndpoints_594096(protocol: Scheme; host: string; base: string;
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

proc validate_AppsListEndpoints_594095(path: JsonNode; query: JsonNode;
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
  var valid_594097 = path.getOrDefault("appId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "appId", valid_594097
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_AppsListEndpoints_594094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the available endpoint deployment regions and URLs.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_AppsListEndpoints_594094; appId: string): Recallable =
  ## appsListEndpoints
  ## Returns the available endpoint deployment regions and URLs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594100 = newJObject()
  add(path_594100, "appId", newJString(appId))
  result = call_594099.call(path_594100, nil, nil, nil, nil)

var appsListEndpoints* = Call_AppsListEndpoints_594094(name: "appsListEndpoints",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/endpoints",
    validator: validate_AppsListEndpoints_594095, base: "",
    url: url_AppsListEndpoints_594096, schemes: {Scheme.Https})
type
  Call_PermissionsUpdate_594108 = ref object of OpenApiRestCall_593439
proc url_PermissionsUpdate_594110(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsUpdate_594109(path: JsonNode; query: JsonNode;
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
  var valid_594111 = path.getOrDefault("appId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "appId", valid_594111
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

proc call*(call_594113: Call_PermissionsUpdate_594108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_PermissionsUpdate_594108; collaborators: JsonNode;
          appId: string): Recallable =
  ## permissionsUpdate
  ## Replaces the current user access list with the new list sent in the body. If an empty list is sent, all access to other users will be removed.
  ##   collaborators: JObject (required)
  ##                : A model containing a list of user email addresses.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594115 = newJObject()
  var body_594116 = newJObject()
  if collaborators != nil:
    body_594116 = collaborators
  add(path_594115, "appId", newJString(appId))
  result = call_594114.call(path_594115, nil, nil, nil, body_594116)

var permissionsUpdate* = Call_PermissionsUpdate_594108(name: "permissionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsUpdate_594109,
    base: "", url: url_PermissionsUpdate_594110, schemes: {Scheme.Https})
type
  Call_PermissionsAdd_594117 = ref object of OpenApiRestCall_593439
proc url_PermissionsAdd_594119(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsAdd_594118(path: JsonNode; query: JsonNode;
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
  var valid_594120 = path.getOrDefault("appId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "appId", valid_594120
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

proc call*(call_594122: Call_PermissionsAdd_594117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_PermissionsAdd_594117; userToAdd: JsonNode;
          appId: string): Recallable =
  ## permissionsAdd
  ## Adds a user to the allowed list of users to access this LUIS application. Users are added using their email address.
  ##   userToAdd: JObject (required)
  ##            : A model containing the user's email address.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594124 = newJObject()
  var body_594125 = newJObject()
  if userToAdd != nil:
    body_594125 = userToAdd
  add(path_594124, "appId", newJString(appId))
  result = call_594123.call(path_594124, nil, nil, nil, body_594125)

var permissionsAdd* = Call_PermissionsAdd_594117(name: "permissionsAdd",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsAdd_594118,
    base: "", url: url_PermissionsAdd_594119, schemes: {Scheme.Https})
type
  Call_PermissionsList_594101 = ref object of OpenApiRestCall_593439
proc url_PermissionsList_594103(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsList_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("appId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "appId", valid_594104
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_PermissionsList_594101; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of user emails that have permissions to access your application.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_PermissionsList_594101; appId: string): Recallable =
  ## permissionsList
  ## Gets the list of user emails that have permissions to access your application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594107 = newJObject()
  add(path_594107, "appId", newJString(appId))
  result = call_594106.call(path_594107, nil, nil, nil, nil)

var permissionsList* = Call_PermissionsList_594101(name: "permissionsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsList_594102,
    base: "", url: url_PermissionsList_594103, schemes: {Scheme.Https})
type
  Call_PermissionsDelete_594126 = ref object of OpenApiRestCall_593439
proc url_PermissionsDelete_594128(protocol: Scheme; host: string; base: string;
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

proc validate_PermissionsDelete_594127(path: JsonNode; query: JsonNode;
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
  var valid_594129 = path.getOrDefault("appId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "appId", valid_594129
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

proc call*(call_594131: Call_PermissionsDelete_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_PermissionsDelete_594126; appId: string;
          userToDelete: JsonNode): Recallable =
  ## permissionsDelete
  ## Removes a user from the allowed list of users to access this LUIS application. Users are removed using their email address.
  ##   appId: string (required)
  ##        : The application ID.
  ##   userToDelete: JObject (required)
  ##               : A model containing the user's email address.
  var path_594133 = newJObject()
  var body_594134 = newJObject()
  add(path_594133, "appId", newJString(appId))
  if userToDelete != nil:
    body_594134 = userToDelete
  result = call_594132.call(path_594133, nil, nil, nil, body_594134)

var permissionsDelete* = Call_PermissionsDelete_594126(name: "permissionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/permissions", validator: validate_PermissionsDelete_594127,
    base: "", url: url_PermissionsDelete_594128, schemes: {Scheme.Https})
type
  Call_AppsPublish_594135 = ref object of OpenApiRestCall_593439
proc url_AppsPublish_594137(protocol: Scheme; host: string; base: string;
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

proc validate_AppsPublish_594136(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594138 = path.getOrDefault("appId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "appId", valid_594138
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

proc call*(call_594140: Call_AppsPublish_594135; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a specific version of the application.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_AppsPublish_594135;
          applicationPublishObject: JsonNode; appId: string): Recallable =
  ## appsPublish
  ## Publishes a specific version of the application.
  ##   applicationPublishObject: JObject (required)
  ##                           : The application publish object. The region is the target region that the application is published to.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594142 = newJObject()
  var body_594143 = newJObject()
  if applicationPublishObject != nil:
    body_594143 = applicationPublishObject
  add(path_594142, "appId", newJString(appId))
  result = call_594141.call(path_594142, nil, nil, nil, body_594143)

var appsPublish* = Call_AppsPublish_594135(name: "appsPublish",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local",
                                        route: "/apps/{appId}/publish",
                                        validator: validate_AppsPublish_594136,
                                        base: "", url: url_AppsPublish_594137,
                                        schemes: {Scheme.Https})
type
  Call_AppsUpdatePublishSettings_594151 = ref object of OpenApiRestCall_593439
proc url_AppsUpdatePublishSettings_594153(protocol: Scheme; host: string;
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

proc validate_AppsUpdatePublishSettings_594152(path: JsonNode; query: JsonNode;
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
  var valid_594154 = path.getOrDefault("appId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "appId", valid_594154
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

proc call*(call_594156: Call_AppsUpdatePublishSettings_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_AppsUpdatePublishSettings_594151;
          publishSettingUpdateObject: JsonNode; appId: string): Recallable =
  ## appsUpdatePublishSettings
  ## Updates the application publish settings including 'UseAllTrainingData'.
  ##   publishSettingUpdateObject: JObject (required)
  ##                             : An object containing the new publish application settings.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594158 = newJObject()
  var body_594159 = newJObject()
  if publishSettingUpdateObject != nil:
    body_594159 = publishSettingUpdateObject
  add(path_594158, "appId", newJString(appId))
  result = call_594157.call(path_594158, nil, nil, nil, body_594159)

var appsUpdatePublishSettings* = Call_AppsUpdatePublishSettings_594151(
    name: "appsUpdatePublishSettings", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/publishsettings",
    validator: validate_AppsUpdatePublishSettings_594152, base: "",
    url: url_AppsUpdatePublishSettings_594153, schemes: {Scheme.Https})
type
  Call_AppsGetPublishSettings_594144 = ref object of OpenApiRestCall_593439
proc url_AppsGetPublishSettings_594146(protocol: Scheme; host: string; base: string;
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

proc validate_AppsGetPublishSettings_594145(path: JsonNode; query: JsonNode;
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
  var valid_594147 = path.getOrDefault("appId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "appId", valid_594147
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_AppsGetPublishSettings_594144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application publish settings including 'UseAllTrainingData'.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_AppsGetPublishSettings_594144; appId: string): Recallable =
  ## appsGetPublishSettings
  ## Get the application publish settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594150 = newJObject()
  add(path_594150, "appId", newJString(appId))
  result = call_594149.call(path_594150, nil, nil, nil, nil)

var appsGetPublishSettings* = Call_AppsGetPublishSettings_594144(
    name: "appsGetPublishSettings", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/publishsettings",
    validator: validate_AppsGetPublishSettings_594145, base: "",
    url: url_AppsGetPublishSettings_594146, schemes: {Scheme.Https})
type
  Call_AppsDownloadQueryLogs_594160 = ref object of OpenApiRestCall_593439
proc url_AppsDownloadQueryLogs_594162(protocol: Scheme; host: string; base: string;
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

proc validate_AppsDownloadQueryLogs_594161(path: JsonNode; query: JsonNode;
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
  var valid_594163 = path.getOrDefault("appId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "appId", valid_594163
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_AppsDownloadQueryLogs_594160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the logs of the past month's endpoint queries for the application.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_AppsDownloadQueryLogs_594160; appId: string): Recallable =
  ## appsDownloadQueryLogs
  ## Gets the logs of the past month's endpoint queries for the application.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594166 = newJObject()
  add(path_594166, "appId", newJString(appId))
  result = call_594165.call(path_594166, nil, nil, nil, nil)

var appsDownloadQueryLogs* = Call_AppsDownloadQueryLogs_594160(
    name: "appsDownloadQueryLogs", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/querylogs", validator: validate_AppsDownloadQueryLogs_594161,
    base: "", url: url_AppsDownloadQueryLogs_594162, schemes: {Scheme.Https})
type
  Call_AppsUpdateSettings_594174 = ref object of OpenApiRestCall_593439
proc url_AppsUpdateSettings_594176(protocol: Scheme; host: string; base: string;
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

proc validate_AppsUpdateSettings_594175(path: JsonNode; query: JsonNode;
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
  var valid_594177 = path.getOrDefault("appId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "appId", valid_594177
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

proc call*(call_594179: Call_AppsUpdateSettings_594174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_AppsUpdateSettings_594174; appId: string;
          applicationSettingUpdateObject: JsonNode): Recallable =
  ## appsUpdateSettings
  ## Updates the application settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  ##   applicationSettingUpdateObject: JObject (required)
  ##                                 : An object containing the new application settings.
  var path_594181 = newJObject()
  var body_594182 = newJObject()
  add(path_594181, "appId", newJString(appId))
  if applicationSettingUpdateObject != nil:
    body_594182 = applicationSettingUpdateObject
  result = call_594180.call(path_594181, nil, nil, nil, body_594182)

var appsUpdateSettings* = Call_AppsUpdateSettings_594174(
    name: "appsUpdateSettings", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/settings", validator: validate_AppsUpdateSettings_594175,
    base: "", url: url_AppsUpdateSettings_594176, schemes: {Scheme.Https})
type
  Call_AppsGetSettings_594167 = ref object of OpenApiRestCall_593439
proc url_AppsGetSettings_594169(protocol: Scheme; host: string; base: string;
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

proc validate_AppsGetSettings_594168(path: JsonNode; query: JsonNode;
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
  var valid_594170 = path.getOrDefault("appId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "appId", valid_594170
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_AppsGetSettings_594167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the application settings including 'UseAllTrainingData'.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_AppsGetSettings_594167; appId: string): Recallable =
  ## appsGetSettings
  ## Get the application settings including 'UseAllTrainingData'.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594173 = newJObject()
  add(path_594173, "appId", newJString(appId))
  result = call_594172.call(path_594173, nil, nil, nil, nil)

var appsGetSettings* = Call_AppsGetSettings_594167(name: "appsGetSettings",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/settings",
    validator: validate_AppsGetSettings_594168, base: "", url: url_AppsGetSettings_594169,
    schemes: {Scheme.Https})
type
  Call_VersionsList_594183 = ref object of OpenApiRestCall_593439
proc url_VersionsList_594185(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsList_594184(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594186 = path.getOrDefault("appId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "appId", valid_594186
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594187 = query.getOrDefault("skip")
  valid_594187 = validateParameter(valid_594187, JInt, required = false,
                                 default = newJInt(0))
  if valid_594187 != nil:
    section.add "skip", valid_594187
  var valid_594188 = query.getOrDefault("take")
  valid_594188 = validateParameter(valid_594188, JInt, required = false,
                                 default = newJInt(100))
  if valid_594188 != nil:
    section.add "take", valid_594188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594189: Call_VersionsList_594183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of versions for this application ID.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_VersionsList_594183; appId: string; skip: int = 0;
          take: int = 100): Recallable =
  ## versionsList
  ## Gets a list of versions for this application ID.
  ##   skip: int
  ##       : The number of entries to skip. Default value is 0.
  ##   take: int
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  add(query_594192, "skip", newJInt(skip))
  add(query_594192, "take", newJInt(take))
  add(path_594191, "appId", newJString(appId))
  result = call_594190.call(path_594191, query_594192, nil, nil, nil)

var versionsList* = Call_VersionsList_594183(name: "versionsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions",
    validator: validate_VersionsList_594184, base: "", url: url_VersionsList_594185,
    schemes: {Scheme.Https})
type
  Call_VersionsImport_594193 = ref object of OpenApiRestCall_593439
proc url_VersionsImport_594195(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsImport_594194(path: JsonNode; query: JsonNode;
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
  var valid_594196 = path.getOrDefault("appId")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "appId", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   versionId: JString
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  section = newJObject()
  var valid_594197 = query.getOrDefault("versionId")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "versionId", valid_594197
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

proc call*(call_594199: Call_VersionsImport_594193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new version into a LUIS application.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_VersionsImport_594193; appId: string; luisApp: JsonNode;
          versionId: string = ""): Recallable =
  ## versionsImport
  ## Imports a new version into a LUIS application.
  ##   versionId: string
  ##            : The new versionId to import. If not specified, the versionId will be read from the imported object.
  ##   appId: string (required)
  ##        : The application ID.
  ##   luisApp: JObject (required)
  ##          : A LUIS application structure.
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(query_594202, "versionId", newJString(versionId))
  add(path_594201, "appId", newJString(appId))
  if luisApp != nil:
    body_594203 = luisApp
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var versionsImport* = Call_VersionsImport_594193(name: "versionsImport",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/import", validator: validate_VersionsImport_594194,
    base: "", url: url_VersionsImport_594195, schemes: {Scheme.Https})
type
  Call_VersionsUpdate_594212 = ref object of OpenApiRestCall_593439
proc url_VersionsUpdate_594214(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsUpdate_594213(path: JsonNode; query: JsonNode;
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
  var valid_594215 = path.getOrDefault("versionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "versionId", valid_594215
  var valid_594216 = path.getOrDefault("appId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "appId", valid_594216
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

proc call*(call_594218: Call_VersionsUpdate_594212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or description of the application version.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_VersionsUpdate_594212; versionId: string; appId: string;
          versionUpdateObject: JsonNode): Recallable =
  ## versionsUpdate
  ## Updates the name or description of the application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionUpdateObject: JObject (required)
  ##                      : A model containing Name and Description of the application.
  var path_594220 = newJObject()
  var body_594221 = newJObject()
  add(path_594220, "versionId", newJString(versionId))
  add(path_594220, "appId", newJString(appId))
  if versionUpdateObject != nil:
    body_594221 = versionUpdateObject
  result = call_594219.call(path_594220, nil, nil, nil, body_594221)

var versionsUpdate* = Call_VersionsUpdate_594212(name: "versionsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsUpdate_594213, base: "", url: url_VersionsUpdate_594214,
    schemes: {Scheme.Https})
type
  Call_VersionsGet_594204 = ref object of OpenApiRestCall_593439
proc url_VersionsGet_594206(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsGet_594205(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594207 = path.getOrDefault("versionId")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "versionId", valid_594207
  var valid_594208 = path.getOrDefault("appId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "appId", valid_594208
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594209: Call_VersionsGet_594204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_VersionsGet_594204; versionId: string; appId: string): Recallable =
  ## versionsGet
  ## Gets the version information such as date created, last modified date, endpoint URL, count of intents and entities, training and publishing status.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594211 = newJObject()
  add(path_594211, "versionId", newJString(versionId))
  add(path_594211, "appId", newJString(appId))
  result = call_594210.call(path_594211, nil, nil, nil, nil)

var versionsGet* = Call_VersionsGet_594204(name: "versionsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/",
                                        validator: validate_VersionsGet_594205,
                                        base: "", url: url_VersionsGet_594206,
                                        schemes: {Scheme.Https})
type
  Call_VersionsDelete_594222 = ref object of OpenApiRestCall_593439
proc url_VersionsDelete_594224(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsDelete_594223(path: JsonNode; query: JsonNode;
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
  var valid_594225 = path.getOrDefault("versionId")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "versionId", valid_594225
  var valid_594226 = path.getOrDefault("appId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "appId", valid_594226
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_VersionsDelete_594222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an application version.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_VersionsDelete_594222; versionId: string; appId: string): Recallable =
  ## versionsDelete
  ## Deletes an application version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594229 = newJObject()
  add(path_594229, "versionId", newJString(versionId))
  add(path_594229, "appId", newJString(appId))
  result = call_594228.call(path_594229, nil, nil, nil, nil)

var versionsDelete* = Call_VersionsDelete_594222(name: "versionsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/",
    validator: validate_VersionsDelete_594223, base: "", url: url_VersionsDelete_594224,
    schemes: {Scheme.Https})
type
  Call_VersionsClone_594230 = ref object of OpenApiRestCall_593439
proc url_VersionsClone_594232(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsClone_594231(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594233 = path.getOrDefault("versionId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "versionId", valid_594233
  var valid_594234 = path.getOrDefault("appId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "appId", valid_594234
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

proc call*(call_594236: Call_VersionsClone_594230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version from the selected version.
  ## 
  let valid = call_594236.validator(path, query, header, formData, body)
  let scheme = call_594236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594236.url(scheme.get, call_594236.host, call_594236.base,
                         call_594236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594236, url, valid)

proc call*(call_594237: Call_VersionsClone_594230; versionId: string; appId: string;
          versionCloneObject: JsonNode): Recallable =
  ## versionsClone
  ## Creates a new version from the selected version.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionCloneObject: JObject (required)
  ##                     : A model containing the new version ID.
  var path_594238 = newJObject()
  var body_594239 = newJObject()
  add(path_594238, "versionId", newJString(versionId))
  add(path_594238, "appId", newJString(appId))
  if versionCloneObject != nil:
    body_594239 = versionCloneObject
  result = call_594237.call(path_594238, nil, nil, nil, body_594239)

var versionsClone* = Call_VersionsClone_594230(name: "versionsClone",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/clone",
    validator: validate_VersionsClone_594231, base: "", url: url_VersionsClone_594232,
    schemes: {Scheme.Https})
type
  Call_ModelAddClosedList_594251 = ref object of OpenApiRestCall_593439
proc url_ModelAddClosedList_594253(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddClosedList_594252(path: JsonNode; query: JsonNode;
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
  var valid_594254 = path.getOrDefault("versionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "versionId", valid_594254
  var valid_594255 = path.getOrDefault("appId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "appId", valid_594255
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

proc call*(call_594257: Call_ModelAddClosedList_594251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list entity model to a version of the application.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_ModelAddClosedList_594251; versionId: string;
          appId: string; closedListModelCreateObject: JsonNode): Recallable =
  ## modelAddClosedList
  ## Adds a list entity model to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   closedListModelCreateObject: JObject (required)
  ##                              : A model containing the name and words for the new list entity extractor.
  var path_594259 = newJObject()
  var body_594260 = newJObject()
  add(path_594259, "versionId", newJString(versionId))
  add(path_594259, "appId", newJString(appId))
  if closedListModelCreateObject != nil:
    body_594260 = closedListModelCreateObject
  result = call_594258.call(path_594259, nil, nil, nil, body_594260)

var modelAddClosedList* = Call_ModelAddClosedList_594251(
    name: "modelAddClosedList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelAddClosedList_594252, base: "",
    url: url_ModelAddClosedList_594253, schemes: {Scheme.Https})
type
  Call_ModelListClosedLists_594240 = ref object of OpenApiRestCall_593439
proc url_ModelListClosedLists_594242(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListClosedLists_594241(path: JsonNode; query: JsonNode;
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
  var valid_594243 = path.getOrDefault("versionId")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "versionId", valid_594243
  var valid_594244 = path.getOrDefault("appId")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "appId", valid_594244
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594245 = query.getOrDefault("skip")
  valid_594245 = validateParameter(valid_594245, JInt, required = false,
                                 default = newJInt(0))
  if valid_594245 != nil:
    section.add "skip", valid_594245
  var valid_594246 = query.getOrDefault("take")
  valid_594246 = validateParameter(valid_594246, JInt, required = false,
                                 default = newJInt(100))
  if valid_594246 != nil:
    section.add "take", valid_594246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_ModelListClosedLists_594240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the list entity models in a version of the application.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_ModelListClosedLists_594240; versionId: string;
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
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  add(path_594249, "versionId", newJString(versionId))
  add(query_594250, "skip", newJInt(skip))
  add(query_594250, "take", newJInt(take))
  add(path_594249, "appId", newJString(appId))
  result = call_594248.call(path_594249, query_594250, nil, nil, nil)

var modelListClosedLists* = Call_ModelListClosedLists_594240(
    name: "modelListClosedLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists",
    validator: validate_ModelListClosedLists_594241, base: "",
    url: url_ModelListClosedLists_594242, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedList_594270 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateClosedList_594272(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateClosedList_594271(path: JsonNode; query: JsonNode;
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
  var valid_594273 = path.getOrDefault("versionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "versionId", valid_594273
  var valid_594274 = path.getOrDefault("appId")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "appId", valid_594274
  var valid_594275 = path.getOrDefault("clEntityId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "clEntityId", valid_594275
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

proc call*(call_594277: Call_ModelUpdateClosedList_594270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the list entity in a version of the application.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_ModelUpdateClosedList_594270; versionId: string;
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
  var path_594279 = newJObject()
  var body_594280 = newJObject()
  add(path_594279, "versionId", newJString(versionId))
  if closedListModelUpdateObject != nil:
    body_594280 = closedListModelUpdateObject
  add(path_594279, "appId", newJString(appId))
  add(path_594279, "clEntityId", newJString(clEntityId))
  result = call_594278.call(path_594279, nil, nil, nil, body_594280)

var modelUpdateClosedList* = Call_ModelUpdateClosedList_594270(
    name: "modelUpdateClosedList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelUpdateClosedList_594271, base: "",
    url: url_ModelUpdateClosedList_594272, schemes: {Scheme.Https})
type
  Call_ModelGetClosedList_594261 = ref object of OpenApiRestCall_593439
proc url_ModelGetClosedList_594263(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetClosedList_594262(path: JsonNode; query: JsonNode;
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
  var valid_594264 = path.getOrDefault("versionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "versionId", valid_594264
  var valid_594265 = path.getOrDefault("appId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "appId", valid_594265
  var valid_594266 = path.getOrDefault("clEntityId")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "clEntityId", valid_594266
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_ModelGetClosedList_594261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a list entity in a version of the application.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_ModelGetClosedList_594261; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelGetClosedList
  ## Gets information about a list entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list model ID.
  var path_594269 = newJObject()
  add(path_594269, "versionId", newJString(versionId))
  add(path_594269, "appId", newJString(appId))
  add(path_594269, "clEntityId", newJString(clEntityId))
  result = call_594268.call(path_594269, nil, nil, nil, nil)

var modelGetClosedList* = Call_ModelGetClosedList_594261(
    name: "modelGetClosedList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelGetClosedList_594262, base: "",
    url: url_ModelGetClosedList_594263, schemes: {Scheme.Https})
type
  Call_ModelPatchClosedList_594290 = ref object of OpenApiRestCall_593439
proc url_ModelPatchClosedList_594292(protocol: Scheme; host: string; base: string;
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

proc validate_ModelPatchClosedList_594291(path: JsonNode; query: JsonNode;
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
  var valid_594293 = path.getOrDefault("versionId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "versionId", valid_594293
  var valid_594294 = path.getOrDefault("appId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "appId", valid_594294
  var valid_594295 = path.getOrDefault("clEntityId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "clEntityId", valid_594295
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

proc call*(call_594297: Call_ModelPatchClosedList_594290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of sublists to an existing list entity in a version of the application.
  ## 
  let valid = call_594297.validator(path, query, header, formData, body)
  let scheme = call_594297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594297.url(scheme.get, call_594297.host, call_594297.base,
                         call_594297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594297, url, valid)

proc call*(call_594298: Call_ModelPatchClosedList_594290; versionId: string;
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
  var path_594299 = newJObject()
  var body_594300 = newJObject()
  add(path_594299, "versionId", newJString(versionId))
  add(path_594299, "appId", newJString(appId))
  add(path_594299, "clEntityId", newJString(clEntityId))
  if closedListModelPatchObject != nil:
    body_594300 = closedListModelPatchObject
  result = call_594298.call(path_594299, nil, nil, nil, body_594300)

var modelPatchClosedList* = Call_ModelPatchClosedList_594290(
    name: "modelPatchClosedList", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelPatchClosedList_594291, base: "",
    url: url_ModelPatchClosedList_594292, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedList_594281 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteClosedList_594283(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteClosedList_594282(path: JsonNode; query: JsonNode;
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
  var valid_594284 = path.getOrDefault("versionId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "versionId", valid_594284
  var valid_594285 = path.getOrDefault("appId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "appId", valid_594285
  var valid_594286 = path.getOrDefault("clEntityId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "clEntityId", valid_594286
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594287: Call_ModelDeleteClosedList_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list entity model from a version of the application.
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_ModelDeleteClosedList_594281; versionId: string;
          appId: string; clEntityId: string): Recallable =
  ## modelDeleteClosedList
  ## Deletes a list entity model from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   clEntityId: string (required)
  ##             : The list entity model ID.
  var path_594289 = newJObject()
  add(path_594289, "versionId", newJString(versionId))
  add(path_594289, "appId", newJString(appId))
  add(path_594289, "clEntityId", newJString(clEntityId))
  result = call_594288.call(path_594289, nil, nil, nil, nil)

var modelDeleteClosedList* = Call_ModelDeleteClosedList_594281(
    name: "modelDeleteClosedList", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}",
    validator: validate_ModelDeleteClosedList_594282, base: "",
    url: url_ModelDeleteClosedList_594283, schemes: {Scheme.Https})
type
  Call_ModelAddSubList_594301 = ref object of OpenApiRestCall_593439
proc url_ModelAddSubList_594303(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddSubList_594302(path: JsonNode; query: JsonNode;
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
  var valid_594304 = path.getOrDefault("versionId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "versionId", valid_594304
  var valid_594305 = path.getOrDefault("appId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "appId", valid_594305
  var valid_594306 = path.getOrDefault("clEntityId")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "clEntityId", valid_594306
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

proc call*(call_594308: Call_ModelAddSubList_594301; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a sublist to an existing list entity in a version of the application.
  ## 
  let valid = call_594308.validator(path, query, header, formData, body)
  let scheme = call_594308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594308.url(scheme.get, call_594308.host, call_594308.base,
                         call_594308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594308, url, valid)

proc call*(call_594309: Call_ModelAddSubList_594301; versionId: string;
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
  var path_594310 = newJObject()
  var body_594311 = newJObject()
  add(path_594310, "versionId", newJString(versionId))
  if wordListCreateObject != nil:
    body_594311 = wordListCreateObject
  add(path_594310, "appId", newJString(appId))
  add(path_594310, "clEntityId", newJString(clEntityId))
  result = call_594309.call(path_594310, nil, nil, nil, body_594311)

var modelAddSubList* = Call_ModelAddSubList_594301(name: "modelAddSubList",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists",
    validator: validate_ModelAddSubList_594302, base: "", url: url_ModelAddSubList_594303,
    schemes: {Scheme.Https})
type
  Call_ModelUpdateSubList_594312 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateSubList_594314(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateSubList_594313(path: JsonNode; query: JsonNode;
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
  var valid_594315 = path.getOrDefault("versionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "versionId", valid_594315
  var valid_594316 = path.getOrDefault("appId")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "appId", valid_594316
  var valid_594317 = path.getOrDefault("clEntityId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "clEntityId", valid_594317
  var valid_594318 = path.getOrDefault("subListId")
  valid_594318 = validateParameter(valid_594318, JInt, required = true, default = nil)
  if valid_594318 != nil:
    section.add "subListId", valid_594318
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

proc call*(call_594320: Call_ModelUpdateSubList_594312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one of the list entity's sublists in a version of the application.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_ModelUpdateSubList_594312; versionId: string;
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
  var path_594322 = newJObject()
  var body_594323 = newJObject()
  add(path_594322, "versionId", newJString(versionId))
  if wordListBaseUpdateObject != nil:
    body_594323 = wordListBaseUpdateObject
  add(path_594322, "appId", newJString(appId))
  add(path_594322, "clEntityId", newJString(clEntityId))
  add(path_594322, "subListId", newJInt(subListId))
  result = call_594321.call(path_594322, nil, nil, nil, body_594323)

var modelUpdateSubList* = Call_ModelUpdateSubList_594312(
    name: "modelUpdateSubList", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelUpdateSubList_594313, base: "",
    url: url_ModelUpdateSubList_594314, schemes: {Scheme.Https})
type
  Call_ModelDeleteSubList_594324 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteSubList_594326(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteSubList_594325(path: JsonNode; query: JsonNode;
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
  var valid_594327 = path.getOrDefault("versionId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "versionId", valid_594327
  var valid_594328 = path.getOrDefault("appId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "appId", valid_594328
  var valid_594329 = path.getOrDefault("clEntityId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "clEntityId", valid_594329
  var valid_594330 = path.getOrDefault("subListId")
  valid_594330 = validateParameter(valid_594330, JInt, required = true, default = nil)
  if valid_594330 != nil:
    section.add "subListId", valid_594330
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594331: Call_ModelDeleteSubList_594324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a sublist of a specific list entity model from a version of the application.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_ModelDeleteSubList_594324; versionId: string;
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
  var path_594333 = newJObject()
  add(path_594333, "versionId", newJString(versionId))
  add(path_594333, "appId", newJString(appId))
  add(path_594333, "clEntityId", newJString(clEntityId))
  add(path_594333, "subListId", newJInt(subListId))
  result = call_594332.call(path_594333, nil, nil, nil, nil)

var modelDeleteSubList* = Call_ModelDeleteSubList_594324(
    name: "modelDeleteSubList", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{clEntityId}/sublists/{subListId}",
    validator: validate_ModelDeleteSubList_594325, base: "",
    url: url_ModelDeleteSubList_594326, schemes: {Scheme.Https})
type
  Call_ModelCreateClosedListEntityRole_594343 = ref object of OpenApiRestCall_593439
proc url_ModelCreateClosedListEntityRole_594345(protocol: Scheme; host: string;
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

proc validate_ModelCreateClosedListEntityRole_594344(path: JsonNode;
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
  var valid_594346 = path.getOrDefault("versionId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "versionId", valid_594346
  var valid_594347 = path.getOrDefault("entityId")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "entityId", valid_594347
  var valid_594348 = path.getOrDefault("appId")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "appId", valid_594348
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

proc call*(call_594350: Call_ModelCreateClosedListEntityRole_594343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594350.validator(path, query, header, formData, body)
  let scheme = call_594350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594350.url(scheme.get, call_594350.host, call_594350.base,
                         call_594350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594350, url, valid)

proc call*(call_594351: Call_ModelCreateClosedListEntityRole_594343;
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
  var path_594352 = newJObject()
  var body_594353 = newJObject()
  add(path_594352, "versionId", newJString(versionId))
  add(path_594352, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_594353 = entityRoleCreateObject
  add(path_594352, "appId", newJString(appId))
  result = call_594351.call(path_594352, nil, nil, nil, body_594353)

var modelCreateClosedListEntityRole* = Call_ModelCreateClosedListEntityRole_594343(
    name: "modelCreateClosedListEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelCreateClosedListEntityRole_594344, base: "",
    url: url_ModelCreateClosedListEntityRole_594345, schemes: {Scheme.Https})
type
  Call_ModelListClosedListEntityRoles_594334 = ref object of OpenApiRestCall_593439
proc url_ModelListClosedListEntityRoles_594336(protocol: Scheme; host: string;
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

proc validate_ModelListClosedListEntityRoles_594335(path: JsonNode;
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
  var valid_594337 = path.getOrDefault("versionId")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "versionId", valid_594337
  var valid_594338 = path.getOrDefault("entityId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "entityId", valid_594338
  var valid_594339 = path.getOrDefault("appId")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "appId", valid_594339
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594340: Call_ModelListClosedListEntityRoles_594334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_ModelListClosedListEntityRoles_594334;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListClosedListEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_594342 = newJObject()
  add(path_594342, "versionId", newJString(versionId))
  add(path_594342, "entityId", newJString(entityId))
  add(path_594342, "appId", newJString(appId))
  result = call_594341.call(path_594342, nil, nil, nil, nil)

var modelListClosedListEntityRoles* = Call_ModelListClosedListEntityRoles_594334(
    name: "modelListClosedListEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles",
    validator: validate_ModelListClosedListEntityRoles_594335, base: "",
    url: url_ModelListClosedListEntityRoles_594336, schemes: {Scheme.Https})
type
  Call_ModelUpdateClosedListEntityRole_594364 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateClosedListEntityRole_594366(protocol: Scheme; host: string;
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

proc validate_ModelUpdateClosedListEntityRole_594365(path: JsonNode;
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
  var valid_594367 = path.getOrDefault("versionId")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "versionId", valid_594367
  var valid_594368 = path.getOrDefault("entityId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "entityId", valid_594368
  var valid_594369 = path.getOrDefault("appId")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "appId", valid_594369
  var valid_594370 = path.getOrDefault("roleId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "roleId", valid_594370
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

proc call*(call_594372: Call_ModelUpdateClosedListEntityRole_594364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_ModelUpdateClosedListEntityRole_594364;
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
  var path_594374 = newJObject()
  var body_594375 = newJObject()
  add(path_594374, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_594375 = entityRoleUpdateObject
  add(path_594374, "entityId", newJString(entityId))
  add(path_594374, "appId", newJString(appId))
  add(path_594374, "roleId", newJString(roleId))
  result = call_594373.call(path_594374, nil, nil, nil, body_594375)

var modelUpdateClosedListEntityRole* = Call_ModelUpdateClosedListEntityRole_594364(
    name: "modelUpdateClosedListEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateClosedListEntityRole_594365, base: "",
    url: url_ModelUpdateClosedListEntityRole_594366, schemes: {Scheme.Https})
type
  Call_ModelGetClosedListEntityRole_594354 = ref object of OpenApiRestCall_593439
proc url_ModelGetClosedListEntityRole_594356(protocol: Scheme; host: string;
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

proc validate_ModelGetClosedListEntityRole_594355(path: JsonNode; query: JsonNode;
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
  var valid_594357 = path.getOrDefault("versionId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "versionId", valid_594357
  var valid_594358 = path.getOrDefault("entityId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "entityId", valid_594358
  var valid_594359 = path.getOrDefault("appId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "appId", valid_594359
  var valid_594360 = path.getOrDefault("roleId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "roleId", valid_594360
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_ModelGetClosedListEntityRole_594354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_ModelGetClosedListEntityRole_594354;
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
  var path_594363 = newJObject()
  add(path_594363, "versionId", newJString(versionId))
  add(path_594363, "entityId", newJString(entityId))
  add(path_594363, "appId", newJString(appId))
  add(path_594363, "roleId", newJString(roleId))
  result = call_594362.call(path_594363, nil, nil, nil, nil)

var modelGetClosedListEntityRole* = Call_ModelGetClosedListEntityRole_594354(
    name: "modelGetClosedListEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelGetClosedListEntityRole_594355, base: "",
    url: url_ModelGetClosedListEntityRole_594356, schemes: {Scheme.Https})
type
  Call_ModelDeleteClosedListEntityRole_594376 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteClosedListEntityRole_594378(protocol: Scheme; host: string;
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

proc validate_ModelDeleteClosedListEntityRole_594377(path: JsonNode;
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
  var valid_594379 = path.getOrDefault("versionId")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "versionId", valid_594379
  var valid_594380 = path.getOrDefault("entityId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "entityId", valid_594380
  var valid_594381 = path.getOrDefault("appId")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "appId", valid_594381
  var valid_594382 = path.getOrDefault("roleId")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "roleId", valid_594382
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594383: Call_ModelDeleteClosedListEntityRole_594376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594383.validator(path, query, header, formData, body)
  let scheme = call_594383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594383.url(scheme.get, call_594383.host, call_594383.base,
                         call_594383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594383, url, valid)

proc call*(call_594384: Call_ModelDeleteClosedListEntityRole_594376;
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
  var path_594385 = newJObject()
  add(path_594385, "versionId", newJString(versionId))
  add(path_594385, "entityId", newJString(entityId))
  add(path_594385, "appId", newJString(appId))
  add(path_594385, "roleId", newJString(roleId))
  result = call_594384.call(path_594385, nil, nil, nil, nil)

var modelDeleteClosedListEntityRole* = Call_ModelDeleteClosedListEntityRole_594376(
    name: "modelDeleteClosedListEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/closedlists/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteClosedListEntityRole_594377, base: "",
    url: url_ModelDeleteClosedListEntityRole_594378, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntity_594397 = ref object of OpenApiRestCall_593439
proc url_ModelAddCompositeEntity_594399(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddCompositeEntity_594398(path: JsonNode; query: JsonNode;
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
  var valid_594400 = path.getOrDefault("versionId")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "versionId", valid_594400
  var valid_594401 = path.getOrDefault("appId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "appId", valid_594401
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

proc call*(call_594403: Call_ModelAddCompositeEntity_594397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a composite entity extractor to a version of the application.
  ## 
  let valid = call_594403.validator(path, query, header, formData, body)
  let scheme = call_594403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594403.url(scheme.get, call_594403.host, call_594403.base,
                         call_594403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594403, url, valid)

proc call*(call_594404: Call_ModelAddCompositeEntity_594397; versionId: string;
          appId: string; compositeModelCreateObject: JsonNode): Recallable =
  ## modelAddCompositeEntity
  ## Adds a composite entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   compositeModelCreateObject: JObject (required)
  ##                             : A model containing the name and children of the new entity extractor.
  var path_594405 = newJObject()
  var body_594406 = newJObject()
  add(path_594405, "versionId", newJString(versionId))
  add(path_594405, "appId", newJString(appId))
  if compositeModelCreateObject != nil:
    body_594406 = compositeModelCreateObject
  result = call_594404.call(path_594405, nil, nil, nil, body_594406)

var modelAddCompositeEntity* = Call_ModelAddCompositeEntity_594397(
    name: "modelAddCompositeEntity", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelAddCompositeEntity_594398, base: "",
    url: url_ModelAddCompositeEntity_594399, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntities_594386 = ref object of OpenApiRestCall_593439
proc url_ModelListCompositeEntities_594388(protocol: Scheme; host: string;
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

proc validate_ModelListCompositeEntities_594387(path: JsonNode; query: JsonNode;
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
  var valid_594389 = path.getOrDefault("versionId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "versionId", valid_594389
  var valid_594390 = path.getOrDefault("appId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "appId", valid_594390
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594391 = query.getOrDefault("skip")
  valid_594391 = validateParameter(valid_594391, JInt, required = false,
                                 default = newJInt(0))
  if valid_594391 != nil:
    section.add "skip", valid_594391
  var valid_594392 = query.getOrDefault("take")
  valid_594392 = validateParameter(valid_594392, JInt, required = false,
                                 default = newJInt(100))
  if valid_594392 != nil:
    section.add "take", valid_594392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594393: Call_ModelListCompositeEntities_594386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the composite entity models in a version of the application.
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_ModelListCompositeEntities_594386; versionId: string;
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
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  add(path_594395, "versionId", newJString(versionId))
  add(query_594396, "skip", newJInt(skip))
  add(query_594396, "take", newJInt(take))
  add(path_594395, "appId", newJString(appId))
  result = call_594394.call(path_594395, query_594396, nil, nil, nil)

var modelListCompositeEntities* = Call_ModelListCompositeEntities_594386(
    name: "modelListCompositeEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities",
    validator: validate_ModelListCompositeEntities_594387, base: "",
    url: url_ModelListCompositeEntities_594388, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntity_594416 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateCompositeEntity_594418(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCompositeEntity_594417(path: JsonNode; query: JsonNode;
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
  var valid_594419 = path.getOrDefault("versionId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "versionId", valid_594419
  var valid_594420 = path.getOrDefault("appId")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "appId", valid_594420
  var valid_594421 = path.getOrDefault("cEntityId")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "cEntityId", valid_594421
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

proc call*(call_594423: Call_ModelUpdateCompositeEntity_594416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a composite entity in a version of the application.
  ## 
  let valid = call_594423.validator(path, query, header, formData, body)
  let scheme = call_594423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594423.url(scheme.get, call_594423.host, call_594423.base,
                         call_594423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594423, url, valid)

proc call*(call_594424: Call_ModelUpdateCompositeEntity_594416; versionId: string;
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
  var path_594425 = newJObject()
  var body_594426 = newJObject()
  add(path_594425, "versionId", newJString(versionId))
  if compositeModelUpdateObject != nil:
    body_594426 = compositeModelUpdateObject
  add(path_594425, "appId", newJString(appId))
  add(path_594425, "cEntityId", newJString(cEntityId))
  result = call_594424.call(path_594425, nil, nil, nil, body_594426)

var modelUpdateCompositeEntity* = Call_ModelUpdateCompositeEntity_594416(
    name: "modelUpdateCompositeEntity", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelUpdateCompositeEntity_594417, base: "",
    url: url_ModelUpdateCompositeEntity_594418, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntity_594407 = ref object of OpenApiRestCall_593439
proc url_ModelGetCompositeEntity_594409(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetCompositeEntity_594408(path: JsonNode; query: JsonNode;
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
  var valid_594410 = path.getOrDefault("versionId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "versionId", valid_594410
  var valid_594411 = path.getOrDefault("appId")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "appId", valid_594411
  var valid_594412 = path.getOrDefault("cEntityId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "cEntityId", valid_594412
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594413: Call_ModelGetCompositeEntity_594407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a composite entity in a version of the application.
  ## 
  let valid = call_594413.validator(path, query, header, formData, body)
  let scheme = call_594413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594413.url(scheme.get, call_594413.host, call_594413.base,
                         call_594413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594413, url, valid)

proc call*(call_594414: Call_ModelGetCompositeEntity_594407; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelGetCompositeEntity
  ## Gets information about a composite entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_594415 = newJObject()
  add(path_594415, "versionId", newJString(versionId))
  add(path_594415, "appId", newJString(appId))
  add(path_594415, "cEntityId", newJString(cEntityId))
  result = call_594414.call(path_594415, nil, nil, nil, nil)

var modelGetCompositeEntity* = Call_ModelGetCompositeEntity_594407(
    name: "modelGetCompositeEntity", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelGetCompositeEntity_594408, base: "",
    url: url_ModelGetCompositeEntity_594409, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntity_594427 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteCompositeEntity_594429(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntity_594428(path: JsonNode; query: JsonNode;
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
  var valid_594430 = path.getOrDefault("versionId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "versionId", valid_594430
  var valid_594431 = path.getOrDefault("appId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "appId", valid_594431
  var valid_594432 = path.getOrDefault("cEntityId")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "cEntityId", valid_594432
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594433: Call_ModelDeleteCompositeEntity_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a composite entity from a version of the application.
  ## 
  let valid = call_594433.validator(path, query, header, formData, body)
  let scheme = call_594433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594433.url(scheme.get, call_594433.host, call_594433.base,
                         call_594433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594433, url, valid)

proc call*(call_594434: Call_ModelDeleteCompositeEntity_594427; versionId: string;
          appId: string; cEntityId: string): Recallable =
  ## modelDeleteCompositeEntity
  ## Deletes a composite entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_594435 = newJObject()
  add(path_594435, "versionId", newJString(versionId))
  add(path_594435, "appId", newJString(appId))
  add(path_594435, "cEntityId", newJString(cEntityId))
  result = call_594434.call(path_594435, nil, nil, nil, nil)

var modelDeleteCompositeEntity* = Call_ModelDeleteCompositeEntity_594427(
    name: "modelDeleteCompositeEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}",
    validator: validate_ModelDeleteCompositeEntity_594428, base: "",
    url: url_ModelDeleteCompositeEntity_594429, schemes: {Scheme.Https})
type
  Call_ModelAddCompositeEntityChild_594436 = ref object of OpenApiRestCall_593439
proc url_ModelAddCompositeEntityChild_594438(protocol: Scheme; host: string;
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

proc validate_ModelAddCompositeEntityChild_594437(path: JsonNode; query: JsonNode;
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
  var valid_594439 = path.getOrDefault("versionId")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "versionId", valid_594439
  var valid_594440 = path.getOrDefault("appId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "appId", valid_594440
  var valid_594441 = path.getOrDefault("cEntityId")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "cEntityId", valid_594441
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

proc call*(call_594443: Call_ModelAddCompositeEntityChild_594436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a single child in an existing composite entity model in a version of the application.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_ModelAddCompositeEntityChild_594436;
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
  var path_594445 = newJObject()
  var body_594446 = newJObject()
  add(path_594445, "versionId", newJString(versionId))
  if compositeChildModelCreateObject != nil:
    body_594446 = compositeChildModelCreateObject
  add(path_594445, "appId", newJString(appId))
  add(path_594445, "cEntityId", newJString(cEntityId))
  result = call_594444.call(path_594445, nil, nil, nil, body_594446)

var modelAddCompositeEntityChild* = Call_ModelAddCompositeEntityChild_594436(
    name: "modelAddCompositeEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children",
    validator: validate_ModelAddCompositeEntityChild_594437, base: "",
    url: url_ModelAddCompositeEntityChild_594438, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityChild_594447 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteCompositeEntityChild_594449(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntityChild_594448(path: JsonNode;
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
  var valid_594450 = path.getOrDefault("versionId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "versionId", valid_594450
  var valid_594451 = path.getOrDefault("cChildId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "cChildId", valid_594451
  var valid_594452 = path.getOrDefault("appId")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "appId", valid_594452
  var valid_594453 = path.getOrDefault("cEntityId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "cEntityId", valid_594453
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594454: Call_ModelDeleteCompositeEntityChild_594447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite entity extractor child from a version of the application.
  ## 
  let valid = call_594454.validator(path, query, header, formData, body)
  let scheme = call_594454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594454.url(scheme.get, call_594454.host, call_594454.base,
                         call_594454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594454, url, valid)

proc call*(call_594455: Call_ModelDeleteCompositeEntityChild_594447;
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
  var path_594456 = newJObject()
  add(path_594456, "versionId", newJString(versionId))
  add(path_594456, "cChildId", newJString(cChildId))
  add(path_594456, "appId", newJString(appId))
  add(path_594456, "cEntityId", newJString(cEntityId))
  result = call_594455.call(path_594456, nil, nil, nil, nil)

var modelDeleteCompositeEntityChild* = Call_ModelDeleteCompositeEntityChild_594447(
    name: "modelDeleteCompositeEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/children/{cChildId}",
    validator: validate_ModelDeleteCompositeEntityChild_594448, base: "",
    url: url_ModelDeleteCompositeEntityChild_594449, schemes: {Scheme.Https})
type
  Call_ModelCreateCompositeEntityRole_594466 = ref object of OpenApiRestCall_593439
proc url_ModelCreateCompositeEntityRole_594468(protocol: Scheme; host: string;
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

proc validate_ModelCreateCompositeEntityRole_594467(path: JsonNode;
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
  var valid_594469 = path.getOrDefault("versionId")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "versionId", valid_594469
  var valid_594470 = path.getOrDefault("appId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "appId", valid_594470
  var valid_594471 = path.getOrDefault("cEntityId")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "cEntityId", valid_594471
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

proc call*(call_594473: Call_ModelCreateCompositeEntityRole_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_ModelCreateCompositeEntityRole_594466;
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
  var path_594475 = newJObject()
  var body_594476 = newJObject()
  add(path_594475, "versionId", newJString(versionId))
  if entityRoleCreateObject != nil:
    body_594476 = entityRoleCreateObject
  add(path_594475, "appId", newJString(appId))
  add(path_594475, "cEntityId", newJString(cEntityId))
  result = call_594474.call(path_594475, nil, nil, nil, body_594476)

var modelCreateCompositeEntityRole* = Call_ModelCreateCompositeEntityRole_594466(
    name: "modelCreateCompositeEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelCreateCompositeEntityRole_594467, base: "",
    url: url_ModelCreateCompositeEntityRole_594468, schemes: {Scheme.Https})
type
  Call_ModelListCompositeEntityRoles_594457 = ref object of OpenApiRestCall_593439
proc url_ModelListCompositeEntityRoles_594459(protocol: Scheme; host: string;
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

proc validate_ModelListCompositeEntityRoles_594458(path: JsonNode; query: JsonNode;
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
  var valid_594460 = path.getOrDefault("versionId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "versionId", valid_594460
  var valid_594461 = path.getOrDefault("appId")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "appId", valid_594461
  var valid_594462 = path.getOrDefault("cEntityId")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "cEntityId", valid_594462
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594463: Call_ModelListCompositeEntityRoles_594457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594463.validator(path, query, header, formData, body)
  let scheme = call_594463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594463.url(scheme.get, call_594463.host, call_594463.base,
                         call_594463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594463, url, valid)

proc call*(call_594464: Call_ModelListCompositeEntityRoles_594457;
          versionId: string; appId: string; cEntityId: string): Recallable =
  ## modelListCompositeEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   cEntityId: string (required)
  ##            : The composite entity extractor ID.
  var path_594465 = newJObject()
  add(path_594465, "versionId", newJString(versionId))
  add(path_594465, "appId", newJString(appId))
  add(path_594465, "cEntityId", newJString(cEntityId))
  result = call_594464.call(path_594465, nil, nil, nil, nil)

var modelListCompositeEntityRoles* = Call_ModelListCompositeEntityRoles_594457(
    name: "modelListCompositeEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles",
    validator: validate_ModelListCompositeEntityRoles_594458, base: "",
    url: url_ModelListCompositeEntityRoles_594459, schemes: {Scheme.Https})
type
  Call_ModelUpdateCompositeEntityRole_594487 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateCompositeEntityRole_594489(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCompositeEntityRole_594488(path: JsonNode;
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
  var valid_594490 = path.getOrDefault("versionId")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "versionId", valid_594490
  var valid_594491 = path.getOrDefault("appId")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "appId", valid_594491
  var valid_594492 = path.getOrDefault("roleId")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "roleId", valid_594492
  var valid_594493 = path.getOrDefault("cEntityId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "cEntityId", valid_594493
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

proc call*(call_594495: Call_ModelUpdateCompositeEntityRole_594487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594495.validator(path, query, header, formData, body)
  let scheme = call_594495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594495.url(scheme.get, call_594495.host, call_594495.base,
                         call_594495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594495, url, valid)

proc call*(call_594496: Call_ModelUpdateCompositeEntityRole_594487;
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
  var path_594497 = newJObject()
  var body_594498 = newJObject()
  add(path_594497, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_594498 = entityRoleUpdateObject
  add(path_594497, "appId", newJString(appId))
  add(path_594497, "roleId", newJString(roleId))
  add(path_594497, "cEntityId", newJString(cEntityId))
  result = call_594496.call(path_594497, nil, nil, nil, body_594498)

var modelUpdateCompositeEntityRole* = Call_ModelUpdateCompositeEntityRole_594487(
    name: "modelUpdateCompositeEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateCompositeEntityRole_594488, base: "",
    url: url_ModelUpdateCompositeEntityRole_594489, schemes: {Scheme.Https})
type
  Call_ModelGetCompositeEntityRole_594477 = ref object of OpenApiRestCall_593439
proc url_ModelGetCompositeEntityRole_594479(protocol: Scheme; host: string;
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

proc validate_ModelGetCompositeEntityRole_594478(path: JsonNode; query: JsonNode;
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
  var valid_594480 = path.getOrDefault("versionId")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "versionId", valid_594480
  var valid_594481 = path.getOrDefault("appId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "appId", valid_594481
  var valid_594482 = path.getOrDefault("roleId")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "roleId", valid_594482
  var valid_594483 = path.getOrDefault("cEntityId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "cEntityId", valid_594483
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594484: Call_ModelGetCompositeEntityRole_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594484.validator(path, query, header, formData, body)
  let scheme = call_594484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594484.url(scheme.get, call_594484.host, call_594484.base,
                         call_594484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594484, url, valid)

proc call*(call_594485: Call_ModelGetCompositeEntityRole_594477; versionId: string;
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
  var path_594486 = newJObject()
  add(path_594486, "versionId", newJString(versionId))
  add(path_594486, "appId", newJString(appId))
  add(path_594486, "roleId", newJString(roleId))
  add(path_594486, "cEntityId", newJString(cEntityId))
  result = call_594485.call(path_594486, nil, nil, nil, nil)

var modelGetCompositeEntityRole* = Call_ModelGetCompositeEntityRole_594477(
    name: "modelGetCompositeEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelGetCompositeEntityRole_594478, base: "",
    url: url_ModelGetCompositeEntityRole_594479, schemes: {Scheme.Https})
type
  Call_ModelDeleteCompositeEntityRole_594499 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteCompositeEntityRole_594501(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCompositeEntityRole_594500(path: JsonNode;
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
  var valid_594502 = path.getOrDefault("versionId")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "versionId", valid_594502
  var valid_594503 = path.getOrDefault("appId")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "appId", valid_594503
  var valid_594504 = path.getOrDefault("roleId")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "roleId", valid_594504
  var valid_594505 = path.getOrDefault("cEntityId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "cEntityId", valid_594505
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594506: Call_ModelDeleteCompositeEntityRole_594499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594506.validator(path, query, header, formData, body)
  let scheme = call_594506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594506.url(scheme.get, call_594506.host, call_594506.base,
                         call_594506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594506, url, valid)

proc call*(call_594507: Call_ModelDeleteCompositeEntityRole_594499;
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
  var path_594508 = newJObject()
  add(path_594508, "versionId", newJString(versionId))
  add(path_594508, "appId", newJString(appId))
  add(path_594508, "roleId", newJString(roleId))
  add(path_594508, "cEntityId", newJString(cEntityId))
  result = call_594507.call(path_594508, nil, nil, nil, nil)

var modelDeleteCompositeEntityRole* = Call_ModelDeleteCompositeEntityRole_594499(
    name: "modelDeleteCompositeEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/compositeentities/{cEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteCompositeEntityRole_594500, base: "",
    url: url_ModelDeleteCompositeEntityRole_594501, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltDomain_594509 = ref object of OpenApiRestCall_593439
proc url_ModelAddCustomPrebuiltDomain_594511(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltDomain_594510(path: JsonNode; query: JsonNode;
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
  var valid_594512 = path.getOrDefault("versionId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "versionId", valid_594512
  var valid_594513 = path.getOrDefault("appId")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "appId", valid_594513
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

proc call*(call_594515: Call_ModelAddCustomPrebuiltDomain_594509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ## 
  let valid = call_594515.validator(path, query, header, formData, body)
  let scheme = call_594515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594515.url(scheme.get, call_594515.host, call_594515.base,
                         call_594515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594515, url, valid)

proc call*(call_594516: Call_ModelAddCustomPrebuiltDomain_594509;
          versionId: string; appId: string; prebuiltDomainObject: JsonNode): Recallable =
  ## modelAddCustomPrebuiltDomain
  ## Adds a customizable prebuilt domain along with all of its intent and entity models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltDomainObject: JObject (required)
  ##                       : A prebuilt domain create object containing the name of the domain.
  var path_594517 = newJObject()
  var body_594518 = newJObject()
  add(path_594517, "versionId", newJString(versionId))
  add(path_594517, "appId", newJString(appId))
  if prebuiltDomainObject != nil:
    body_594518 = prebuiltDomainObject
  result = call_594516.call(path_594517, nil, nil, nil, body_594518)

var modelAddCustomPrebuiltDomain* = Call_ModelAddCustomPrebuiltDomain_594509(
    name: "modelAddCustomPrebuiltDomain", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains",
    validator: validate_ModelAddCustomPrebuiltDomain_594510, base: "",
    url: url_ModelAddCustomPrebuiltDomain_594511, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomPrebuiltDomain_594519 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteCustomPrebuiltDomain_594521(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCustomPrebuiltDomain_594520(path: JsonNode;
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
  var valid_594522 = path.getOrDefault("versionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "versionId", valid_594522
  var valid_594523 = path.getOrDefault("appId")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "appId", valid_594523
  var valid_594524 = path.getOrDefault("domainName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "domainName", valid_594524
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594525: Call_ModelDeleteCustomPrebuiltDomain_594519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a prebuilt domain's models in a version of the application.
  ## 
  let valid = call_594525.validator(path, query, header, formData, body)
  let scheme = call_594525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594525.url(scheme.get, call_594525.host, call_594525.base,
                         call_594525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594525, url, valid)

proc call*(call_594526: Call_ModelDeleteCustomPrebuiltDomain_594519;
          versionId: string; appId: string; domainName: string): Recallable =
  ## modelDeleteCustomPrebuiltDomain
  ## Deletes a prebuilt domain's models in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   domainName: string (required)
  ##             : Domain name.
  var path_594527 = newJObject()
  add(path_594527, "versionId", newJString(versionId))
  add(path_594527, "appId", newJString(appId))
  add(path_594527, "domainName", newJString(domainName))
  result = call_594526.call(path_594527, nil, nil, nil, nil)

var modelDeleteCustomPrebuiltDomain* = Call_ModelDeleteCustomPrebuiltDomain_594519(
    name: "modelDeleteCustomPrebuiltDomain", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltdomains/{domainName}",
    validator: validate_ModelDeleteCustomPrebuiltDomain_594520, base: "",
    url: url_ModelDeleteCustomPrebuiltDomain_594521, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltEntity_594536 = ref object of OpenApiRestCall_593439
proc url_ModelAddCustomPrebuiltEntity_594538(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltEntity_594537(path: JsonNode; query: JsonNode;
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
  var valid_594539 = path.getOrDefault("versionId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "versionId", valid_594539
  var valid_594540 = path.getOrDefault("appId")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "appId", valid_594540
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

proc call*(call_594542: Call_ModelAddCustomPrebuiltEntity_594536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a prebuilt entity model to a version of the application.
  ## 
  let valid = call_594542.validator(path, query, header, formData, body)
  let scheme = call_594542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594542.url(scheme.get, call_594542.host, call_594542.base,
                         call_594542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594542, url, valid)

proc call*(call_594543: Call_ModelAddCustomPrebuiltEntity_594536;
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
  var path_594544 = newJObject()
  var body_594545 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_594545 = prebuiltDomainModelCreateObject
  add(path_594544, "versionId", newJString(versionId))
  add(path_594544, "appId", newJString(appId))
  result = call_594543.call(path_594544, nil, nil, nil, body_594545)

var modelAddCustomPrebuiltEntity* = Call_ModelAddCustomPrebuiltEntity_594536(
    name: "modelAddCustomPrebuiltEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelAddCustomPrebuiltEntity_594537, base: "",
    url: url_ModelAddCustomPrebuiltEntity_594538, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntities_594528 = ref object of OpenApiRestCall_593439
proc url_ModelListCustomPrebuiltEntities_594530(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltEntities_594529(path: JsonNode;
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
  var valid_594531 = path.getOrDefault("versionId")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "versionId", valid_594531
  var valid_594532 = path.getOrDefault("appId")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "appId", valid_594532
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594533: Call_ModelListCustomPrebuiltEntities_594528;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all prebuilt entities used in a version of the application.
  ## 
  let valid = call_594533.validator(path, query, header, formData, body)
  let scheme = call_594533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594533.url(scheme.get, call_594533.host, call_594533.base,
                         call_594533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594533, url, valid)

proc call*(call_594534: Call_ModelListCustomPrebuiltEntities_594528;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntities
  ## Gets all prebuilt entities used in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594535 = newJObject()
  add(path_594535, "versionId", newJString(versionId))
  add(path_594535, "appId", newJString(appId))
  result = call_594534.call(path_594535, nil, nil, nil, nil)

var modelListCustomPrebuiltEntities* = Call_ModelListCustomPrebuiltEntities_594528(
    name: "modelListCustomPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltentities",
    validator: validate_ModelListCustomPrebuiltEntities_594529, base: "",
    url: url_ModelListCustomPrebuiltEntities_594530, schemes: {Scheme.Https})
type
  Call_ModelCreateCustomPrebuiltEntityRole_594555 = ref object of OpenApiRestCall_593439
proc url_ModelCreateCustomPrebuiltEntityRole_594557(protocol: Scheme; host: string;
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

proc validate_ModelCreateCustomPrebuiltEntityRole_594556(path: JsonNode;
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
  var valid_594558 = path.getOrDefault("versionId")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "versionId", valid_594558
  var valid_594559 = path.getOrDefault("entityId")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "entityId", valid_594559
  var valid_594560 = path.getOrDefault("appId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "appId", valid_594560
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

proc call*(call_594562: Call_ModelCreateCustomPrebuiltEntityRole_594555;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594562.validator(path, query, header, formData, body)
  let scheme = call_594562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594562.url(scheme.get, call_594562.host, call_594562.base,
                         call_594562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594562, url, valid)

proc call*(call_594563: Call_ModelCreateCustomPrebuiltEntityRole_594555;
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
  var path_594564 = newJObject()
  var body_594565 = newJObject()
  add(path_594564, "versionId", newJString(versionId))
  add(path_594564, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_594565 = entityRoleCreateObject
  add(path_594564, "appId", newJString(appId))
  result = call_594563.call(path_594564, nil, nil, nil, body_594565)

var modelCreateCustomPrebuiltEntityRole* = Call_ModelCreateCustomPrebuiltEntityRole_594555(
    name: "modelCreateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelCreateCustomPrebuiltEntityRole_594556, base: "",
    url: url_ModelCreateCustomPrebuiltEntityRole_594557, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltEntityRoles_594546 = ref object of OpenApiRestCall_593439
proc url_ModelListCustomPrebuiltEntityRoles_594548(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltEntityRoles_594547(path: JsonNode;
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
  var valid_594549 = path.getOrDefault("versionId")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "versionId", valid_594549
  var valid_594550 = path.getOrDefault("entityId")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "entityId", valid_594550
  var valid_594551 = path.getOrDefault("appId")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "appId", valid_594551
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594552: Call_ModelListCustomPrebuiltEntityRoles_594546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594552.validator(path, query, header, formData, body)
  let scheme = call_594552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594552.url(scheme.get, call_594552.host, call_594552.base,
                         call_594552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594552, url, valid)

proc call*(call_594553: Call_ModelListCustomPrebuiltEntityRoles_594546;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_594554 = newJObject()
  add(path_594554, "versionId", newJString(versionId))
  add(path_594554, "entityId", newJString(entityId))
  add(path_594554, "appId", newJString(appId))
  result = call_594553.call(path_594554, nil, nil, nil, nil)

var modelListCustomPrebuiltEntityRoles* = Call_ModelListCustomPrebuiltEntityRoles_594546(
    name: "modelListCustomPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles",
    validator: validate_ModelListCustomPrebuiltEntityRoles_594547, base: "",
    url: url_ModelListCustomPrebuiltEntityRoles_594548, schemes: {Scheme.Https})
type
  Call_ModelUpdateCustomPrebuiltEntityRole_594576 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateCustomPrebuiltEntityRole_594578(protocol: Scheme; host: string;
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

proc validate_ModelUpdateCustomPrebuiltEntityRole_594577(path: JsonNode;
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
  var valid_594579 = path.getOrDefault("versionId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "versionId", valid_594579
  var valid_594580 = path.getOrDefault("entityId")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "entityId", valid_594580
  var valid_594581 = path.getOrDefault("appId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "appId", valid_594581
  var valid_594582 = path.getOrDefault("roleId")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "roleId", valid_594582
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

proc call*(call_594584: Call_ModelUpdateCustomPrebuiltEntityRole_594576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594584.validator(path, query, header, formData, body)
  let scheme = call_594584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594584.url(scheme.get, call_594584.host, call_594584.base,
                         call_594584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594584, url, valid)

proc call*(call_594585: Call_ModelUpdateCustomPrebuiltEntityRole_594576;
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
  var path_594586 = newJObject()
  var body_594587 = newJObject()
  add(path_594586, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_594587 = entityRoleUpdateObject
  add(path_594586, "entityId", newJString(entityId))
  add(path_594586, "appId", newJString(appId))
  add(path_594586, "roleId", newJString(roleId))
  result = call_594585.call(path_594586, nil, nil, nil, body_594587)

var modelUpdateCustomPrebuiltEntityRole* = Call_ModelUpdateCustomPrebuiltEntityRole_594576(
    name: "modelUpdateCustomPrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateCustomPrebuiltEntityRole_594577, base: "",
    url: url_ModelUpdateCustomPrebuiltEntityRole_594578, schemes: {Scheme.Https})
type
  Call_ModelGetCustomEntityRole_594566 = ref object of OpenApiRestCall_593439
proc url_ModelGetCustomEntityRole_594568(protocol: Scheme; host: string;
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

proc validate_ModelGetCustomEntityRole_594567(path: JsonNode; query: JsonNode;
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
  var valid_594569 = path.getOrDefault("versionId")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "versionId", valid_594569
  var valid_594570 = path.getOrDefault("entityId")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "entityId", valid_594570
  var valid_594571 = path.getOrDefault("appId")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "appId", valid_594571
  var valid_594572 = path.getOrDefault("roleId")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "roleId", valid_594572
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594573: Call_ModelGetCustomEntityRole_594566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594573.validator(path, query, header, formData, body)
  let scheme = call_594573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594573.url(scheme.get, call_594573.host, call_594573.base,
                         call_594573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594573, url, valid)

proc call*(call_594574: Call_ModelGetCustomEntityRole_594566; versionId: string;
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
  var path_594575 = newJObject()
  add(path_594575, "versionId", newJString(versionId))
  add(path_594575, "entityId", newJString(entityId))
  add(path_594575, "appId", newJString(appId))
  add(path_594575, "roleId", newJString(roleId))
  result = call_594574.call(path_594575, nil, nil, nil, nil)

var modelGetCustomEntityRole* = Call_ModelGetCustomEntityRole_594566(
    name: "modelGetCustomEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetCustomEntityRole_594567, base: "",
    url: url_ModelGetCustomEntityRole_594568, schemes: {Scheme.Https})
type
  Call_ModelDeleteCustomEntityRole_594588 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteCustomEntityRole_594590(protocol: Scheme; host: string;
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

proc validate_ModelDeleteCustomEntityRole_594589(path: JsonNode; query: JsonNode;
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
  var valid_594591 = path.getOrDefault("versionId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "versionId", valid_594591
  var valid_594592 = path.getOrDefault("entityId")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "entityId", valid_594592
  var valid_594593 = path.getOrDefault("appId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "appId", valid_594593
  var valid_594594 = path.getOrDefault("roleId")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "roleId", valid_594594
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594595: Call_ModelDeleteCustomEntityRole_594588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_ModelDeleteCustomEntityRole_594588; versionId: string;
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
  var path_594597 = newJObject()
  add(path_594597, "versionId", newJString(versionId))
  add(path_594597, "entityId", newJString(entityId))
  add(path_594597, "appId", newJString(appId))
  add(path_594597, "roleId", newJString(roleId))
  result = call_594596.call(path_594597, nil, nil, nil, nil)

var modelDeleteCustomEntityRole* = Call_ModelDeleteCustomEntityRole_594588(
    name: "modelDeleteCustomEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/customprebuiltentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteCustomEntityRole_594589, base: "",
    url: url_ModelDeleteCustomEntityRole_594590, schemes: {Scheme.Https})
type
  Call_ModelAddCustomPrebuiltIntent_594606 = ref object of OpenApiRestCall_593439
proc url_ModelAddCustomPrebuiltIntent_594608(protocol: Scheme; host: string;
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

proc validate_ModelAddCustomPrebuiltIntent_594607(path: JsonNode; query: JsonNode;
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
  var valid_594609 = path.getOrDefault("versionId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "versionId", valid_594609
  var valid_594610 = path.getOrDefault("appId")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "appId", valid_594610
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

proc call*(call_594612: Call_ModelAddCustomPrebuiltIntent_594606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a customizable prebuilt intent model to a version of the application.
  ## 
  let valid = call_594612.validator(path, query, header, formData, body)
  let scheme = call_594612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594612.url(scheme.get, call_594612.host, call_594612.base,
                         call_594612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594612, url, valid)

proc call*(call_594613: Call_ModelAddCustomPrebuiltIntent_594606;
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
  var path_594614 = newJObject()
  var body_594615 = newJObject()
  if prebuiltDomainModelCreateObject != nil:
    body_594615 = prebuiltDomainModelCreateObject
  add(path_594614, "versionId", newJString(versionId))
  add(path_594614, "appId", newJString(appId))
  result = call_594613.call(path_594614, nil, nil, nil, body_594615)

var modelAddCustomPrebuiltIntent* = Call_ModelAddCustomPrebuiltIntent_594606(
    name: "modelAddCustomPrebuiltIntent", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelAddCustomPrebuiltIntent_594607, base: "",
    url: url_ModelAddCustomPrebuiltIntent_594608, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltIntents_594598 = ref object of OpenApiRestCall_593439
proc url_ModelListCustomPrebuiltIntents_594600(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltIntents_594599(path: JsonNode;
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
  var valid_594601 = path.getOrDefault("versionId")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "versionId", valid_594601
  var valid_594602 = path.getOrDefault("appId")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "appId", valid_594602
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_ModelListCustomPrebuiltIntents_594598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_ModelListCustomPrebuiltIntents_594598;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltIntents
  ## Gets information about customizable prebuilt intents added to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594605 = newJObject()
  add(path_594605, "versionId", newJString(versionId))
  add(path_594605, "appId", newJString(appId))
  result = call_594604.call(path_594605, nil, nil, nil, nil)

var modelListCustomPrebuiltIntents* = Call_ModelListCustomPrebuiltIntents_594598(
    name: "modelListCustomPrebuiltIntents", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltintents",
    validator: validate_ModelListCustomPrebuiltIntents_594599, base: "",
    url: url_ModelListCustomPrebuiltIntents_594600, schemes: {Scheme.Https})
type
  Call_ModelListCustomPrebuiltModels_594616 = ref object of OpenApiRestCall_593439
proc url_ModelListCustomPrebuiltModels_594618(protocol: Scheme; host: string;
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

proc validate_ModelListCustomPrebuiltModels_594617(path: JsonNode; query: JsonNode;
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
  var valid_594619 = path.getOrDefault("versionId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "versionId", valid_594619
  var valid_594620 = path.getOrDefault("appId")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "appId", valid_594620
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594621: Call_ModelListCustomPrebuiltModels_594616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ## 
  let valid = call_594621.validator(path, query, header, formData, body)
  let scheme = call_594621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594621.url(scheme.get, call_594621.host, call_594621.base,
                         call_594621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594621, url, valid)

proc call*(call_594622: Call_ModelListCustomPrebuiltModels_594616;
          versionId: string; appId: string): Recallable =
  ## modelListCustomPrebuiltModels
  ## Gets all prebuilt intent and entity model information used in a version of this application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594623 = newJObject()
  add(path_594623, "versionId", newJString(versionId))
  add(path_594623, "appId", newJString(appId))
  result = call_594622.call(path_594623, nil, nil, nil, nil)

var modelListCustomPrebuiltModels* = Call_ModelListCustomPrebuiltModels_594616(
    name: "modelListCustomPrebuiltModels", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/customprebuiltmodels",
    validator: validate_ModelListCustomPrebuiltModels_594617, base: "",
    url: url_ModelListCustomPrebuiltModels_594618, schemes: {Scheme.Https})
type
  Call_ModelAddEntity_594635 = ref object of OpenApiRestCall_593439
proc url_ModelAddEntity_594637(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddEntity_594636(path: JsonNode; query: JsonNode;
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
  var valid_594638 = path.getOrDefault("versionId")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "versionId", valid_594638
  var valid_594639 = path.getOrDefault("appId")
  valid_594639 = validateParameter(valid_594639, JString, required = true,
                                 default = nil)
  if valid_594639 != nil:
    section.add "appId", valid_594639
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

proc call*(call_594641: Call_ModelAddEntity_594635; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a simple entity extractor to a version of the application.
  ## 
  let valid = call_594641.validator(path, query, header, formData, body)
  let scheme = call_594641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594641.url(scheme.get, call_594641.host, call_594641.base,
                         call_594641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594641, url, valid)

proc call*(call_594642: Call_ModelAddEntity_594635; versionId: string; appId: string;
          modelCreateObject: JsonNode): Recallable =
  ## modelAddEntity
  ## Adds a simple entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   modelCreateObject: JObject (required)
  ##                    : A model object containing the name for the new simple entity extractor.
  var path_594643 = newJObject()
  var body_594644 = newJObject()
  add(path_594643, "versionId", newJString(versionId))
  add(path_594643, "appId", newJString(appId))
  if modelCreateObject != nil:
    body_594644 = modelCreateObject
  result = call_594642.call(path_594643, nil, nil, nil, body_594644)

var modelAddEntity* = Call_ModelAddEntity_594635(name: "modelAddEntity",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelAddEntity_594636, base: "", url: url_ModelAddEntity_594637,
    schemes: {Scheme.Https})
type
  Call_ModelListEntities_594624 = ref object of OpenApiRestCall_593439
proc url_ModelListEntities_594626(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListEntities_594625(path: JsonNode; query: JsonNode;
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
  var valid_594627 = path.getOrDefault("versionId")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "versionId", valid_594627
  var valid_594628 = path.getOrDefault("appId")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "appId", valid_594628
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594629 = query.getOrDefault("skip")
  valid_594629 = validateParameter(valid_594629, JInt, required = false,
                                 default = newJInt(0))
  if valid_594629 != nil:
    section.add "skip", valid_594629
  var valid_594630 = query.getOrDefault("take")
  valid_594630 = validateParameter(valid_594630, JInt, required = false,
                                 default = newJInt(100))
  if valid_594630 != nil:
    section.add "take", valid_594630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594631: Call_ModelListEntities_594624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the simple entity models in a version of the application.
  ## 
  let valid = call_594631.validator(path, query, header, formData, body)
  let scheme = call_594631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594631.url(scheme.get, call_594631.host, call_594631.base,
                         call_594631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594631, url, valid)

proc call*(call_594632: Call_ModelListEntities_594624; versionId: string;
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
  var path_594633 = newJObject()
  var query_594634 = newJObject()
  add(path_594633, "versionId", newJString(versionId))
  add(query_594634, "skip", newJInt(skip))
  add(query_594634, "take", newJInt(take))
  add(path_594633, "appId", newJString(appId))
  result = call_594632.call(path_594633, query_594634, nil, nil, nil)

var modelListEntities* = Call_ModelListEntities_594624(name: "modelListEntities",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities",
    validator: validate_ModelListEntities_594625, base: "",
    url: url_ModelListEntities_594626, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntity_594654 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateEntity_594656(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateEntity_594655(path: JsonNode; query: JsonNode;
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
  var valid_594657 = path.getOrDefault("versionId")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "versionId", valid_594657
  var valid_594658 = path.getOrDefault("entityId")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "entityId", valid_594658
  var valid_594659 = path.getOrDefault("appId")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "appId", valid_594659
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

proc call*(call_594661: Call_ModelUpdateEntity_594654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an entity in a version of the application.
  ## 
  let valid = call_594661.validator(path, query, header, formData, body)
  let scheme = call_594661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594661.url(scheme.get, call_594661.host, call_594661.base,
                         call_594661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594661, url, valid)

proc call*(call_594662: Call_ModelUpdateEntity_594654; versionId: string;
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
  var path_594663 = newJObject()
  var body_594664 = newJObject()
  add(path_594663, "versionId", newJString(versionId))
  add(path_594663, "entityId", newJString(entityId))
  if modelUpdateObject != nil:
    body_594664 = modelUpdateObject
  add(path_594663, "appId", newJString(appId))
  result = call_594662.call(path_594663, nil, nil, nil, body_594664)

var modelUpdateEntity* = Call_ModelUpdateEntity_594654(name: "modelUpdateEntity",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelUpdateEntity_594655, base: "",
    url: url_ModelUpdateEntity_594656, schemes: {Scheme.Https})
type
  Call_ModelGetEntity_594645 = ref object of OpenApiRestCall_593439
proc url_ModelGetEntity_594647(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetEntity_594646(path: JsonNode; query: JsonNode;
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
  var valid_594648 = path.getOrDefault("versionId")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "versionId", valid_594648
  var valid_594649 = path.getOrDefault("entityId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "entityId", valid_594649
  var valid_594650 = path.getOrDefault("appId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "appId", valid_594650
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594651: Call_ModelGetEntity_594645; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an entity model in a version of the application.
  ## 
  let valid = call_594651.validator(path, query, header, formData, body)
  let scheme = call_594651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594651.url(scheme.get, call_594651.host, call_594651.base,
                         call_594651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594651, url, valid)

proc call*(call_594652: Call_ModelGetEntity_594645; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetEntity
  ## Gets information about an entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594653 = newJObject()
  add(path_594653, "versionId", newJString(versionId))
  add(path_594653, "entityId", newJString(entityId))
  add(path_594653, "appId", newJString(appId))
  result = call_594652.call(path_594653, nil, nil, nil, nil)

var modelGetEntity* = Call_ModelGetEntity_594645(name: "modelGetEntity",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelGetEntity_594646, base: "", url: url_ModelGetEntity_594647,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteEntity_594665 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteEntity_594667(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteEntity_594666(path: JsonNode; query: JsonNode;
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
  var valid_594668 = path.getOrDefault("versionId")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "versionId", valid_594668
  var valid_594669 = path.getOrDefault("entityId")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "entityId", valid_594669
  var valid_594670 = path.getOrDefault("appId")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "appId", valid_594670
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594671: Call_ModelDeleteEntity_594665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an entity from a version of the application.
  ## 
  let valid = call_594671.validator(path, query, header, formData, body)
  let scheme = call_594671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594671.url(scheme.get, call_594671.host, call_594671.base,
                         call_594671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594671, url, valid)

proc call*(call_594672: Call_ModelDeleteEntity_594665; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelDeleteEntity
  ## Deletes an entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594673 = newJObject()
  add(path_594673, "versionId", newJString(versionId))
  add(path_594673, "entityId", newJString(entityId))
  add(path_594673, "appId", newJString(appId))
  result = call_594672.call(path_594673, nil, nil, nil, nil)

var modelDeleteEntity* = Call_ModelDeleteEntity_594665(name: "modelDeleteEntity",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}",
    validator: validate_ModelDeleteEntity_594666, base: "",
    url: url_ModelDeleteEntity_594667, schemes: {Scheme.Https})
type
  Call_ModelCreateEntityRole_594683 = ref object of OpenApiRestCall_593439
proc url_ModelCreateEntityRole_594685(protocol: Scheme; host: string; base: string;
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

proc validate_ModelCreateEntityRole_594684(path: JsonNode; query: JsonNode;
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
  var valid_594686 = path.getOrDefault("versionId")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "versionId", valid_594686
  var valid_594687 = path.getOrDefault("entityId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "entityId", valid_594687
  var valid_594688 = path.getOrDefault("appId")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "appId", valid_594688
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

proc call*(call_594690: Call_ModelCreateEntityRole_594683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594690.validator(path, query, header, formData, body)
  let scheme = call_594690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594690.url(scheme.get, call_594690.host, call_594690.base,
                         call_594690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594690, url, valid)

proc call*(call_594691: Call_ModelCreateEntityRole_594683; versionId: string;
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
  var path_594692 = newJObject()
  var body_594693 = newJObject()
  add(path_594692, "versionId", newJString(versionId))
  add(path_594692, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_594693 = entityRoleCreateObject
  add(path_594692, "appId", newJString(appId))
  result = call_594691.call(path_594692, nil, nil, nil, body_594693)

var modelCreateEntityRole* = Call_ModelCreateEntityRole_594683(
    name: "modelCreateEntityRole", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelCreateEntityRole_594684, base: "",
    url: url_ModelCreateEntityRole_594685, schemes: {Scheme.Https})
type
  Call_ModelListEntityRoles_594674 = ref object of OpenApiRestCall_593439
proc url_ModelListEntityRoles_594676(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListEntityRoles_594675(path: JsonNode; query: JsonNode;
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
  var valid_594677 = path.getOrDefault("versionId")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "versionId", valid_594677
  var valid_594678 = path.getOrDefault("entityId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "entityId", valid_594678
  var valid_594679 = path.getOrDefault("appId")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "appId", valid_594679
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594680: Call_ModelListEntityRoles_594674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594680.validator(path, query, header, formData, body)
  let scheme = call_594680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594680.url(scheme.get, call_594680.host, call_594680.base,
                         call_594680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594680, url, valid)

proc call*(call_594681: Call_ModelListEntityRoles_594674; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelListEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_594682 = newJObject()
  add(path_594682, "versionId", newJString(versionId))
  add(path_594682, "entityId", newJString(entityId))
  add(path_594682, "appId", newJString(appId))
  result = call_594681.call(path_594682, nil, nil, nil, nil)

var modelListEntityRoles* = Call_ModelListEntityRoles_594674(
    name: "modelListEntityRoles", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles",
    validator: validate_ModelListEntityRoles_594675, base: "",
    url: url_ModelListEntityRoles_594676, schemes: {Scheme.Https})
type
  Call_ModelUpdateEntityRole_594704 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateEntityRole_594706(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateEntityRole_594705(path: JsonNode; query: JsonNode;
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
  var valid_594707 = path.getOrDefault("versionId")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "versionId", valid_594707
  var valid_594708 = path.getOrDefault("entityId")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "entityId", valid_594708
  var valid_594709 = path.getOrDefault("appId")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "appId", valid_594709
  var valid_594710 = path.getOrDefault("roleId")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "roleId", valid_594710
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

proc call*(call_594712: Call_ModelUpdateEntityRole_594704; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594712.validator(path, query, header, formData, body)
  let scheme = call_594712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594712.url(scheme.get, call_594712.host, call_594712.base,
                         call_594712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594712, url, valid)

proc call*(call_594713: Call_ModelUpdateEntityRole_594704; versionId: string;
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
  var path_594714 = newJObject()
  var body_594715 = newJObject()
  add(path_594714, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_594715 = entityRoleUpdateObject
  add(path_594714, "entityId", newJString(entityId))
  add(path_594714, "appId", newJString(appId))
  add(path_594714, "roleId", newJString(roleId))
  result = call_594713.call(path_594714, nil, nil, nil, body_594715)

var modelUpdateEntityRole* = Call_ModelUpdateEntityRole_594704(
    name: "modelUpdateEntityRole", meth: HttpMethod.HttpPut, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateEntityRole_594705, base: "",
    url: url_ModelUpdateEntityRole_594706, schemes: {Scheme.Https})
type
  Call_ModelGetEntityRole_594694 = ref object of OpenApiRestCall_593439
proc url_ModelGetEntityRole_594696(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetEntityRole_594695(path: JsonNode; query: JsonNode;
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
  var valid_594697 = path.getOrDefault("versionId")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "versionId", valid_594697
  var valid_594698 = path.getOrDefault("entityId")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "entityId", valid_594698
  var valid_594699 = path.getOrDefault("appId")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "appId", valid_594699
  var valid_594700 = path.getOrDefault("roleId")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "roleId", valid_594700
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594701: Call_ModelGetEntityRole_594694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594701.validator(path, query, header, formData, body)
  let scheme = call_594701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594701.url(scheme.get, call_594701.host, call_594701.base,
                         call_594701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594701, url, valid)

proc call*(call_594702: Call_ModelGetEntityRole_594694; versionId: string;
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
  var path_594703 = newJObject()
  add(path_594703, "versionId", newJString(versionId))
  add(path_594703, "entityId", newJString(entityId))
  add(path_594703, "appId", newJString(appId))
  add(path_594703, "roleId", newJString(roleId))
  result = call_594702.call(path_594703, nil, nil, nil, nil)

var modelGetEntityRole* = Call_ModelGetEntityRole_594694(
    name: "modelGetEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetEntityRole_594695, base: "",
    url: url_ModelGetEntityRole_594696, schemes: {Scheme.Https})
type
  Call_ModelDeleteEntityRole_594716 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteEntityRole_594718(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteEntityRole_594717(path: JsonNode; query: JsonNode;
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
  var valid_594719 = path.getOrDefault("versionId")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "versionId", valid_594719
  var valid_594720 = path.getOrDefault("entityId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "entityId", valid_594720
  var valid_594721 = path.getOrDefault("appId")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "appId", valid_594721
  var valid_594722 = path.getOrDefault("roleId")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "roleId", valid_594722
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594723: Call_ModelDeleteEntityRole_594716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594723.validator(path, query, header, formData, body)
  let scheme = call_594723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594723.url(scheme.get, call_594723.host, call_594723.base,
                         call_594723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594723, url, valid)

proc call*(call_594724: Call_ModelDeleteEntityRole_594716; versionId: string;
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
  var path_594725 = newJObject()
  add(path_594725, "versionId", newJString(versionId))
  add(path_594725, "entityId", newJString(entityId))
  add(path_594725, "appId", newJString(appId))
  add(path_594725, "roleId", newJString(roleId))
  result = call_594724.call(path_594725, nil, nil, nil, nil)

var modelDeleteEntityRole* = Call_ModelDeleteEntityRole_594716(
    name: "modelDeleteEntityRole", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteEntityRole_594717, base: "",
    url: url_ModelDeleteEntityRole_594718, schemes: {Scheme.Https})
type
  Call_ModelListEntitySuggestions_594726 = ref object of OpenApiRestCall_593439
proc url_ModelListEntitySuggestions_594728(protocol: Scheme; host: string;
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

proc validate_ModelListEntitySuggestions_594727(path: JsonNode; query: JsonNode;
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
  var valid_594729 = path.getOrDefault("versionId")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "versionId", valid_594729
  var valid_594730 = path.getOrDefault("entityId")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "entityId", valid_594730
  var valid_594731 = path.getOrDefault("appId")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "appId", valid_594731
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594732 = query.getOrDefault("take")
  valid_594732 = validateParameter(valid_594732, JInt, required = false,
                                 default = newJInt(100))
  if valid_594732 != nil:
    section.add "take", valid_594732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594733: Call_ModelListEntitySuggestions_594726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get suggested example utterances that would improve the accuracy of the entity model in a version of the application.
  ## 
  let valid = call_594733.validator(path, query, header, formData, body)
  let scheme = call_594733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594733.url(scheme.get, call_594733.host, call_594733.base,
                         call_594733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594733, url, valid)

proc call*(call_594734: Call_ModelListEntitySuggestions_594726; versionId: string;
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
  var path_594735 = newJObject()
  var query_594736 = newJObject()
  add(path_594735, "versionId", newJString(versionId))
  add(path_594735, "entityId", newJString(entityId))
  add(query_594736, "take", newJInt(take))
  add(path_594735, "appId", newJString(appId))
  result = call_594734.call(path_594735, query_594736, nil, nil, nil)

var modelListEntitySuggestions* = Call_ModelListEntitySuggestions_594726(
    name: "modelListEntitySuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/entities/{entityId}/suggest",
    validator: validate_ModelListEntitySuggestions_594727, base: "",
    url: url_ModelListEntitySuggestions_594728, schemes: {Scheme.Https})
type
  Call_ExamplesAdd_594737 = ref object of OpenApiRestCall_593439
proc url_ExamplesAdd_594739(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesAdd_594738(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594740 = path.getOrDefault("versionId")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "versionId", valid_594740
  var valid_594741 = path.getOrDefault("appId")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "appId", valid_594741
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

proc call*(call_594743: Call_ExamplesAdd_594737; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a labeled example utterance in a version of the application.
  ## 
  let valid = call_594743.validator(path, query, header, formData, body)
  let scheme = call_594743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594743.url(scheme.get, call_594743.host, call_594743.base,
                         call_594743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594743, url, valid)

proc call*(call_594744: Call_ExamplesAdd_594737; versionId: string; appId: string;
          exampleLabelObject: JsonNode): Recallable =
  ## examplesAdd
  ## Adds a labeled example utterance in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObject: JObject (required)
  ##                     : A labeled example utterance with the expected intent and entities.
  var path_594745 = newJObject()
  var body_594746 = newJObject()
  add(path_594745, "versionId", newJString(versionId))
  add(path_594745, "appId", newJString(appId))
  if exampleLabelObject != nil:
    body_594746 = exampleLabelObject
  result = call_594744.call(path_594745, nil, nil, nil, body_594746)

var examplesAdd* = Call_ExamplesAdd_594737(name: "examplesAdd",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/apps/{appId}/versions/{versionId}/example",
                                        validator: validate_ExamplesAdd_594738,
                                        base: "", url: url_ExamplesAdd_594739,
                                        schemes: {Scheme.Https})
type
  Call_ExamplesBatch_594758 = ref object of OpenApiRestCall_593439
proc url_ExamplesBatch_594760(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesBatch_594759(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594761 = path.getOrDefault("versionId")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "versionId", valid_594761
  var valid_594762 = path.getOrDefault("appId")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "appId", valid_594762
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

proc call*(call_594764: Call_ExamplesBatch_594758; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a batch of labeled example utterances to a version of the application.
  ## 
  let valid = call_594764.validator(path, query, header, formData, body)
  let scheme = call_594764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594764.url(scheme.get, call_594764.host, call_594764.base,
                         call_594764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594764, url, valid)

proc call*(call_594765: Call_ExamplesBatch_594758; versionId: string; appId: string;
          exampleLabelObjectArray: JsonNode): Recallable =
  ## examplesBatch
  ## Adds a batch of labeled example utterances to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleLabelObjectArray: JArray (required)
  ##                          : Array of example utterances.
  var path_594766 = newJObject()
  var body_594767 = newJObject()
  add(path_594766, "versionId", newJString(versionId))
  add(path_594766, "appId", newJString(appId))
  if exampleLabelObjectArray != nil:
    body_594767 = exampleLabelObjectArray
  result = call_594765.call(path_594766, nil, nil, nil, body_594767)

var examplesBatch* = Call_ExamplesBatch_594758(name: "examplesBatch",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesBatch_594759, base: "", url: url_ExamplesBatch_594760,
    schemes: {Scheme.Https})
type
  Call_ExamplesList_594747 = ref object of OpenApiRestCall_593439
proc url_ExamplesList_594749(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesList_594748(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594750 = path.getOrDefault("versionId")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "versionId", valid_594750
  var valid_594751 = path.getOrDefault("appId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "appId", valid_594751
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594752 = query.getOrDefault("skip")
  valid_594752 = validateParameter(valid_594752, JInt, required = false,
                                 default = newJInt(0))
  if valid_594752 != nil:
    section.add "skip", valid_594752
  var valid_594753 = query.getOrDefault("take")
  valid_594753 = validateParameter(valid_594753, JInt, required = false,
                                 default = newJInt(100))
  if valid_594753 != nil:
    section.add "take", valid_594753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594754: Call_ExamplesList_594747; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns example utterances to be reviewed from a version of the application.
  ## 
  let valid = call_594754.validator(path, query, header, formData, body)
  let scheme = call_594754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594754.url(scheme.get, call_594754.host, call_594754.base,
                         call_594754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594754, url, valid)

proc call*(call_594755: Call_ExamplesList_594747; versionId: string; appId: string;
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
  var path_594756 = newJObject()
  var query_594757 = newJObject()
  add(path_594756, "versionId", newJString(versionId))
  add(query_594757, "skip", newJInt(skip))
  add(query_594757, "take", newJInt(take))
  add(path_594756, "appId", newJString(appId))
  result = call_594755.call(path_594756, query_594757, nil, nil, nil)

var examplesList* = Call_ExamplesList_594747(name: "examplesList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples",
    validator: validate_ExamplesList_594748, base: "", url: url_ExamplesList_594749,
    schemes: {Scheme.Https})
type
  Call_ExamplesDelete_594768 = ref object of OpenApiRestCall_593439
proc url_ExamplesDelete_594770(protocol: Scheme; host: string; base: string;
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

proc validate_ExamplesDelete_594769(path: JsonNode; query: JsonNode;
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
  var valid_594771 = path.getOrDefault("versionId")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "versionId", valid_594771
  var valid_594772 = path.getOrDefault("appId")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "appId", valid_594772
  var valid_594773 = path.getOrDefault("exampleId")
  valid_594773 = validateParameter(valid_594773, JInt, required = true, default = nil)
  if valid_594773 != nil:
    section.add "exampleId", valid_594773
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594774: Call_ExamplesDelete_594768; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ## 
  let valid = call_594774.validator(path, query, header, formData, body)
  let scheme = call_594774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594774.url(scheme.get, call_594774.host, call_594774.base,
                         call_594774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594774, url, valid)

proc call*(call_594775: Call_ExamplesDelete_594768; versionId: string; appId: string;
          exampleId: int): Recallable =
  ## examplesDelete
  ## Deletes the labeled example utterances with the specified ID from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   exampleId: int (required)
  ##            : The example ID.
  var path_594776 = newJObject()
  add(path_594776, "versionId", newJString(versionId))
  add(path_594776, "appId", newJString(appId))
  add(path_594776, "exampleId", newJInt(exampleId))
  result = call_594775.call(path_594776, nil, nil, nil, nil)

var examplesDelete* = Call_ExamplesDelete_594768(name: "examplesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/examples/{exampleId}",
    validator: validate_ExamplesDelete_594769, base: "", url: url_ExamplesDelete_594770,
    schemes: {Scheme.Https})
type
  Call_VersionsExport_594777 = ref object of OpenApiRestCall_593439
proc url_VersionsExport_594779(protocol: Scheme; host: string; base: string;
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

proc validate_VersionsExport_594778(path: JsonNode; query: JsonNode;
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
  var valid_594780 = path.getOrDefault("versionId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "versionId", valid_594780
  var valid_594781 = path.getOrDefault("appId")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "appId", valid_594781
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594782: Call_VersionsExport_594777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a LUIS application to JSON format.
  ## 
  let valid = call_594782.validator(path, query, header, formData, body)
  let scheme = call_594782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594782.url(scheme.get, call_594782.host, call_594782.base,
                         call_594782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594782, url, valid)

proc call*(call_594783: Call_VersionsExport_594777; versionId: string; appId: string): Recallable =
  ## versionsExport
  ## Exports a LUIS application to JSON format.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594784 = newJObject()
  add(path_594784, "versionId", newJString(versionId))
  add(path_594784, "appId", newJString(appId))
  result = call_594783.call(path_594784, nil, nil, nil, nil)

var versionsExport* = Call_VersionsExport_594777(name: "versionsExport",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/export",
    validator: validate_VersionsExport_594778, base: "", url: url_VersionsExport_594779,
    schemes: {Scheme.Https})
type
  Call_FeaturesList_594785 = ref object of OpenApiRestCall_593439
proc url_FeaturesList_594787(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesList_594786(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594788 = path.getOrDefault("versionId")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = nil)
  if valid_594788 != nil:
    section.add "versionId", valid_594788
  var valid_594789 = path.getOrDefault("appId")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "appId", valid_594789
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594790 = query.getOrDefault("skip")
  valid_594790 = validateParameter(valid_594790, JInt, required = false,
                                 default = newJInt(0))
  if valid_594790 != nil:
    section.add "skip", valid_594790
  var valid_594791 = query.getOrDefault("take")
  valid_594791 = validateParameter(valid_594791, JInt, required = false,
                                 default = newJInt(100))
  if valid_594791 != nil:
    section.add "take", valid_594791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594792: Call_FeaturesList_594785; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the extraction phraselist and pattern features in a version of the application.
  ## 
  let valid = call_594792.validator(path, query, header, formData, body)
  let scheme = call_594792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594792.url(scheme.get, call_594792.host, call_594792.base,
                         call_594792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594792, url, valid)

proc call*(call_594793: Call_FeaturesList_594785; versionId: string; appId: string;
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
  var path_594794 = newJObject()
  var query_594795 = newJObject()
  add(path_594794, "versionId", newJString(versionId))
  add(query_594795, "skip", newJInt(skip))
  add(query_594795, "take", newJInt(take))
  add(path_594794, "appId", newJString(appId))
  result = call_594793.call(path_594794, query_594795, nil, nil, nil)

var featuresList* = Call_FeaturesList_594785(name: "featuresList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/features",
    validator: validate_FeaturesList_594786, base: "", url: url_FeaturesList_594787,
    schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntity_594807 = ref object of OpenApiRestCall_593439
proc url_ModelAddHierarchicalEntity_594809(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntity_594808(path: JsonNode; query: JsonNode;
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
  var valid_594810 = path.getOrDefault("versionId")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "versionId", valid_594810
  var valid_594811 = path.getOrDefault("appId")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "appId", valid_594811
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

proc call*(call_594813: Call_ModelAddHierarchicalEntity_594807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a hierarchical entity extractor to a version of the application.
  ## 
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_ModelAddHierarchicalEntity_594807; versionId: string;
          hierarchicalModelCreateObject: JsonNode; appId: string): Recallable =
  ## modelAddHierarchicalEntity
  ## Adds a hierarchical entity extractor to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   hierarchicalModelCreateObject: JObject (required)
  ##                                : A model containing the name and children of the new entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_594815 = newJObject()
  var body_594816 = newJObject()
  add(path_594815, "versionId", newJString(versionId))
  if hierarchicalModelCreateObject != nil:
    body_594816 = hierarchicalModelCreateObject
  add(path_594815, "appId", newJString(appId))
  result = call_594814.call(path_594815, nil, nil, nil, body_594816)

var modelAddHierarchicalEntity* = Call_ModelAddHierarchicalEntity_594807(
    name: "modelAddHierarchicalEntity", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelAddHierarchicalEntity_594808, base: "",
    url: url_ModelAddHierarchicalEntity_594809, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntities_594796 = ref object of OpenApiRestCall_593439
proc url_ModelListHierarchicalEntities_594798(protocol: Scheme; host: string;
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

proc validate_ModelListHierarchicalEntities_594797(path: JsonNode; query: JsonNode;
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
  var valid_594799 = path.getOrDefault("versionId")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "versionId", valid_594799
  var valid_594800 = path.getOrDefault("appId")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "appId", valid_594800
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594801 = query.getOrDefault("skip")
  valid_594801 = validateParameter(valid_594801, JInt, required = false,
                                 default = newJInt(0))
  if valid_594801 != nil:
    section.add "skip", valid_594801
  var valid_594802 = query.getOrDefault("take")
  valid_594802 = validateParameter(valid_594802, JInt, required = false,
                                 default = newJInt(100))
  if valid_594802 != nil:
    section.add "take", valid_594802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594803: Call_ModelListHierarchicalEntities_594796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the hierarchical entity models in a version of the application.
  ## 
  let valid = call_594803.validator(path, query, header, formData, body)
  let scheme = call_594803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594803.url(scheme.get, call_594803.host, call_594803.base,
                         call_594803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594803, url, valid)

proc call*(call_594804: Call_ModelListHierarchicalEntities_594796;
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
  var path_594805 = newJObject()
  var query_594806 = newJObject()
  add(path_594805, "versionId", newJString(versionId))
  add(query_594806, "skip", newJInt(skip))
  add(query_594806, "take", newJInt(take))
  add(path_594805, "appId", newJString(appId))
  result = call_594804.call(path_594805, query_594806, nil, nil, nil)

var modelListHierarchicalEntities* = Call_ModelListHierarchicalEntities_594796(
    name: "modelListHierarchicalEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/hierarchicalentities",
    validator: validate_ModelListHierarchicalEntities_594797, base: "",
    url: url_ModelListHierarchicalEntities_594798, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntity_594826 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateHierarchicalEntity_594828(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntity_594827(path: JsonNode; query: JsonNode;
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
  var valid_594829 = path.getOrDefault("versionId")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "versionId", valid_594829
  var valid_594830 = path.getOrDefault("appId")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "appId", valid_594830
  var valid_594831 = path.getOrDefault("hEntityId")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "hEntityId", valid_594831
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

proc call*(call_594833: Call_ModelUpdateHierarchicalEntity_594826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name and children of a hierarchical entity model in a version of the application.
  ## 
  let valid = call_594833.validator(path, query, header, formData, body)
  let scheme = call_594833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594833.url(scheme.get, call_594833.host, call_594833.base,
                         call_594833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594833, url, valid)

proc call*(call_594834: Call_ModelUpdateHierarchicalEntity_594826;
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
  var path_594835 = newJObject()
  var body_594836 = newJObject()
  add(path_594835, "versionId", newJString(versionId))
  add(path_594835, "appId", newJString(appId))
  if hierarchicalModelUpdateObject != nil:
    body_594836 = hierarchicalModelUpdateObject
  add(path_594835, "hEntityId", newJString(hEntityId))
  result = call_594834.call(path_594835, nil, nil, nil, body_594836)

var modelUpdateHierarchicalEntity* = Call_ModelUpdateHierarchicalEntity_594826(
    name: "modelUpdateHierarchicalEntity", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelUpdateHierarchicalEntity_594827, base: "",
    url: url_ModelUpdateHierarchicalEntity_594828, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntity_594817 = ref object of OpenApiRestCall_593439
proc url_ModelGetHierarchicalEntity_594819(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntity_594818(path: JsonNode; query: JsonNode;
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
  var valid_594820 = path.getOrDefault("versionId")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "versionId", valid_594820
  var valid_594821 = path.getOrDefault("appId")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "appId", valid_594821
  var valid_594822 = path.getOrDefault("hEntityId")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "hEntityId", valid_594822
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594823: Call_ModelGetHierarchicalEntity_594817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a hierarchical entity in a version of the application.
  ## 
  let valid = call_594823.validator(path, query, header, formData, body)
  let scheme = call_594823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594823.url(scheme.get, call_594823.host, call_594823.base,
                         call_594823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594823, url, valid)

proc call*(call_594824: Call_ModelGetHierarchicalEntity_594817; versionId: string;
          appId: string; hEntityId: string): Recallable =
  ## modelGetHierarchicalEntity
  ## Gets information about a hierarchical entity in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_594825 = newJObject()
  add(path_594825, "versionId", newJString(versionId))
  add(path_594825, "appId", newJString(appId))
  add(path_594825, "hEntityId", newJString(hEntityId))
  result = call_594824.call(path_594825, nil, nil, nil, nil)

var modelGetHierarchicalEntity* = Call_ModelGetHierarchicalEntity_594817(
    name: "modelGetHierarchicalEntity", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelGetHierarchicalEntity_594818, base: "",
    url: url_ModelGetHierarchicalEntity_594819, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntity_594837 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteHierarchicalEntity_594839(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntity_594838(path: JsonNode; query: JsonNode;
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
  var valid_594840 = path.getOrDefault("versionId")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "versionId", valid_594840
  var valid_594841 = path.getOrDefault("appId")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "appId", valid_594841
  var valid_594842 = path.getOrDefault("hEntityId")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "hEntityId", valid_594842
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594843: Call_ModelDeleteHierarchicalEntity_594837; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a hierarchical entity from a version of the application.
  ## 
  let valid = call_594843.validator(path, query, header, formData, body)
  let scheme = call_594843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594843.url(scheme.get, call_594843.host, call_594843.base,
                         call_594843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594843, url, valid)

proc call*(call_594844: Call_ModelDeleteHierarchicalEntity_594837;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelDeleteHierarchicalEntity
  ## Deletes a hierarchical entity from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_594845 = newJObject()
  add(path_594845, "versionId", newJString(versionId))
  add(path_594845, "appId", newJString(appId))
  add(path_594845, "hEntityId", newJString(hEntityId))
  result = call_594844.call(path_594845, nil, nil, nil, nil)

var modelDeleteHierarchicalEntity* = Call_ModelDeleteHierarchicalEntity_594837(
    name: "modelDeleteHierarchicalEntity", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}",
    validator: validate_ModelDeleteHierarchicalEntity_594838, base: "",
    url: url_ModelDeleteHierarchicalEntity_594839, schemes: {Scheme.Https})
type
  Call_ModelAddHierarchicalEntityChild_594846 = ref object of OpenApiRestCall_593439
proc url_ModelAddHierarchicalEntityChild_594848(protocol: Scheme; host: string;
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

proc validate_ModelAddHierarchicalEntityChild_594847(path: JsonNode;
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
  var valid_594849 = path.getOrDefault("versionId")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "versionId", valid_594849
  var valid_594850 = path.getOrDefault("appId")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "appId", valid_594850
  var valid_594851 = path.getOrDefault("hEntityId")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "hEntityId", valid_594851
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

proc call*(call_594853: Call_ModelAddHierarchicalEntityChild_594846;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_594853.validator(path, query, header, formData, body)
  let scheme = call_594853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594853.url(scheme.get, call_594853.host, call_594853.base,
                         call_594853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594853, url, valid)

proc call*(call_594854: Call_ModelAddHierarchicalEntityChild_594846;
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
  var path_594855 = newJObject()
  var body_594856 = newJObject()
  add(path_594855, "versionId", newJString(versionId))
  if hierarchicalChildModelCreateObject != nil:
    body_594856 = hierarchicalChildModelCreateObject
  add(path_594855, "appId", newJString(appId))
  add(path_594855, "hEntityId", newJString(hEntityId))
  result = call_594854.call(path_594855, nil, nil, nil, body_594856)

var modelAddHierarchicalEntityChild* = Call_ModelAddHierarchicalEntityChild_594846(
    name: "modelAddHierarchicalEntityChild", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children",
    validator: validate_ModelAddHierarchicalEntityChild_594847, base: "",
    url: url_ModelAddHierarchicalEntityChild_594848, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityChild_594867 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateHierarchicalEntityChild_594869(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntityChild_594868(path: JsonNode;
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
  var valid_594870 = path.getOrDefault("versionId")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "versionId", valid_594870
  var valid_594871 = path.getOrDefault("appId")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "appId", valid_594871
  var valid_594872 = path.getOrDefault("hChildId")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = nil)
  if valid_594872 != nil:
    section.add "hChildId", valid_594872
  var valid_594873 = path.getOrDefault("hEntityId")
  valid_594873 = validateParameter(valid_594873, JString, required = true,
                                 default = nil)
  if valid_594873 != nil:
    section.add "hEntityId", valid_594873
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

proc call*(call_594875: Call_ModelUpdateHierarchicalEntityChild_594867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a single child in an existing hierarchical entity model in a version of the application.
  ## 
  let valid = call_594875.validator(path, query, header, formData, body)
  let scheme = call_594875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594875.url(scheme.get, call_594875.host, call_594875.base,
                         call_594875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594875, url, valid)

proc call*(call_594876: Call_ModelUpdateHierarchicalEntityChild_594867;
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
  var path_594877 = newJObject()
  var body_594878 = newJObject()
  add(path_594877, "versionId", newJString(versionId))
  if hierarchicalChildModelUpdateObject != nil:
    body_594878 = hierarchicalChildModelUpdateObject
  add(path_594877, "appId", newJString(appId))
  add(path_594877, "hChildId", newJString(hChildId))
  add(path_594877, "hEntityId", newJString(hEntityId))
  result = call_594876.call(path_594877, nil, nil, nil, body_594878)

var modelUpdateHierarchicalEntityChild* = Call_ModelUpdateHierarchicalEntityChild_594867(
    name: "modelUpdateHierarchicalEntityChild", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelUpdateHierarchicalEntityChild_594868, base: "",
    url: url_ModelUpdateHierarchicalEntityChild_594869, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityChild_594857 = ref object of OpenApiRestCall_593439
proc url_ModelGetHierarchicalEntityChild_594859(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntityChild_594858(path: JsonNode;
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
  var valid_594860 = path.getOrDefault("versionId")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "versionId", valid_594860
  var valid_594861 = path.getOrDefault("appId")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "appId", valid_594861
  var valid_594862 = path.getOrDefault("hChildId")
  valid_594862 = validateParameter(valid_594862, JString, required = true,
                                 default = nil)
  if valid_594862 != nil:
    section.add "hChildId", valid_594862
  var valid_594863 = path.getOrDefault("hEntityId")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "hEntityId", valid_594863
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594864: Call_ModelGetHierarchicalEntityChild_594857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about the child's model contained in an hierarchical entity child model in a version of the application.
  ## 
  let valid = call_594864.validator(path, query, header, formData, body)
  let scheme = call_594864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594864.url(scheme.get, call_594864.host, call_594864.base,
                         call_594864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594864, url, valid)

proc call*(call_594865: Call_ModelGetHierarchicalEntityChild_594857;
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
  var path_594866 = newJObject()
  add(path_594866, "versionId", newJString(versionId))
  add(path_594866, "appId", newJString(appId))
  add(path_594866, "hChildId", newJString(hChildId))
  add(path_594866, "hEntityId", newJString(hEntityId))
  result = call_594865.call(path_594866, nil, nil, nil, nil)

var modelGetHierarchicalEntityChild* = Call_ModelGetHierarchicalEntityChild_594857(
    name: "modelGetHierarchicalEntityChild", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelGetHierarchicalEntityChild_594858, base: "",
    url: url_ModelGetHierarchicalEntityChild_594859, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityChild_594879 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteHierarchicalEntityChild_594881(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntityChild_594880(path: JsonNode;
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
  var valid_594882 = path.getOrDefault("versionId")
  valid_594882 = validateParameter(valid_594882, JString, required = true,
                                 default = nil)
  if valid_594882 != nil:
    section.add "versionId", valid_594882
  var valid_594883 = path.getOrDefault("appId")
  valid_594883 = validateParameter(valid_594883, JString, required = true,
                                 default = nil)
  if valid_594883 != nil:
    section.add "appId", valid_594883
  var valid_594884 = path.getOrDefault("hChildId")
  valid_594884 = validateParameter(valid_594884, JString, required = true,
                                 default = nil)
  if valid_594884 != nil:
    section.add "hChildId", valid_594884
  var valid_594885 = path.getOrDefault("hEntityId")
  valid_594885 = validateParameter(valid_594885, JString, required = true,
                                 default = nil)
  if valid_594885 != nil:
    section.add "hEntityId", valid_594885
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594886: Call_ModelDeleteHierarchicalEntityChild_594879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a hierarchical entity extractor child in a version of the application.
  ## 
  let valid = call_594886.validator(path, query, header, formData, body)
  let scheme = call_594886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594886.url(scheme.get, call_594886.host, call_594886.base,
                         call_594886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594886, url, valid)

proc call*(call_594887: Call_ModelDeleteHierarchicalEntityChild_594879;
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
  var path_594888 = newJObject()
  add(path_594888, "versionId", newJString(versionId))
  add(path_594888, "appId", newJString(appId))
  add(path_594888, "hChildId", newJString(hChildId))
  add(path_594888, "hEntityId", newJString(hEntityId))
  result = call_594887.call(path_594888, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityChild* = Call_ModelDeleteHierarchicalEntityChild_594879(
    name: "modelDeleteHierarchicalEntityChild", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/children/{hChildId}",
    validator: validate_ModelDeleteHierarchicalEntityChild_594880, base: "",
    url: url_ModelDeleteHierarchicalEntityChild_594881, schemes: {Scheme.Https})
type
  Call_ModelCreateHierarchicalEntityRole_594898 = ref object of OpenApiRestCall_593439
proc url_ModelCreateHierarchicalEntityRole_594900(protocol: Scheme; host: string;
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

proc validate_ModelCreateHierarchicalEntityRole_594899(path: JsonNode;
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
  var valid_594901 = path.getOrDefault("versionId")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "versionId", valid_594901
  var valid_594902 = path.getOrDefault("appId")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "appId", valid_594902
  var valid_594903 = path.getOrDefault("hEntityId")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "hEntityId", valid_594903
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

proc call*(call_594905: Call_ModelCreateHierarchicalEntityRole_594898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594905.validator(path, query, header, formData, body)
  let scheme = call_594905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594905.url(scheme.get, call_594905.host, call_594905.base,
                         call_594905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594905, url, valid)

proc call*(call_594906: Call_ModelCreateHierarchicalEntityRole_594898;
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
  var path_594907 = newJObject()
  var body_594908 = newJObject()
  add(path_594907, "versionId", newJString(versionId))
  if entityRoleCreateObject != nil:
    body_594908 = entityRoleCreateObject
  add(path_594907, "appId", newJString(appId))
  add(path_594907, "hEntityId", newJString(hEntityId))
  result = call_594906.call(path_594907, nil, nil, nil, body_594908)

var modelCreateHierarchicalEntityRole* = Call_ModelCreateHierarchicalEntityRole_594898(
    name: "modelCreateHierarchicalEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelCreateHierarchicalEntityRole_594899, base: "",
    url: url_ModelCreateHierarchicalEntityRole_594900, schemes: {Scheme.Https})
type
  Call_ModelListHierarchicalEntityRoles_594889 = ref object of OpenApiRestCall_593439
proc url_ModelListHierarchicalEntityRoles_594891(protocol: Scheme; host: string;
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

proc validate_ModelListHierarchicalEntityRoles_594890(path: JsonNode;
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
  var valid_594892 = path.getOrDefault("versionId")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "versionId", valid_594892
  var valid_594893 = path.getOrDefault("appId")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "appId", valid_594893
  var valid_594894 = path.getOrDefault("hEntityId")
  valid_594894 = validateParameter(valid_594894, JString, required = true,
                                 default = nil)
  if valid_594894 != nil:
    section.add "hEntityId", valid_594894
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594895: Call_ModelListHierarchicalEntityRoles_594889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594895.validator(path, query, header, formData, body)
  let scheme = call_594895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594895.url(scheme.get, call_594895.host, call_594895.base,
                         call_594895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594895, url, valid)

proc call*(call_594896: Call_ModelListHierarchicalEntityRoles_594889;
          versionId: string; appId: string; hEntityId: string): Recallable =
  ## modelListHierarchicalEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   hEntityId: string (required)
  ##            : The hierarchical entity extractor ID.
  var path_594897 = newJObject()
  add(path_594897, "versionId", newJString(versionId))
  add(path_594897, "appId", newJString(appId))
  add(path_594897, "hEntityId", newJString(hEntityId))
  result = call_594896.call(path_594897, nil, nil, nil, nil)

var modelListHierarchicalEntityRoles* = Call_ModelListHierarchicalEntityRoles_594889(
    name: "modelListHierarchicalEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles",
    validator: validate_ModelListHierarchicalEntityRoles_594890, base: "",
    url: url_ModelListHierarchicalEntityRoles_594891, schemes: {Scheme.Https})
type
  Call_ModelUpdateHierarchicalEntityRole_594919 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateHierarchicalEntityRole_594921(protocol: Scheme; host: string;
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

proc validate_ModelUpdateHierarchicalEntityRole_594920(path: JsonNode;
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
  var valid_594922 = path.getOrDefault("versionId")
  valid_594922 = validateParameter(valid_594922, JString, required = true,
                                 default = nil)
  if valid_594922 != nil:
    section.add "versionId", valid_594922
  var valid_594923 = path.getOrDefault("appId")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = nil)
  if valid_594923 != nil:
    section.add "appId", valid_594923
  var valid_594924 = path.getOrDefault("roleId")
  valid_594924 = validateParameter(valid_594924, JString, required = true,
                                 default = nil)
  if valid_594924 != nil:
    section.add "roleId", valid_594924
  var valid_594925 = path.getOrDefault("hEntityId")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "hEntityId", valid_594925
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

proc call*(call_594927: Call_ModelUpdateHierarchicalEntityRole_594919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594927.validator(path, query, header, formData, body)
  let scheme = call_594927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594927.url(scheme.get, call_594927.host, call_594927.base,
                         call_594927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594927, url, valid)

proc call*(call_594928: Call_ModelUpdateHierarchicalEntityRole_594919;
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
  var path_594929 = newJObject()
  var body_594930 = newJObject()
  add(path_594929, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_594930 = entityRoleUpdateObject
  add(path_594929, "appId", newJString(appId))
  add(path_594929, "roleId", newJString(roleId))
  add(path_594929, "hEntityId", newJString(hEntityId))
  result = call_594928.call(path_594929, nil, nil, nil, body_594930)

var modelUpdateHierarchicalEntityRole* = Call_ModelUpdateHierarchicalEntityRole_594919(
    name: "modelUpdateHierarchicalEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelUpdateHierarchicalEntityRole_594920, base: "",
    url: url_ModelUpdateHierarchicalEntityRole_594921, schemes: {Scheme.Https})
type
  Call_ModelGetHierarchicalEntityRole_594909 = ref object of OpenApiRestCall_593439
proc url_ModelGetHierarchicalEntityRole_594911(protocol: Scheme; host: string;
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

proc validate_ModelGetHierarchicalEntityRole_594910(path: JsonNode;
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
  var valid_594912 = path.getOrDefault("versionId")
  valid_594912 = validateParameter(valid_594912, JString, required = true,
                                 default = nil)
  if valid_594912 != nil:
    section.add "versionId", valid_594912
  var valid_594913 = path.getOrDefault("appId")
  valid_594913 = validateParameter(valid_594913, JString, required = true,
                                 default = nil)
  if valid_594913 != nil:
    section.add "appId", valid_594913
  var valid_594914 = path.getOrDefault("roleId")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "roleId", valid_594914
  var valid_594915 = path.getOrDefault("hEntityId")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "hEntityId", valid_594915
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594916: Call_ModelGetHierarchicalEntityRole_594909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594916.validator(path, query, header, formData, body)
  let scheme = call_594916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594916.url(scheme.get, call_594916.host, call_594916.base,
                         call_594916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594916, url, valid)

proc call*(call_594917: Call_ModelGetHierarchicalEntityRole_594909;
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
  var path_594918 = newJObject()
  add(path_594918, "versionId", newJString(versionId))
  add(path_594918, "appId", newJString(appId))
  add(path_594918, "roleId", newJString(roleId))
  add(path_594918, "hEntityId", newJString(hEntityId))
  result = call_594917.call(path_594918, nil, nil, nil, nil)

var modelGetHierarchicalEntityRole* = Call_ModelGetHierarchicalEntityRole_594909(
    name: "modelGetHierarchicalEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelGetHierarchicalEntityRole_594910, base: "",
    url: url_ModelGetHierarchicalEntityRole_594911, schemes: {Scheme.Https})
type
  Call_ModelDeleteHierarchicalEntityRole_594931 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteHierarchicalEntityRole_594933(protocol: Scheme; host: string;
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

proc validate_ModelDeleteHierarchicalEntityRole_594932(path: JsonNode;
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
  var valid_594934 = path.getOrDefault("versionId")
  valid_594934 = validateParameter(valid_594934, JString, required = true,
                                 default = nil)
  if valid_594934 != nil:
    section.add "versionId", valid_594934
  var valid_594935 = path.getOrDefault("appId")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "appId", valid_594935
  var valid_594936 = path.getOrDefault("roleId")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "roleId", valid_594936
  var valid_594937 = path.getOrDefault("hEntityId")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = nil)
  if valid_594937 != nil:
    section.add "hEntityId", valid_594937
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594938: Call_ModelDeleteHierarchicalEntityRole_594931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594938.validator(path, query, header, formData, body)
  let scheme = call_594938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594938.url(scheme.get, call_594938.host, call_594938.base,
                         call_594938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594938, url, valid)

proc call*(call_594939: Call_ModelDeleteHierarchicalEntityRole_594931;
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
  var path_594940 = newJObject()
  add(path_594940, "versionId", newJString(versionId))
  add(path_594940, "appId", newJString(appId))
  add(path_594940, "roleId", newJString(roleId))
  add(path_594940, "hEntityId", newJString(hEntityId))
  result = call_594939.call(path_594940, nil, nil, nil, nil)

var modelDeleteHierarchicalEntityRole* = Call_ModelDeleteHierarchicalEntityRole_594931(
    name: "modelDeleteHierarchicalEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/hierarchicalentities/{hEntityId}/roles/{roleId}",
    validator: validate_ModelDeleteHierarchicalEntityRole_594932, base: "",
    url: url_ModelDeleteHierarchicalEntityRole_594933, schemes: {Scheme.Https})
type
  Call_ModelAddIntent_594952 = ref object of OpenApiRestCall_593439
proc url_ModelAddIntent_594954(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddIntent_594953(path: JsonNode; query: JsonNode;
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
  var valid_594955 = path.getOrDefault("versionId")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "versionId", valid_594955
  var valid_594956 = path.getOrDefault("appId")
  valid_594956 = validateParameter(valid_594956, JString, required = true,
                                 default = nil)
  if valid_594956 != nil:
    section.add "appId", valid_594956
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

proc call*(call_594958: Call_ModelAddIntent_594952; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an intent to a version of the application.
  ## 
  let valid = call_594958.validator(path, query, header, formData, body)
  let scheme = call_594958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594958.url(scheme.get, call_594958.host, call_594958.base,
                         call_594958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594958, url, valid)

proc call*(call_594959: Call_ModelAddIntent_594952; versionId: string; appId: string;
          intentCreateObject: JsonNode): Recallable =
  ## modelAddIntent
  ## Adds an intent to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentCreateObject: JObject (required)
  ##                     : A model object containing the name of the new intent.
  var path_594960 = newJObject()
  var body_594961 = newJObject()
  add(path_594960, "versionId", newJString(versionId))
  add(path_594960, "appId", newJString(appId))
  if intentCreateObject != nil:
    body_594961 = intentCreateObject
  result = call_594959.call(path_594960, nil, nil, nil, body_594961)

var modelAddIntent* = Call_ModelAddIntent_594952(name: "modelAddIntent",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelAddIntent_594953, base: "", url: url_ModelAddIntent_594954,
    schemes: {Scheme.Https})
type
  Call_ModelListIntents_594941 = ref object of OpenApiRestCall_593439
proc url_ModelListIntents_594943(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListIntents_594942(path: JsonNode; query: JsonNode;
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
  var valid_594944 = path.getOrDefault("versionId")
  valid_594944 = validateParameter(valid_594944, JString, required = true,
                                 default = nil)
  if valid_594944 != nil:
    section.add "versionId", valid_594944
  var valid_594945 = path.getOrDefault("appId")
  valid_594945 = validateParameter(valid_594945, JString, required = true,
                                 default = nil)
  if valid_594945 != nil:
    section.add "appId", valid_594945
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594946 = query.getOrDefault("skip")
  valid_594946 = validateParameter(valid_594946, JInt, required = false,
                                 default = newJInt(0))
  if valid_594946 != nil:
    section.add "skip", valid_594946
  var valid_594947 = query.getOrDefault("take")
  valid_594947 = validateParameter(valid_594947, JInt, required = false,
                                 default = newJInt(100))
  if valid_594947 != nil:
    section.add "take", valid_594947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594948: Call_ModelListIntents_594941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent models in a version of the application.
  ## 
  let valid = call_594948.validator(path, query, header, formData, body)
  let scheme = call_594948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594948.url(scheme.get, call_594948.host, call_594948.base,
                         call_594948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594948, url, valid)

proc call*(call_594949: Call_ModelListIntents_594941; versionId: string;
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
  var path_594950 = newJObject()
  var query_594951 = newJObject()
  add(path_594950, "versionId", newJString(versionId))
  add(query_594951, "skip", newJInt(skip))
  add(query_594951, "take", newJInt(take))
  add(path_594950, "appId", newJString(appId))
  result = call_594949.call(path_594950, query_594951, nil, nil, nil)

var modelListIntents* = Call_ModelListIntents_594941(name: "modelListIntents",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents",
    validator: validate_ModelListIntents_594942, base: "",
    url: url_ModelListIntents_594943, schemes: {Scheme.Https})
type
  Call_ModelUpdateIntent_594971 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateIntent_594973(protocol: Scheme; host: string; base: string;
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

proc validate_ModelUpdateIntent_594972(path: JsonNode; query: JsonNode;
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
  var valid_594974 = path.getOrDefault("versionId")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "versionId", valid_594974
  var valid_594975 = path.getOrDefault("appId")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "appId", valid_594975
  var valid_594976 = path.getOrDefault("intentId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "intentId", valid_594976
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

proc call*(call_594978: Call_ModelUpdateIntent_594971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name of an intent in a version of the application.
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_ModelUpdateIntent_594971; versionId: string;
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
  var path_594980 = newJObject()
  var body_594981 = newJObject()
  add(path_594980, "versionId", newJString(versionId))
  if modelUpdateObject != nil:
    body_594981 = modelUpdateObject
  add(path_594980, "appId", newJString(appId))
  add(path_594980, "intentId", newJString(intentId))
  result = call_594979.call(path_594980, nil, nil, nil, body_594981)

var modelUpdateIntent* = Call_ModelUpdateIntent_594971(name: "modelUpdateIntent",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelUpdateIntent_594972, base: "",
    url: url_ModelUpdateIntent_594973, schemes: {Scheme.Https})
type
  Call_ModelGetIntent_594962 = ref object of OpenApiRestCall_593439
proc url_ModelGetIntent_594964(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetIntent_594963(path: JsonNode; query: JsonNode;
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
  var valid_594965 = path.getOrDefault("versionId")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "versionId", valid_594965
  var valid_594966 = path.getOrDefault("appId")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "appId", valid_594966
  var valid_594967 = path.getOrDefault("intentId")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "intentId", valid_594967
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594968: Call_ModelGetIntent_594962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the intent model in a version of the application.
  ## 
  let valid = call_594968.validator(path, query, header, formData, body)
  let scheme = call_594968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594968.url(scheme.get, call_594968.host, call_594968.base,
                         call_594968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594968, url, valid)

proc call*(call_594969: Call_ModelGetIntent_594962; versionId: string; appId: string;
          intentId: string): Recallable =
  ## modelGetIntent
  ## Gets information about the intent model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   intentId: string (required)
  ##           : The intent classifier ID.
  var path_594970 = newJObject()
  add(path_594970, "versionId", newJString(versionId))
  add(path_594970, "appId", newJString(appId))
  add(path_594970, "intentId", newJString(intentId))
  result = call_594969.call(path_594970, nil, nil, nil, nil)

var modelGetIntent* = Call_ModelGetIntent_594962(name: "modelGetIntent",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelGetIntent_594963, base: "", url: url_ModelGetIntent_594964,
    schemes: {Scheme.Https})
type
  Call_ModelDeleteIntent_594982 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteIntent_594984(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeleteIntent_594983(path: JsonNode; query: JsonNode;
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
  var valid_594985 = path.getOrDefault("versionId")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = nil)
  if valid_594985 != nil:
    section.add "versionId", valid_594985
  var valid_594986 = path.getOrDefault("appId")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "appId", valid_594986
  var valid_594987 = path.getOrDefault("intentId")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "intentId", valid_594987
  result.add "path", section
  ## parameters in `query` object:
  ##   deleteUtterances: JBool
  ##                   : If true, deletes the intent's example utterances. If false, moves the example utterances to the None intent. The default value is false.
  section = newJObject()
  var valid_594988 = query.getOrDefault("deleteUtterances")
  valid_594988 = validateParameter(valid_594988, JBool, required = false,
                                 default = newJBool(false))
  if valid_594988 != nil:
    section.add "deleteUtterances", valid_594988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594989: Call_ModelDeleteIntent_594982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an intent from a version of the application.
  ## 
  let valid = call_594989.validator(path, query, header, formData, body)
  let scheme = call_594989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594989.url(scheme.get, call_594989.host, call_594989.base,
                         call_594989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594989, url, valid)

proc call*(call_594990: Call_ModelDeleteIntent_594982; versionId: string;
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
  var path_594991 = newJObject()
  var query_594992 = newJObject()
  add(path_594991, "versionId", newJString(versionId))
  add(query_594992, "deleteUtterances", newJBool(deleteUtterances))
  add(path_594991, "appId", newJString(appId))
  add(path_594991, "intentId", newJString(intentId))
  result = call_594990.call(path_594991, query_594992, nil, nil, nil)

var modelDeleteIntent* = Call_ModelDeleteIntent_594982(name: "modelDeleteIntent",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}",
    validator: validate_ModelDeleteIntent_594983, base: "",
    url: url_ModelDeleteIntent_594984, schemes: {Scheme.Https})
type
  Call_PatternListIntentPatterns_594993 = ref object of OpenApiRestCall_593439
proc url_PatternListIntentPatterns_594995(protocol: Scheme; host: string;
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

proc validate_PatternListIntentPatterns_594994(path: JsonNode; query: JsonNode;
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
  var valid_594996 = path.getOrDefault("versionId")
  valid_594996 = validateParameter(valid_594996, JString, required = true,
                                 default = nil)
  if valid_594996 != nil:
    section.add "versionId", valid_594996
  var valid_594997 = path.getOrDefault("appId")
  valid_594997 = validateParameter(valid_594997, JString, required = true,
                                 default = nil)
  if valid_594997 != nil:
    section.add "appId", valid_594997
  var valid_594998 = path.getOrDefault("intentId")
  valid_594998 = validateParameter(valid_594998, JString, required = true,
                                 default = nil)
  if valid_594998 != nil:
    section.add "intentId", valid_594998
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_594999 = query.getOrDefault("skip")
  valid_594999 = validateParameter(valid_594999, JInt, required = false,
                                 default = newJInt(0))
  if valid_594999 != nil:
    section.add "skip", valid_594999
  var valid_595000 = query.getOrDefault("take")
  valid_595000 = validateParameter(valid_595000, JInt, required = false,
                                 default = newJInt(100))
  if valid_595000 != nil:
    section.add "take", valid_595000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595001: Call_PatternListIntentPatterns_594993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595001.validator(path, query, header, formData, body)
  let scheme = call_595001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595001.url(scheme.get, call_595001.host, call_595001.base,
                         call_595001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595001, url, valid)

proc call*(call_595002: Call_PatternListIntentPatterns_594993; versionId: string;
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
  var path_595003 = newJObject()
  var query_595004 = newJObject()
  add(path_595003, "versionId", newJString(versionId))
  add(query_595004, "skip", newJInt(skip))
  add(query_595004, "take", newJInt(take))
  add(path_595003, "appId", newJString(appId))
  add(path_595003, "intentId", newJString(intentId))
  result = call_595002.call(path_595003, query_595004, nil, nil, nil)

var patternListIntentPatterns* = Call_PatternListIntentPatterns_594993(
    name: "patternListIntentPatterns", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/patternrules",
    validator: validate_PatternListIntentPatterns_594994, base: "",
    url: url_PatternListIntentPatterns_594995, schemes: {Scheme.Https})
type
  Call_ModelListIntentSuggestions_595005 = ref object of OpenApiRestCall_593439
proc url_ModelListIntentSuggestions_595007(protocol: Scheme; host: string;
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

proc validate_ModelListIntentSuggestions_595006(path: JsonNode; query: JsonNode;
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
  var valid_595008 = path.getOrDefault("versionId")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "versionId", valid_595008
  var valid_595009 = path.getOrDefault("appId")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = nil)
  if valid_595009 != nil:
    section.add "appId", valid_595009
  var valid_595010 = path.getOrDefault("intentId")
  valid_595010 = validateParameter(valid_595010, JString, required = true,
                                 default = nil)
  if valid_595010 != nil:
    section.add "intentId", valid_595010
  result.add "path", section
  ## parameters in `query` object:
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595011 = query.getOrDefault("take")
  valid_595011 = validateParameter(valid_595011, JInt, required = false,
                                 default = newJInt(100))
  if valid_595011 != nil:
    section.add "take", valid_595011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595012: Call_ModelListIntentSuggestions_595005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suggests example utterances that would improve the accuracy of the intent model in a version of the application.
  ## 
  let valid = call_595012.validator(path, query, header, formData, body)
  let scheme = call_595012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595012.url(scheme.get, call_595012.host, call_595012.base,
                         call_595012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595012, url, valid)

proc call*(call_595013: Call_ModelListIntentSuggestions_595005; versionId: string;
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
  var path_595014 = newJObject()
  var query_595015 = newJObject()
  add(path_595014, "versionId", newJString(versionId))
  add(query_595015, "take", newJInt(take))
  add(path_595014, "appId", newJString(appId))
  add(path_595014, "intentId", newJString(intentId))
  result = call_595013.call(path_595014, query_595015, nil, nil, nil)

var modelListIntentSuggestions* = Call_ModelListIntentSuggestions_595005(
    name: "modelListIntentSuggestions", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/intents/{intentId}/suggest",
    validator: validate_ModelListIntentSuggestions_595006, base: "",
    url: url_ModelListIntentSuggestions_595007, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntities_595016 = ref object of OpenApiRestCall_593439
proc url_ModelListPrebuiltEntities_595018(protocol: Scheme; host: string;
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

proc validate_ModelListPrebuiltEntities_595017(path: JsonNode; query: JsonNode;
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
  var valid_595019 = path.getOrDefault("versionId")
  valid_595019 = validateParameter(valid_595019, JString, required = true,
                                 default = nil)
  if valid_595019 != nil:
    section.add "versionId", valid_595019
  var valid_595020 = path.getOrDefault("appId")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "appId", valid_595020
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595021: Call_ModelListPrebuiltEntities_595016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available prebuilt entities in a version of the application.
  ## 
  let valid = call_595021.validator(path, query, header, formData, body)
  let scheme = call_595021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595021.url(scheme.get, call_595021.host, call_595021.base,
                         call_595021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595021, url, valid)

proc call*(call_595022: Call_ModelListPrebuiltEntities_595016; versionId: string;
          appId: string): Recallable =
  ## modelListPrebuiltEntities
  ## Gets all the available prebuilt entities in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595023 = newJObject()
  add(path_595023, "versionId", newJString(versionId))
  add(path_595023, "appId", newJString(appId))
  result = call_595022.call(path_595023, nil, nil, nil, nil)

var modelListPrebuiltEntities* = Call_ModelListPrebuiltEntities_595016(
    name: "modelListPrebuiltEntities", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/listprebuilts",
    validator: validate_ModelListPrebuiltEntities_595017, base: "",
    url: url_ModelListPrebuiltEntities_595018, schemes: {Scheme.Https})
type
  Call_ModelListModels_595024 = ref object of OpenApiRestCall_593439
proc url_ModelListModels_595026(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListModels_595025(path: JsonNode; query: JsonNode;
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
  var valid_595027 = path.getOrDefault("versionId")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "versionId", valid_595027
  var valid_595028 = path.getOrDefault("appId")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "appId", valid_595028
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595029 = query.getOrDefault("skip")
  valid_595029 = validateParameter(valid_595029, JInt, required = false,
                                 default = newJInt(0))
  if valid_595029 != nil:
    section.add "skip", valid_595029
  var valid_595030 = query.getOrDefault("take")
  valid_595030 = validateParameter(valid_595030, JInt, required = false,
                                 default = newJInt(100))
  if valid_595030 != nil:
    section.add "take", valid_595030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595031: Call_ModelListModels_595024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the intent and entity models in a version of the application.
  ## 
  let valid = call_595031.validator(path, query, header, formData, body)
  let scheme = call_595031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595031.url(scheme.get, call_595031.host, call_595031.base,
                         call_595031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595031, url, valid)

proc call*(call_595032: Call_ModelListModels_595024; versionId: string;
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
  var path_595033 = newJObject()
  var query_595034 = newJObject()
  add(path_595033, "versionId", newJString(versionId))
  add(query_595034, "skip", newJInt(skip))
  add(query_595034, "take", newJInt(take))
  add(path_595033, "appId", newJString(appId))
  result = call_595032.call(path_595033, query_595034, nil, nil, nil)

var modelListModels* = Call_ModelListModels_595024(name: "modelListModels",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models",
    validator: validate_ModelListModels_595025, base: "", url: url_ModelListModels_595026,
    schemes: {Scheme.Https})
type
  Call_ModelExamples_595035 = ref object of OpenApiRestCall_593439
proc url_ModelExamples_595037(protocol: Scheme; host: string; base: string;
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

proc validate_ModelExamples_595036(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595038 = path.getOrDefault("versionId")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "versionId", valid_595038
  var valid_595039 = path.getOrDefault("appId")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = nil)
  if valid_595039 != nil:
    section.add "appId", valid_595039
  var valid_595040 = path.getOrDefault("modelId")
  valid_595040 = validateParameter(valid_595040, JString, required = true,
                                 default = nil)
  if valid_595040 != nil:
    section.add "modelId", valid_595040
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595041 = query.getOrDefault("skip")
  valid_595041 = validateParameter(valid_595041, JInt, required = false,
                                 default = newJInt(0))
  if valid_595041 != nil:
    section.add "skip", valid_595041
  var valid_595042 = query.getOrDefault("take")
  valid_595042 = validateParameter(valid_595042, JInt, required = false,
                                 default = newJInt(100))
  if valid_595042 != nil:
    section.add "take", valid_595042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595043: Call_ModelExamples_595035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the example utterances for the given intent or entity model in a version of the application.
  ## 
  let valid = call_595043.validator(path, query, header, formData, body)
  let scheme = call_595043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595043.url(scheme.get, call_595043.host, call_595043.base,
                         call_595043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595043, url, valid)

proc call*(call_595044: Call_ModelExamples_595035; versionId: string; appId: string;
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
  var path_595045 = newJObject()
  var query_595046 = newJObject()
  add(path_595045, "versionId", newJString(versionId))
  add(query_595046, "skip", newJInt(skip))
  add(query_595046, "take", newJInt(take))
  add(path_595045, "appId", newJString(appId))
  add(path_595045, "modelId", newJString(modelId))
  result = call_595044.call(path_595045, query_595046, nil, nil, nil)

var modelExamples* = Call_ModelExamples_595035(name: "modelExamples",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/models/{modelId}/examples",
    validator: validate_ModelExamples_595036, base: "", url: url_ModelExamples_595037,
    schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityModel_595058 = ref object of OpenApiRestCall_593439
proc url_ModelCreatePatternAnyEntityModel_595060(protocol: Scheme; host: string;
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

proc validate_ModelCreatePatternAnyEntityModel_595059(path: JsonNode;
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
  var valid_595061 = path.getOrDefault("versionId")
  valid_595061 = validateParameter(valid_595061, JString, required = true,
                                 default = nil)
  if valid_595061 != nil:
    section.add "versionId", valid_595061
  var valid_595062 = path.getOrDefault("appId")
  valid_595062 = validateParameter(valid_595062, JString, required = true,
                                 default = nil)
  if valid_595062 != nil:
    section.add "appId", valid_595062
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

proc call*(call_595064: Call_ModelCreatePatternAnyEntityModel_595058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595064.validator(path, query, header, formData, body)
  let scheme = call_595064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595064.url(scheme.get, call_595064.host, call_595064.base,
                         call_595064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595064, url, valid)

proc call*(call_595065: Call_ModelCreatePatternAnyEntityModel_595058;
          versionId: string; extractorCreateObject: JsonNode; appId: string): Recallable =
  ## modelCreatePatternAnyEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   extractorCreateObject: JObject (required)
  ##                        : A model object containing the name and explicit list for the new Pattern.Any entity extractor.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595066 = newJObject()
  var body_595067 = newJObject()
  add(path_595066, "versionId", newJString(versionId))
  if extractorCreateObject != nil:
    body_595067 = extractorCreateObject
  add(path_595066, "appId", newJString(appId))
  result = call_595065.call(path_595066, nil, nil, nil, body_595067)

var modelCreatePatternAnyEntityModel* = Call_ModelCreatePatternAnyEntityModel_595058(
    name: "modelCreatePatternAnyEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelCreatePatternAnyEntityModel_595059, base: "",
    url: url_ModelCreatePatternAnyEntityModel_595060, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityInfos_595047 = ref object of OpenApiRestCall_593439
proc url_ModelListPatternAnyEntityInfos_595049(protocol: Scheme; host: string;
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

proc validate_ModelListPatternAnyEntityInfos_595048(path: JsonNode;
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
  var valid_595050 = path.getOrDefault("versionId")
  valid_595050 = validateParameter(valid_595050, JString, required = true,
                                 default = nil)
  if valid_595050 != nil:
    section.add "versionId", valid_595050
  var valid_595051 = path.getOrDefault("appId")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "appId", valid_595051
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595052 = query.getOrDefault("skip")
  valid_595052 = validateParameter(valid_595052, JInt, required = false,
                                 default = newJInt(0))
  if valid_595052 != nil:
    section.add "skip", valid_595052
  var valid_595053 = query.getOrDefault("take")
  valid_595053 = validateParameter(valid_595053, JInt, required = false,
                                 default = newJInt(100))
  if valid_595053 != nil:
    section.add "take", valid_595053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595054: Call_ModelListPatternAnyEntityInfos_595047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595054.validator(path, query, header, formData, body)
  let scheme = call_595054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595054.url(scheme.get, call_595054.host, call_595054.base,
                         call_595054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595054, url, valid)

proc call*(call_595055: Call_ModelListPatternAnyEntityInfos_595047;
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
  var path_595056 = newJObject()
  var query_595057 = newJObject()
  add(path_595056, "versionId", newJString(versionId))
  add(query_595057, "skip", newJInt(skip))
  add(query_595057, "take", newJInt(take))
  add(path_595056, "appId", newJString(appId))
  result = call_595055.call(path_595056, query_595057, nil, nil, nil)

var modelListPatternAnyEntityInfos* = Call_ModelListPatternAnyEntityInfos_595047(
    name: "modelListPatternAnyEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities",
    validator: validate_ModelListPatternAnyEntityInfos_595048, base: "",
    url: url_ModelListPatternAnyEntityInfos_595049, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityModel_595077 = ref object of OpenApiRestCall_593439
proc url_ModelUpdatePatternAnyEntityModel_595079(protocol: Scheme; host: string;
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

proc validate_ModelUpdatePatternAnyEntityModel_595078(path: JsonNode;
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
  var valid_595080 = path.getOrDefault("versionId")
  valid_595080 = validateParameter(valid_595080, JString, required = true,
                                 default = nil)
  if valid_595080 != nil:
    section.add "versionId", valid_595080
  var valid_595081 = path.getOrDefault("entityId")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "entityId", valid_595081
  var valid_595082 = path.getOrDefault("appId")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "appId", valid_595082
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

proc call*(call_595084: Call_ModelUpdatePatternAnyEntityModel_595077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595084.validator(path, query, header, formData, body)
  let scheme = call_595084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595084.url(scheme.get, call_595084.host, call_595084.base,
                         call_595084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595084, url, valid)

proc call*(call_595085: Call_ModelUpdatePatternAnyEntityModel_595077;
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
  var path_595086 = newJObject()
  var body_595087 = newJObject()
  add(path_595086, "versionId", newJString(versionId))
  add(path_595086, "entityId", newJString(entityId))
  add(path_595086, "appId", newJString(appId))
  if patternAnyUpdateObject != nil:
    body_595087 = patternAnyUpdateObject
  result = call_595085.call(path_595086, nil, nil, nil, body_595087)

var modelUpdatePatternAnyEntityModel* = Call_ModelUpdatePatternAnyEntityModel_595077(
    name: "modelUpdatePatternAnyEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelUpdatePatternAnyEntityModel_595078, base: "",
    url: url_ModelUpdatePatternAnyEntityModel_595079, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityInfo_595068 = ref object of OpenApiRestCall_593439
proc url_ModelGetPatternAnyEntityInfo_595070(protocol: Scheme; host: string;
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

proc validate_ModelGetPatternAnyEntityInfo_595069(path: JsonNode; query: JsonNode;
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
  var valid_595071 = path.getOrDefault("versionId")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "versionId", valid_595071
  var valid_595072 = path.getOrDefault("entityId")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "entityId", valid_595072
  var valid_595073 = path.getOrDefault("appId")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "appId", valid_595073
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595074: Call_ModelGetPatternAnyEntityInfo_595068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595074.validator(path, query, header, formData, body)
  let scheme = call_595074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595074.url(scheme.get, call_595074.host, call_595074.base,
                         call_595074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595074, url, valid)

proc call*(call_595075: Call_ModelGetPatternAnyEntityInfo_595068;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelGetPatternAnyEntityInfo
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595076 = newJObject()
  add(path_595076, "versionId", newJString(versionId))
  add(path_595076, "entityId", newJString(entityId))
  add(path_595076, "appId", newJString(appId))
  result = call_595075.call(path_595076, nil, nil, nil, nil)

var modelGetPatternAnyEntityInfo* = Call_ModelGetPatternAnyEntityInfo_595068(
    name: "modelGetPatternAnyEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelGetPatternAnyEntityInfo_595069, base: "",
    url: url_ModelGetPatternAnyEntityInfo_595070, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityModel_595088 = ref object of OpenApiRestCall_593439
proc url_ModelDeletePatternAnyEntityModel_595090(protocol: Scheme; host: string;
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

proc validate_ModelDeletePatternAnyEntityModel_595089(path: JsonNode;
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
  var valid_595091 = path.getOrDefault("versionId")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "versionId", valid_595091
  var valid_595092 = path.getOrDefault("entityId")
  valid_595092 = validateParameter(valid_595092, JString, required = true,
                                 default = nil)
  if valid_595092 != nil:
    section.add "entityId", valid_595092
  var valid_595093 = path.getOrDefault("appId")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "appId", valid_595093
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595094: Call_ModelDeletePatternAnyEntityModel_595088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595094.validator(path, query, header, formData, body)
  let scheme = call_595094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595094.url(scheme.get, call_595094.host, call_595094.base,
                         call_595094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595094, url, valid)

proc call*(call_595095: Call_ModelDeletePatternAnyEntityModel_595088;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelDeletePatternAnyEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595096 = newJObject()
  add(path_595096, "versionId", newJString(versionId))
  add(path_595096, "entityId", newJString(entityId))
  add(path_595096, "appId", newJString(appId))
  result = call_595095.call(path_595096, nil, nil, nil, nil)

var modelDeletePatternAnyEntityModel* = Call_ModelDeletePatternAnyEntityModel_595088(
    name: "modelDeletePatternAnyEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}",
    validator: validate_ModelDeletePatternAnyEntityModel_595089, base: "",
    url: url_ModelDeletePatternAnyEntityModel_595090, schemes: {Scheme.Https})
type
  Call_ModelAddExplicitListItem_595106 = ref object of OpenApiRestCall_593439
proc url_ModelAddExplicitListItem_595108(protocol: Scheme; host: string;
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

proc validate_ModelAddExplicitListItem_595107(path: JsonNode; query: JsonNode;
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
  var valid_595109 = path.getOrDefault("versionId")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "versionId", valid_595109
  var valid_595110 = path.getOrDefault("entityId")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = nil)
  if valid_595110 != nil:
    section.add "entityId", valid_595110
  var valid_595111 = path.getOrDefault("appId")
  valid_595111 = validateParameter(valid_595111, JString, required = true,
                                 default = nil)
  if valid_595111 != nil:
    section.add "appId", valid_595111
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

proc call*(call_595113: Call_ModelAddExplicitListItem_595106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595113.validator(path, query, header, formData, body)
  let scheme = call_595113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595113.url(scheme.get, call_595113.host, call_595113.base,
                         call_595113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595113, url, valid)

proc call*(call_595114: Call_ModelAddExplicitListItem_595106; versionId: string;
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
  var path_595115 = newJObject()
  var body_595116 = newJObject()
  add(path_595115, "versionId", newJString(versionId))
  add(path_595115, "entityId", newJString(entityId))
  if item != nil:
    body_595116 = item
  add(path_595115, "appId", newJString(appId))
  result = call_595114.call(path_595115, nil, nil, nil, body_595116)

var modelAddExplicitListItem* = Call_ModelAddExplicitListItem_595106(
    name: "modelAddExplicitListItem", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelAddExplicitListItem_595107, base: "",
    url: url_ModelAddExplicitListItem_595108, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitList_595097 = ref object of OpenApiRestCall_593439
proc url_ModelGetExplicitList_595099(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetExplicitList_595098(path: JsonNode; query: JsonNode;
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
  var valid_595100 = path.getOrDefault("versionId")
  valid_595100 = validateParameter(valid_595100, JString, required = true,
                                 default = nil)
  if valid_595100 != nil:
    section.add "versionId", valid_595100
  var valid_595101 = path.getOrDefault("entityId")
  valid_595101 = validateParameter(valid_595101, JString, required = true,
                                 default = nil)
  if valid_595101 != nil:
    section.add "entityId", valid_595101
  var valid_595102 = path.getOrDefault("appId")
  valid_595102 = validateParameter(valid_595102, JString, required = true,
                                 default = nil)
  if valid_595102 != nil:
    section.add "appId", valid_595102
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595103: Call_ModelGetExplicitList_595097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595103.validator(path, query, header, formData, body)
  let scheme = call_595103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595103.url(scheme.get, call_595103.host, call_595103.base,
                         call_595103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595103, url, valid)

proc call*(call_595104: Call_ModelGetExplicitList_595097; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelGetExplicitList
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : The Pattern.Any entity id.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595105 = newJObject()
  add(path_595105, "versionId", newJString(versionId))
  add(path_595105, "entityId", newJString(entityId))
  add(path_595105, "appId", newJString(appId))
  result = call_595104.call(path_595105, nil, nil, nil, nil)

var modelGetExplicitList* = Call_ModelGetExplicitList_595097(
    name: "modelGetExplicitList", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist",
    validator: validate_ModelGetExplicitList_595098, base: "",
    url: url_ModelGetExplicitList_595099, schemes: {Scheme.Https})
type
  Call_ModelUpdateExplicitListItem_595127 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateExplicitListItem_595129(protocol: Scheme; host: string;
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

proc validate_ModelUpdateExplicitListItem_595128(path: JsonNode; query: JsonNode;
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
  var valid_595130 = path.getOrDefault("versionId")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "versionId", valid_595130
  var valid_595131 = path.getOrDefault("entityId")
  valid_595131 = validateParameter(valid_595131, JString, required = true,
                                 default = nil)
  if valid_595131 != nil:
    section.add "entityId", valid_595131
  var valid_595132 = path.getOrDefault("appId")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "appId", valid_595132
  var valid_595133 = path.getOrDefault("itemId")
  valid_595133 = validateParameter(valid_595133, JInt, required = true, default = nil)
  if valid_595133 != nil:
    section.add "itemId", valid_595133
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

proc call*(call_595135: Call_ModelUpdateExplicitListItem_595127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595135.validator(path, query, header, formData, body)
  let scheme = call_595135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595135.url(scheme.get, call_595135.host, call_595135.base,
                         call_595135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595135, url, valid)

proc call*(call_595136: Call_ModelUpdateExplicitListItem_595127; versionId: string;
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
  var path_595137 = newJObject()
  var body_595138 = newJObject()
  add(path_595137, "versionId", newJString(versionId))
  add(path_595137, "entityId", newJString(entityId))
  if item != nil:
    body_595138 = item
  add(path_595137, "appId", newJString(appId))
  add(path_595137, "itemId", newJInt(itemId))
  result = call_595136.call(path_595137, nil, nil, nil, body_595138)

var modelUpdateExplicitListItem* = Call_ModelUpdateExplicitListItem_595127(
    name: "modelUpdateExplicitListItem", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelUpdateExplicitListItem_595128, base: "",
    url: url_ModelUpdateExplicitListItem_595129, schemes: {Scheme.Https})
type
  Call_ModelGetExplicitListItem_595117 = ref object of OpenApiRestCall_593439
proc url_ModelGetExplicitListItem_595119(protocol: Scheme; host: string;
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

proc validate_ModelGetExplicitListItem_595118(path: JsonNode; query: JsonNode;
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
  var valid_595120 = path.getOrDefault("versionId")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "versionId", valid_595120
  var valid_595121 = path.getOrDefault("entityId")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "entityId", valid_595121
  var valid_595122 = path.getOrDefault("appId")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "appId", valid_595122
  var valid_595123 = path.getOrDefault("itemId")
  valid_595123 = validateParameter(valid_595123, JInt, required = true, default = nil)
  if valid_595123 != nil:
    section.add "itemId", valid_595123
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595124: Call_ModelGetExplicitListItem_595117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595124.validator(path, query, header, formData, body)
  let scheme = call_595124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595124.url(scheme.get, call_595124.host, call_595124.base,
                         call_595124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595124, url, valid)

proc call*(call_595125: Call_ModelGetExplicitListItem_595117; versionId: string;
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
  var path_595126 = newJObject()
  add(path_595126, "versionId", newJString(versionId))
  add(path_595126, "entityId", newJString(entityId))
  add(path_595126, "appId", newJString(appId))
  add(path_595126, "itemId", newJInt(itemId))
  result = call_595125.call(path_595126, nil, nil, nil, nil)

var modelGetExplicitListItem* = Call_ModelGetExplicitListItem_595117(
    name: "modelGetExplicitListItem", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelGetExplicitListItem_595118, base: "",
    url: url_ModelGetExplicitListItem_595119, schemes: {Scheme.Https})
type
  Call_ModelDeleteExplicitListItem_595139 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteExplicitListItem_595141(protocol: Scheme; host: string;
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

proc validate_ModelDeleteExplicitListItem_595140(path: JsonNode; query: JsonNode;
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
  var valid_595142 = path.getOrDefault("versionId")
  valid_595142 = validateParameter(valid_595142, JString, required = true,
                                 default = nil)
  if valid_595142 != nil:
    section.add "versionId", valid_595142
  var valid_595143 = path.getOrDefault("entityId")
  valid_595143 = validateParameter(valid_595143, JString, required = true,
                                 default = nil)
  if valid_595143 != nil:
    section.add "entityId", valid_595143
  var valid_595144 = path.getOrDefault("appId")
  valid_595144 = validateParameter(valid_595144, JString, required = true,
                                 default = nil)
  if valid_595144 != nil:
    section.add "appId", valid_595144
  var valid_595145 = path.getOrDefault("itemId")
  valid_595145 = validateParameter(valid_595145, JInt, required = true, default = nil)
  if valid_595145 != nil:
    section.add "itemId", valid_595145
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595146: Call_ModelDeleteExplicitListItem_595139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595146.validator(path, query, header, formData, body)
  let scheme = call_595146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595146.url(scheme.get, call_595146.host, call_595146.base,
                         call_595146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595146, url, valid)

proc call*(call_595147: Call_ModelDeleteExplicitListItem_595139; versionId: string;
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
  var path_595148 = newJObject()
  add(path_595148, "versionId", newJString(versionId))
  add(path_595148, "entityId", newJString(entityId))
  add(path_595148, "appId", newJString(appId))
  add(path_595148, "itemId", newJInt(itemId))
  result = call_595147.call(path_595148, nil, nil, nil, nil)

var modelDeleteExplicitListItem* = Call_ModelDeleteExplicitListItem_595139(
    name: "modelDeleteExplicitListItem", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/explicitlist/{itemId}",
    validator: validate_ModelDeleteExplicitListItem_595140, base: "",
    url: url_ModelDeleteExplicitListItem_595141, schemes: {Scheme.Https})
type
  Call_ModelCreatePatternAnyEntityRole_595158 = ref object of OpenApiRestCall_593439
proc url_ModelCreatePatternAnyEntityRole_595160(protocol: Scheme; host: string;
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

proc validate_ModelCreatePatternAnyEntityRole_595159(path: JsonNode;
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
  var valid_595161 = path.getOrDefault("versionId")
  valid_595161 = validateParameter(valid_595161, JString, required = true,
                                 default = nil)
  if valid_595161 != nil:
    section.add "versionId", valid_595161
  var valid_595162 = path.getOrDefault("entityId")
  valid_595162 = validateParameter(valid_595162, JString, required = true,
                                 default = nil)
  if valid_595162 != nil:
    section.add "entityId", valid_595162
  var valid_595163 = path.getOrDefault("appId")
  valid_595163 = validateParameter(valid_595163, JString, required = true,
                                 default = nil)
  if valid_595163 != nil:
    section.add "appId", valid_595163
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

proc call*(call_595165: Call_ModelCreatePatternAnyEntityRole_595158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595165.validator(path, query, header, formData, body)
  let scheme = call_595165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595165.url(scheme.get, call_595165.host, call_595165.base,
                         call_595165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595165, url, valid)

proc call*(call_595166: Call_ModelCreatePatternAnyEntityRole_595158;
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
  var path_595167 = newJObject()
  var body_595168 = newJObject()
  add(path_595167, "versionId", newJString(versionId))
  add(path_595167, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_595168 = entityRoleCreateObject
  add(path_595167, "appId", newJString(appId))
  result = call_595166.call(path_595167, nil, nil, nil, body_595168)

var modelCreatePatternAnyEntityRole* = Call_ModelCreatePatternAnyEntityRole_595158(
    name: "modelCreatePatternAnyEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelCreatePatternAnyEntityRole_595159, base: "",
    url: url_ModelCreatePatternAnyEntityRole_595160, schemes: {Scheme.Https})
type
  Call_ModelListPatternAnyEntityRoles_595149 = ref object of OpenApiRestCall_593439
proc url_ModelListPatternAnyEntityRoles_595151(protocol: Scheme; host: string;
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

proc validate_ModelListPatternAnyEntityRoles_595150(path: JsonNode;
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
  var valid_595152 = path.getOrDefault("versionId")
  valid_595152 = validateParameter(valid_595152, JString, required = true,
                                 default = nil)
  if valid_595152 != nil:
    section.add "versionId", valid_595152
  var valid_595153 = path.getOrDefault("entityId")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "entityId", valid_595153
  var valid_595154 = path.getOrDefault("appId")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = nil)
  if valid_595154 != nil:
    section.add "appId", valid_595154
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595155: Call_ModelListPatternAnyEntityRoles_595149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595155.validator(path, query, header, formData, body)
  let scheme = call_595155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595155.url(scheme.get, call_595155.host, call_595155.base,
                         call_595155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595155, url, valid)

proc call*(call_595156: Call_ModelListPatternAnyEntityRoles_595149;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListPatternAnyEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_595157 = newJObject()
  add(path_595157, "versionId", newJString(versionId))
  add(path_595157, "entityId", newJString(entityId))
  add(path_595157, "appId", newJString(appId))
  result = call_595156.call(path_595157, nil, nil, nil, nil)

var modelListPatternAnyEntityRoles* = Call_ModelListPatternAnyEntityRoles_595149(
    name: "modelListPatternAnyEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles",
    validator: validate_ModelListPatternAnyEntityRoles_595150, base: "",
    url: url_ModelListPatternAnyEntityRoles_595151, schemes: {Scheme.Https})
type
  Call_ModelUpdatePatternAnyEntityRole_595179 = ref object of OpenApiRestCall_593439
proc url_ModelUpdatePatternAnyEntityRole_595181(protocol: Scheme; host: string;
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

proc validate_ModelUpdatePatternAnyEntityRole_595180(path: JsonNode;
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
  var valid_595182 = path.getOrDefault("versionId")
  valid_595182 = validateParameter(valid_595182, JString, required = true,
                                 default = nil)
  if valid_595182 != nil:
    section.add "versionId", valid_595182
  var valid_595183 = path.getOrDefault("entityId")
  valid_595183 = validateParameter(valid_595183, JString, required = true,
                                 default = nil)
  if valid_595183 != nil:
    section.add "entityId", valid_595183
  var valid_595184 = path.getOrDefault("appId")
  valid_595184 = validateParameter(valid_595184, JString, required = true,
                                 default = nil)
  if valid_595184 != nil:
    section.add "appId", valid_595184
  var valid_595185 = path.getOrDefault("roleId")
  valid_595185 = validateParameter(valid_595185, JString, required = true,
                                 default = nil)
  if valid_595185 != nil:
    section.add "roleId", valid_595185
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

proc call*(call_595187: Call_ModelUpdatePatternAnyEntityRole_595179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595187.validator(path, query, header, formData, body)
  let scheme = call_595187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595187.url(scheme.get, call_595187.host, call_595187.base,
                         call_595187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595187, url, valid)

proc call*(call_595188: Call_ModelUpdatePatternAnyEntityRole_595179;
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
  var path_595189 = newJObject()
  var body_595190 = newJObject()
  add(path_595189, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_595190 = entityRoleUpdateObject
  add(path_595189, "entityId", newJString(entityId))
  add(path_595189, "appId", newJString(appId))
  add(path_595189, "roleId", newJString(roleId))
  result = call_595188.call(path_595189, nil, nil, nil, body_595190)

var modelUpdatePatternAnyEntityRole* = Call_ModelUpdatePatternAnyEntityRole_595179(
    name: "modelUpdatePatternAnyEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePatternAnyEntityRole_595180, base: "",
    url: url_ModelUpdatePatternAnyEntityRole_595181, schemes: {Scheme.Https})
type
  Call_ModelGetPatternAnyEntityRole_595169 = ref object of OpenApiRestCall_593439
proc url_ModelGetPatternAnyEntityRole_595171(protocol: Scheme; host: string;
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

proc validate_ModelGetPatternAnyEntityRole_595170(path: JsonNode; query: JsonNode;
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
  var valid_595172 = path.getOrDefault("versionId")
  valid_595172 = validateParameter(valid_595172, JString, required = true,
                                 default = nil)
  if valid_595172 != nil:
    section.add "versionId", valid_595172
  var valid_595173 = path.getOrDefault("entityId")
  valid_595173 = validateParameter(valid_595173, JString, required = true,
                                 default = nil)
  if valid_595173 != nil:
    section.add "entityId", valid_595173
  var valid_595174 = path.getOrDefault("appId")
  valid_595174 = validateParameter(valid_595174, JString, required = true,
                                 default = nil)
  if valid_595174 != nil:
    section.add "appId", valid_595174
  var valid_595175 = path.getOrDefault("roleId")
  valid_595175 = validateParameter(valid_595175, JString, required = true,
                                 default = nil)
  if valid_595175 != nil:
    section.add "roleId", valid_595175
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595176: Call_ModelGetPatternAnyEntityRole_595169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595176.validator(path, query, header, formData, body)
  let scheme = call_595176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595176.url(scheme.get, call_595176.host, call_595176.base,
                         call_595176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595176, url, valid)

proc call*(call_595177: Call_ModelGetPatternAnyEntityRole_595169;
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
  var path_595178 = newJObject()
  add(path_595178, "versionId", newJString(versionId))
  add(path_595178, "entityId", newJString(entityId))
  add(path_595178, "appId", newJString(appId))
  add(path_595178, "roleId", newJString(roleId))
  result = call_595177.call(path_595178, nil, nil, nil, nil)

var modelGetPatternAnyEntityRole* = Call_ModelGetPatternAnyEntityRole_595169(
    name: "modelGetPatternAnyEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPatternAnyEntityRole_595170, base: "",
    url: url_ModelGetPatternAnyEntityRole_595171, schemes: {Scheme.Https})
type
  Call_ModelDeletePatternAnyEntityRole_595191 = ref object of OpenApiRestCall_593439
proc url_ModelDeletePatternAnyEntityRole_595193(protocol: Scheme; host: string;
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

proc validate_ModelDeletePatternAnyEntityRole_595192(path: JsonNode;
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
  var valid_595194 = path.getOrDefault("versionId")
  valid_595194 = validateParameter(valid_595194, JString, required = true,
                                 default = nil)
  if valid_595194 != nil:
    section.add "versionId", valid_595194
  var valid_595195 = path.getOrDefault("entityId")
  valid_595195 = validateParameter(valid_595195, JString, required = true,
                                 default = nil)
  if valid_595195 != nil:
    section.add "entityId", valid_595195
  var valid_595196 = path.getOrDefault("appId")
  valid_595196 = validateParameter(valid_595196, JString, required = true,
                                 default = nil)
  if valid_595196 != nil:
    section.add "appId", valid_595196
  var valid_595197 = path.getOrDefault("roleId")
  valid_595197 = validateParameter(valid_595197, JString, required = true,
                                 default = nil)
  if valid_595197 != nil:
    section.add "roleId", valid_595197
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595198: Call_ModelDeletePatternAnyEntityRole_595191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_595198.validator(path, query, header, formData, body)
  let scheme = call_595198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595198.url(scheme.get, call_595198.host, call_595198.base,
                         call_595198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595198, url, valid)

proc call*(call_595199: Call_ModelDeletePatternAnyEntityRole_595191;
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
  var path_595200 = newJObject()
  add(path_595200, "versionId", newJString(versionId))
  add(path_595200, "entityId", newJString(entityId))
  add(path_595200, "appId", newJString(appId))
  add(path_595200, "roleId", newJString(roleId))
  result = call_595199.call(path_595200, nil, nil, nil, nil)

var modelDeletePatternAnyEntityRole* = Call_ModelDeletePatternAnyEntityRole_595191(
    name: "modelDeletePatternAnyEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patternanyentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePatternAnyEntityRole_595192, base: "",
    url: url_ModelDeletePatternAnyEntityRole_595193, schemes: {Scheme.Https})
type
  Call_PatternAddPattern_595201 = ref object of OpenApiRestCall_593439
proc url_PatternAddPattern_595203(protocol: Scheme; host: string; base: string;
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

proc validate_PatternAddPattern_595202(path: JsonNode; query: JsonNode;
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
  var valid_595204 = path.getOrDefault("versionId")
  valid_595204 = validateParameter(valid_595204, JString, required = true,
                                 default = nil)
  if valid_595204 != nil:
    section.add "versionId", valid_595204
  var valid_595205 = path.getOrDefault("appId")
  valid_595205 = validateParameter(valid_595205, JString, required = true,
                                 default = nil)
  if valid_595205 != nil:
    section.add "appId", valid_595205
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

proc call*(call_595207: Call_PatternAddPattern_595201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595207.validator(path, query, header, formData, body)
  let scheme = call_595207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595207.url(scheme.get, call_595207.host, call_595207.base,
                         call_595207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595207, url, valid)

proc call*(call_595208: Call_PatternAddPattern_595201; versionId: string;
          pattern: JsonNode; appId: string): Recallable =
  ## patternAddPattern
  ##   versionId: string (required)
  ##            : The version ID.
  ##   pattern: JObject (required)
  ##          : The input pattern.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595209 = newJObject()
  var body_595210 = newJObject()
  add(path_595209, "versionId", newJString(versionId))
  if pattern != nil:
    body_595210 = pattern
  add(path_595209, "appId", newJString(appId))
  result = call_595208.call(path_595209, nil, nil, nil, body_595210)

var patternAddPattern* = Call_PatternAddPattern_595201(name: "patternAddPattern",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrule",
    validator: validate_PatternAddPattern_595202, base: "",
    url: url_PatternAddPattern_595203, schemes: {Scheme.Https})
type
  Call_PatternUpdatePatterns_595222 = ref object of OpenApiRestCall_593439
proc url_PatternUpdatePatterns_595224(protocol: Scheme; host: string; base: string;
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

proc validate_PatternUpdatePatterns_595223(path: JsonNode; query: JsonNode;
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
  var valid_595225 = path.getOrDefault("versionId")
  valid_595225 = validateParameter(valid_595225, JString, required = true,
                                 default = nil)
  if valid_595225 != nil:
    section.add "versionId", valid_595225
  var valid_595226 = path.getOrDefault("appId")
  valid_595226 = validateParameter(valid_595226, JString, required = true,
                                 default = nil)
  if valid_595226 != nil:
    section.add "appId", valid_595226
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

proc call*(call_595228: Call_PatternUpdatePatterns_595222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595228.validator(path, query, header, formData, body)
  let scheme = call_595228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595228.url(scheme.get, call_595228.host, call_595228.base,
                         call_595228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595228, url, valid)

proc call*(call_595229: Call_PatternUpdatePatterns_595222; versionId: string;
          patterns: JsonNode; appId: string): Recallable =
  ## patternUpdatePatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patterns: JArray (required)
  ##           : An array represents the patterns.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595230 = newJObject()
  var body_595231 = newJObject()
  add(path_595230, "versionId", newJString(versionId))
  if patterns != nil:
    body_595231 = patterns
  add(path_595230, "appId", newJString(appId))
  result = call_595229.call(path_595230, nil, nil, nil, body_595231)

var patternUpdatePatterns* = Call_PatternUpdatePatterns_595222(
    name: "patternUpdatePatterns", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternUpdatePatterns_595223, base: "",
    url: url_PatternUpdatePatterns_595224, schemes: {Scheme.Https})
type
  Call_PatternBatchAddPatterns_595232 = ref object of OpenApiRestCall_593439
proc url_PatternBatchAddPatterns_595234(protocol: Scheme; host: string; base: string;
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

proc validate_PatternBatchAddPatterns_595233(path: JsonNode; query: JsonNode;
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
  var valid_595235 = path.getOrDefault("versionId")
  valid_595235 = validateParameter(valid_595235, JString, required = true,
                                 default = nil)
  if valid_595235 != nil:
    section.add "versionId", valid_595235
  var valid_595236 = path.getOrDefault("appId")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = nil)
  if valid_595236 != nil:
    section.add "appId", valid_595236
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

proc call*(call_595238: Call_PatternBatchAddPatterns_595232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595238.validator(path, query, header, formData, body)
  let scheme = call_595238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595238.url(scheme.get, call_595238.host, call_595238.base,
                         call_595238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595238, url, valid)

proc call*(call_595239: Call_PatternBatchAddPatterns_595232; versionId: string;
          patterns: JsonNode; appId: string): Recallable =
  ## patternBatchAddPatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patterns: JArray (required)
  ##           : A JSON array containing patterns.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595240 = newJObject()
  var body_595241 = newJObject()
  add(path_595240, "versionId", newJString(versionId))
  if patterns != nil:
    body_595241 = patterns
  add(path_595240, "appId", newJString(appId))
  result = call_595239.call(path_595240, nil, nil, nil, body_595241)

var patternBatchAddPatterns* = Call_PatternBatchAddPatterns_595232(
    name: "patternBatchAddPatterns", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternBatchAddPatterns_595233, base: "",
    url: url_PatternBatchAddPatterns_595234, schemes: {Scheme.Https})
type
  Call_PatternListPatterns_595211 = ref object of OpenApiRestCall_593439
proc url_PatternListPatterns_595213(protocol: Scheme; host: string; base: string;
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

proc validate_PatternListPatterns_595212(path: JsonNode; query: JsonNode;
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
  var valid_595214 = path.getOrDefault("versionId")
  valid_595214 = validateParameter(valid_595214, JString, required = true,
                                 default = nil)
  if valid_595214 != nil:
    section.add "versionId", valid_595214
  var valid_595215 = path.getOrDefault("appId")
  valid_595215 = validateParameter(valid_595215, JString, required = true,
                                 default = nil)
  if valid_595215 != nil:
    section.add "appId", valid_595215
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595216 = query.getOrDefault("skip")
  valid_595216 = validateParameter(valid_595216, JInt, required = false,
                                 default = newJInt(0))
  if valid_595216 != nil:
    section.add "skip", valid_595216
  var valid_595217 = query.getOrDefault("take")
  valid_595217 = validateParameter(valid_595217, JInt, required = false,
                                 default = newJInt(100))
  if valid_595217 != nil:
    section.add "take", valid_595217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595218: Call_PatternListPatterns_595211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595218.validator(path, query, header, formData, body)
  let scheme = call_595218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595218.url(scheme.get, call_595218.host, call_595218.base,
                         call_595218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595218, url, valid)

proc call*(call_595219: Call_PatternListPatterns_595211; versionId: string;
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
  var path_595220 = newJObject()
  var query_595221 = newJObject()
  add(path_595220, "versionId", newJString(versionId))
  add(query_595221, "skip", newJInt(skip))
  add(query_595221, "take", newJInt(take))
  add(path_595220, "appId", newJString(appId))
  result = call_595219.call(path_595220, query_595221, nil, nil, nil)

var patternListPatterns* = Call_PatternListPatterns_595211(
    name: "patternListPatterns", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternListPatterns_595212, base: "",
    url: url_PatternListPatterns_595213, schemes: {Scheme.Https})
type
  Call_PatternDeletePatterns_595242 = ref object of OpenApiRestCall_593439
proc url_PatternDeletePatterns_595244(protocol: Scheme; host: string; base: string;
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

proc validate_PatternDeletePatterns_595243(path: JsonNode; query: JsonNode;
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
  var valid_595245 = path.getOrDefault("versionId")
  valid_595245 = validateParameter(valid_595245, JString, required = true,
                                 default = nil)
  if valid_595245 != nil:
    section.add "versionId", valid_595245
  var valid_595246 = path.getOrDefault("appId")
  valid_595246 = validateParameter(valid_595246, JString, required = true,
                                 default = nil)
  if valid_595246 != nil:
    section.add "appId", valid_595246
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

proc call*(call_595248: Call_PatternDeletePatterns_595242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595248.validator(path, query, header, formData, body)
  let scheme = call_595248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595248.url(scheme.get, call_595248.host, call_595248.base,
                         call_595248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595248, url, valid)

proc call*(call_595249: Call_PatternDeletePatterns_595242; versionId: string;
          patternIds: JsonNode; appId: string): Recallable =
  ## patternDeletePatterns
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternIds: JArray (required)
  ##             : The patterns IDs.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595250 = newJObject()
  var body_595251 = newJObject()
  add(path_595250, "versionId", newJString(versionId))
  if patternIds != nil:
    body_595251 = patternIds
  add(path_595250, "appId", newJString(appId))
  result = call_595249.call(path_595250, nil, nil, nil, body_595251)

var patternDeletePatterns* = Call_PatternDeletePatterns_595242(
    name: "patternDeletePatterns", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules",
    validator: validate_PatternDeletePatterns_595243, base: "",
    url: url_PatternDeletePatterns_595244, schemes: {Scheme.Https})
type
  Call_PatternUpdatePattern_595252 = ref object of OpenApiRestCall_593439
proc url_PatternUpdatePattern_595254(protocol: Scheme; host: string; base: string;
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

proc validate_PatternUpdatePattern_595253(path: JsonNode; query: JsonNode;
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
  var valid_595255 = path.getOrDefault("versionId")
  valid_595255 = validateParameter(valid_595255, JString, required = true,
                                 default = nil)
  if valid_595255 != nil:
    section.add "versionId", valid_595255
  var valid_595256 = path.getOrDefault("patternId")
  valid_595256 = validateParameter(valid_595256, JString, required = true,
                                 default = nil)
  if valid_595256 != nil:
    section.add "patternId", valid_595256
  var valid_595257 = path.getOrDefault("appId")
  valid_595257 = validateParameter(valid_595257, JString, required = true,
                                 default = nil)
  if valid_595257 != nil:
    section.add "appId", valid_595257
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

proc call*(call_595259: Call_PatternUpdatePattern_595252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595259.validator(path, query, header, formData, body)
  let scheme = call_595259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595259.url(scheme.get, call_595259.host, call_595259.base,
                         call_595259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595259, url, valid)

proc call*(call_595260: Call_PatternUpdatePattern_595252; versionId: string;
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
  var path_595261 = newJObject()
  var body_595262 = newJObject()
  add(path_595261, "versionId", newJString(versionId))
  add(path_595261, "patternId", newJString(patternId))
  if pattern != nil:
    body_595262 = pattern
  add(path_595261, "appId", newJString(appId))
  result = call_595260.call(path_595261, nil, nil, nil, body_595262)

var patternUpdatePattern* = Call_PatternUpdatePattern_595252(
    name: "patternUpdatePattern", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternUpdatePattern_595253, base: "",
    url: url_PatternUpdatePattern_595254, schemes: {Scheme.Https})
type
  Call_PatternDeletePattern_595263 = ref object of OpenApiRestCall_593439
proc url_PatternDeletePattern_595265(protocol: Scheme; host: string; base: string;
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

proc validate_PatternDeletePattern_595264(path: JsonNode; query: JsonNode;
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
  var valid_595266 = path.getOrDefault("versionId")
  valid_595266 = validateParameter(valid_595266, JString, required = true,
                                 default = nil)
  if valid_595266 != nil:
    section.add "versionId", valid_595266
  var valid_595267 = path.getOrDefault("patternId")
  valid_595267 = validateParameter(valid_595267, JString, required = true,
                                 default = nil)
  if valid_595267 != nil:
    section.add "patternId", valid_595267
  var valid_595268 = path.getOrDefault("appId")
  valid_595268 = validateParameter(valid_595268, JString, required = true,
                                 default = nil)
  if valid_595268 != nil:
    section.add "appId", valid_595268
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595269: Call_PatternDeletePattern_595263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595269.validator(path, query, header, formData, body)
  let scheme = call_595269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595269.url(scheme.get, call_595269.host, call_595269.base,
                         call_595269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595269, url, valid)

proc call*(call_595270: Call_PatternDeletePattern_595263; versionId: string;
          patternId: string; appId: string): Recallable =
  ## patternDeletePattern
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: string (required)
  ##            : The pattern ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595271 = newJObject()
  add(path_595271, "versionId", newJString(versionId))
  add(path_595271, "patternId", newJString(patternId))
  add(path_595271, "appId", newJString(appId))
  result = call_595270.call(path_595271, nil, nil, nil, nil)

var patternDeletePattern* = Call_PatternDeletePattern_595263(
    name: "patternDeletePattern", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patternrules/{patternId}",
    validator: validate_PatternDeletePattern_595264, base: "",
    url: url_PatternDeletePattern_595265, schemes: {Scheme.Https})
type
  Call_FeaturesCreatePatternFeature_595283 = ref object of OpenApiRestCall_593439
proc url_FeaturesCreatePatternFeature_595285(protocol: Scheme; host: string;
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

proc validate_FeaturesCreatePatternFeature_595284(path: JsonNode; query: JsonNode;
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
  var valid_595286 = path.getOrDefault("versionId")
  valid_595286 = validateParameter(valid_595286, JString, required = true,
                                 default = nil)
  if valid_595286 != nil:
    section.add "versionId", valid_595286
  var valid_595287 = path.getOrDefault("appId")
  valid_595287 = validateParameter(valid_595287, JString, required = true,
                                 default = nil)
  if valid_595287 != nil:
    section.add "appId", valid_595287
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

proc call*(call_595289: Call_FeaturesCreatePatternFeature_595283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ## 
  let valid = call_595289.validator(path, query, header, formData, body)
  let scheme = call_595289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595289.url(scheme.get, call_595289.host, call_595289.base,
                         call_595289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595289, url, valid)

proc call*(call_595290: Call_FeaturesCreatePatternFeature_595283;
          patternCreateObject: JsonNode; versionId: string; appId: string): Recallable =
  ## featuresCreatePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Creates a new pattern feature in a version of the application.
  ##   patternCreateObject: JObject (required)
  ##                      : The Name and Pattern of the feature.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595291 = newJObject()
  var body_595292 = newJObject()
  if patternCreateObject != nil:
    body_595292 = patternCreateObject
  add(path_595291, "versionId", newJString(versionId))
  add(path_595291, "appId", newJString(appId))
  result = call_595290.call(path_595291, nil, nil, nil, body_595292)

var featuresCreatePatternFeature* = Call_FeaturesCreatePatternFeature_595283(
    name: "featuresCreatePatternFeature", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesCreatePatternFeature_595284, base: "",
    url: url_FeaturesCreatePatternFeature_595285, schemes: {Scheme.Https})
type
  Call_FeaturesListApplicationVersionPatternFeatures_595272 = ref object of OpenApiRestCall_593439
proc url_FeaturesListApplicationVersionPatternFeatures_595274(protocol: Scheme;
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

proc validate_FeaturesListApplicationVersionPatternFeatures_595273(
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
  var valid_595275 = path.getOrDefault("versionId")
  valid_595275 = validateParameter(valid_595275, JString, required = true,
                                 default = nil)
  if valid_595275 != nil:
    section.add "versionId", valid_595275
  var valid_595276 = path.getOrDefault("appId")
  valid_595276 = validateParameter(valid_595276, JString, required = true,
                                 default = nil)
  if valid_595276 != nil:
    section.add "appId", valid_595276
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595277 = query.getOrDefault("skip")
  valid_595277 = validateParameter(valid_595277, JInt, required = false,
                                 default = newJInt(0))
  if valid_595277 != nil:
    section.add "skip", valid_595277
  var valid_595278 = query.getOrDefault("take")
  valid_595278 = validateParameter(valid_595278, JInt, required = false,
                                 default = newJInt(100))
  if valid_595278 != nil:
    section.add "take", valid_595278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595279: Call_FeaturesListApplicationVersionPatternFeatures_595272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets all the pattern features.
  ## 
  let valid = call_595279.validator(path, query, header, formData, body)
  let scheme = call_595279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595279.url(scheme.get, call_595279.host, call_595279.base,
                         call_595279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595279, url, valid)

proc call*(call_595280: Call_FeaturesListApplicationVersionPatternFeatures_595272;
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
  var path_595281 = newJObject()
  var query_595282 = newJObject()
  add(path_595281, "versionId", newJString(versionId))
  add(query_595282, "skip", newJInt(skip))
  add(query_595282, "take", newJInt(take))
  add(path_595281, "appId", newJString(appId))
  result = call_595280.call(path_595281, query_595282, nil, nil, nil)

var featuresListApplicationVersionPatternFeatures* = Call_FeaturesListApplicationVersionPatternFeatures_595272(
    name: "featuresListApplicationVersionPatternFeatures",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns",
    validator: validate_FeaturesListApplicationVersionPatternFeatures_595273,
    base: "", url: url_FeaturesListApplicationVersionPatternFeatures_595274,
    schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePatternFeature_595302 = ref object of OpenApiRestCall_593439
proc url_FeaturesUpdatePatternFeature_595304(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePatternFeature_595303(path: JsonNode; query: JsonNode;
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
  var valid_595305 = path.getOrDefault("versionId")
  valid_595305 = validateParameter(valid_595305, JString, required = true,
                                 default = nil)
  if valid_595305 != nil:
    section.add "versionId", valid_595305
  var valid_595306 = path.getOrDefault("patternId")
  valid_595306 = validateParameter(valid_595306, JInt, required = true, default = nil)
  if valid_595306 != nil:
    section.add "patternId", valid_595306
  var valid_595307 = path.getOrDefault("appId")
  valid_595307 = validateParameter(valid_595307, JString, required = true,
                                 default = nil)
  if valid_595307 != nil:
    section.add "appId", valid_595307
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

proc call*(call_595309: Call_FeaturesUpdatePatternFeature_595302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Updates the pattern, the name and the state of the pattern feature in a version of the application.
  ## 
  let valid = call_595309.validator(path, query, header, formData, body)
  let scheme = call_595309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595309.url(scheme.get, call_595309.host, call_595309.base,
                         call_595309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595309, url, valid)

proc call*(call_595310: Call_FeaturesUpdatePatternFeature_595302;
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
  var path_595311 = newJObject()
  var body_595312 = newJObject()
  add(path_595311, "versionId", newJString(versionId))
  add(path_595311, "patternId", newJInt(patternId))
  add(path_595311, "appId", newJString(appId))
  if patternUpdateObject != nil:
    body_595312 = patternUpdateObject
  result = call_595310.call(path_595311, nil, nil, nil, body_595312)

var featuresUpdatePatternFeature* = Call_FeaturesUpdatePatternFeature_595302(
    name: "featuresUpdatePatternFeature", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesUpdatePatternFeature_595303, base: "",
    url: url_FeaturesUpdatePatternFeature_595304, schemes: {Scheme.Https})
type
  Call_FeaturesGetPatternFeatureInfo_595293 = ref object of OpenApiRestCall_593439
proc url_FeaturesGetPatternFeatureInfo_595295(protocol: Scheme; host: string;
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

proc validate_FeaturesGetPatternFeatureInfo_595294(path: JsonNode; query: JsonNode;
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
  var valid_595296 = path.getOrDefault("versionId")
  valid_595296 = validateParameter(valid_595296, JString, required = true,
                                 default = nil)
  if valid_595296 != nil:
    section.add "versionId", valid_595296
  var valid_595297 = path.getOrDefault("patternId")
  valid_595297 = validateParameter(valid_595297, JInt, required = true, default = nil)
  if valid_595297 != nil:
    section.add "patternId", valid_595297
  var valid_595298 = path.getOrDefault("appId")
  valid_595298 = validateParameter(valid_595298, JString, required = true,
                                 default = nil)
  if valid_595298 != nil:
    section.add "appId", valid_595298
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595299: Call_FeaturesGetPatternFeatureInfo_595293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ## 
  let valid = call_595299.validator(path, query, header, formData, body)
  let scheme = call_595299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595299.url(scheme.get, call_595299.host, call_595299.base,
                         call_595299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595299, url, valid)

proc call*(call_595300: Call_FeaturesGetPatternFeatureInfo_595293;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresGetPatternFeatureInfo
  ## [DEPRECATED NOTICE: This operation will soon be removed] Gets the specified pattern feature's info in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595301 = newJObject()
  add(path_595301, "versionId", newJString(versionId))
  add(path_595301, "patternId", newJInt(patternId))
  add(path_595301, "appId", newJString(appId))
  result = call_595300.call(path_595301, nil, nil, nil, nil)

var featuresGetPatternFeatureInfo* = Call_FeaturesGetPatternFeatureInfo_595293(
    name: "featuresGetPatternFeatureInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesGetPatternFeatureInfo_595294, base: "",
    url: url_FeaturesGetPatternFeatureInfo_595295, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePatternFeature_595313 = ref object of OpenApiRestCall_593439
proc url_FeaturesDeletePatternFeature_595315(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePatternFeature_595314(path: JsonNode; query: JsonNode;
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
  var valid_595316 = path.getOrDefault("versionId")
  valid_595316 = validateParameter(valid_595316, JString, required = true,
                                 default = nil)
  if valid_595316 != nil:
    section.add "versionId", valid_595316
  var valid_595317 = path.getOrDefault("patternId")
  valid_595317 = validateParameter(valid_595317, JInt, required = true, default = nil)
  if valid_595317 != nil:
    section.add "patternId", valid_595317
  var valid_595318 = path.getOrDefault("appId")
  valid_595318 = validateParameter(valid_595318, JString, required = true,
                                 default = nil)
  if valid_595318 != nil:
    section.add "appId", valid_595318
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595319: Call_FeaturesDeletePatternFeature_595313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ## 
  let valid = call_595319.validator(path, query, header, formData, body)
  let scheme = call_595319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595319.url(scheme.get, call_595319.host, call_595319.base,
                         call_595319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595319, url, valid)

proc call*(call_595320: Call_FeaturesDeletePatternFeature_595313;
          versionId: string; patternId: int; appId: string): Recallable =
  ## featuresDeletePatternFeature
  ## [DEPRECATED NOTICE: This operation will soon be removed] Deletes a pattern feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   patternId: int (required)
  ##            : The pattern feature ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595321 = newJObject()
  add(path_595321, "versionId", newJString(versionId))
  add(path_595321, "patternId", newJInt(patternId))
  add(path_595321, "appId", newJString(appId))
  result = call_595320.call(path_595321, nil, nil, nil, nil)

var featuresDeletePatternFeature* = Call_FeaturesDeletePatternFeature_595313(
    name: "featuresDeletePatternFeature", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/patterns/{patternId}",
    validator: validate_FeaturesDeletePatternFeature_595314, base: "",
    url: url_FeaturesDeletePatternFeature_595315, schemes: {Scheme.Https})
type
  Call_FeaturesAddPhraseList_595333 = ref object of OpenApiRestCall_593439
proc url_FeaturesAddPhraseList_595335(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesAddPhraseList_595334(path: JsonNode; query: JsonNode;
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
  var valid_595336 = path.getOrDefault("versionId")
  valid_595336 = validateParameter(valid_595336, JString, required = true,
                                 default = nil)
  if valid_595336 != nil:
    section.add "versionId", valid_595336
  var valid_595337 = path.getOrDefault("appId")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "appId", valid_595337
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

proc call*(call_595339: Call_FeaturesAddPhraseList_595333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new phraselist feature in a version of the application.
  ## 
  let valid = call_595339.validator(path, query, header, formData, body)
  let scheme = call_595339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595339.url(scheme.get, call_595339.host, call_595339.base,
                         call_595339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595339, url, valid)

proc call*(call_595340: Call_FeaturesAddPhraseList_595333; versionId: string;
          phraselistCreateObject: JsonNode; appId: string): Recallable =
  ## featuresAddPhraseList
  ## Creates a new phraselist feature in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistCreateObject: JObject (required)
  ##                         : A Phraselist object containing Name, comma-separated Phrases and the isExchangeable boolean. Default value for isExchangeable is true.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595341 = newJObject()
  var body_595342 = newJObject()
  add(path_595341, "versionId", newJString(versionId))
  if phraselistCreateObject != nil:
    body_595342 = phraselistCreateObject
  add(path_595341, "appId", newJString(appId))
  result = call_595340.call(path_595341, nil, nil, nil, body_595342)

var featuresAddPhraseList* = Call_FeaturesAddPhraseList_595333(
    name: "featuresAddPhraseList", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesAddPhraseList_595334, base: "",
    url: url_FeaturesAddPhraseList_595335, schemes: {Scheme.Https})
type
  Call_FeaturesListPhraseLists_595322 = ref object of OpenApiRestCall_593439
proc url_FeaturesListPhraseLists_595324(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesListPhraseLists_595323(path: JsonNode; query: JsonNode;
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
  var valid_595325 = path.getOrDefault("versionId")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = nil)
  if valid_595325 != nil:
    section.add "versionId", valid_595325
  var valid_595326 = path.getOrDefault("appId")
  valid_595326 = validateParameter(valid_595326, JString, required = true,
                                 default = nil)
  if valid_595326 != nil:
    section.add "appId", valid_595326
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595327 = query.getOrDefault("skip")
  valid_595327 = validateParameter(valid_595327, JInt, required = false,
                                 default = newJInt(0))
  if valid_595327 != nil:
    section.add "skip", valid_595327
  var valid_595328 = query.getOrDefault("take")
  valid_595328 = validateParameter(valid_595328, JInt, required = false,
                                 default = newJInt(100))
  if valid_595328 != nil:
    section.add "take", valid_595328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595329: Call_FeaturesListPhraseLists_595322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the phraselist features in a version of the application.
  ## 
  let valid = call_595329.validator(path, query, header, formData, body)
  let scheme = call_595329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595329.url(scheme.get, call_595329.host, call_595329.base,
                         call_595329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595329, url, valid)

proc call*(call_595330: Call_FeaturesListPhraseLists_595322; versionId: string;
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
  var path_595331 = newJObject()
  var query_595332 = newJObject()
  add(path_595331, "versionId", newJString(versionId))
  add(query_595332, "skip", newJInt(skip))
  add(query_595332, "take", newJInt(take))
  add(path_595331, "appId", newJString(appId))
  result = call_595330.call(path_595331, query_595332, nil, nil, nil)

var featuresListPhraseLists* = Call_FeaturesListPhraseLists_595322(
    name: "featuresListPhraseLists", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists",
    validator: validate_FeaturesListPhraseLists_595323, base: "",
    url: url_FeaturesListPhraseLists_595324, schemes: {Scheme.Https})
type
  Call_FeaturesUpdatePhraseList_595352 = ref object of OpenApiRestCall_593439
proc url_FeaturesUpdatePhraseList_595354(protocol: Scheme; host: string;
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

proc validate_FeaturesUpdatePhraseList_595353(path: JsonNode; query: JsonNode;
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
  var valid_595355 = path.getOrDefault("versionId")
  valid_595355 = validateParameter(valid_595355, JString, required = true,
                                 default = nil)
  if valid_595355 != nil:
    section.add "versionId", valid_595355
  var valid_595356 = path.getOrDefault("phraselistId")
  valid_595356 = validateParameter(valid_595356, JInt, required = true, default = nil)
  if valid_595356 != nil:
    section.add "phraselistId", valid_595356
  var valid_595357 = path.getOrDefault("appId")
  valid_595357 = validateParameter(valid_595357, JString, required = true,
                                 default = nil)
  if valid_595357 != nil:
    section.add "appId", valid_595357
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

proc call*(call_595359: Call_FeaturesUpdatePhraseList_595352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the phrases, the state and the name of the phraselist feature in a version of the application.
  ## 
  let valid = call_595359.validator(path, query, header, formData, body)
  let scheme = call_595359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595359.url(scheme.get, call_595359.host, call_595359.base,
                         call_595359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595359, url, valid)

proc call*(call_595360: Call_FeaturesUpdatePhraseList_595352; versionId: string;
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
  var path_595361 = newJObject()
  var body_595362 = newJObject()
  add(path_595361, "versionId", newJString(versionId))
  add(path_595361, "phraselistId", newJInt(phraselistId))
  add(path_595361, "appId", newJString(appId))
  if phraselistUpdateObject != nil:
    body_595362 = phraselistUpdateObject
  result = call_595360.call(path_595361, nil, nil, nil, body_595362)

var featuresUpdatePhraseList* = Call_FeaturesUpdatePhraseList_595352(
    name: "featuresUpdatePhraseList", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesUpdatePhraseList_595353, base: "",
    url: url_FeaturesUpdatePhraseList_595354, schemes: {Scheme.Https})
type
  Call_FeaturesGetPhraseList_595343 = ref object of OpenApiRestCall_593439
proc url_FeaturesGetPhraseList_595345(protocol: Scheme; host: string; base: string;
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

proc validate_FeaturesGetPhraseList_595344(path: JsonNode; query: JsonNode;
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
  var valid_595346 = path.getOrDefault("versionId")
  valid_595346 = validateParameter(valid_595346, JString, required = true,
                                 default = nil)
  if valid_595346 != nil:
    section.add "versionId", valid_595346
  var valid_595347 = path.getOrDefault("phraselistId")
  valid_595347 = validateParameter(valid_595347, JInt, required = true, default = nil)
  if valid_595347 != nil:
    section.add "phraselistId", valid_595347
  var valid_595348 = path.getOrDefault("appId")
  valid_595348 = validateParameter(valid_595348, JString, required = true,
                                 default = nil)
  if valid_595348 != nil:
    section.add "appId", valid_595348
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595349: Call_FeaturesGetPhraseList_595343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets phraselist feature info in a version of the application.
  ## 
  let valid = call_595349.validator(path, query, header, formData, body)
  let scheme = call_595349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595349.url(scheme.get, call_595349.host, call_595349.base,
                         call_595349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595349, url, valid)

proc call*(call_595350: Call_FeaturesGetPhraseList_595343; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresGetPhraseList
  ## Gets phraselist feature info in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be retrieved.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595351 = newJObject()
  add(path_595351, "versionId", newJString(versionId))
  add(path_595351, "phraselistId", newJInt(phraselistId))
  add(path_595351, "appId", newJString(appId))
  result = call_595350.call(path_595351, nil, nil, nil, nil)

var featuresGetPhraseList* = Call_FeaturesGetPhraseList_595343(
    name: "featuresGetPhraseList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesGetPhraseList_595344, base: "",
    url: url_FeaturesGetPhraseList_595345, schemes: {Scheme.Https})
type
  Call_FeaturesDeletePhraseList_595363 = ref object of OpenApiRestCall_593439
proc url_FeaturesDeletePhraseList_595365(protocol: Scheme; host: string;
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

proc validate_FeaturesDeletePhraseList_595364(path: JsonNode; query: JsonNode;
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
  var valid_595366 = path.getOrDefault("versionId")
  valid_595366 = validateParameter(valid_595366, JString, required = true,
                                 default = nil)
  if valid_595366 != nil:
    section.add "versionId", valid_595366
  var valid_595367 = path.getOrDefault("phraselistId")
  valid_595367 = validateParameter(valid_595367, JInt, required = true, default = nil)
  if valid_595367 != nil:
    section.add "phraselistId", valid_595367
  var valid_595368 = path.getOrDefault("appId")
  valid_595368 = validateParameter(valid_595368, JString, required = true,
                                 default = nil)
  if valid_595368 != nil:
    section.add "appId", valid_595368
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595369: Call_FeaturesDeletePhraseList_595363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a phraselist feature from a version of the application.
  ## 
  let valid = call_595369.validator(path, query, header, formData, body)
  let scheme = call_595369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595369.url(scheme.get, call_595369.host, call_595369.base,
                         call_595369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595369, url, valid)

proc call*(call_595370: Call_FeaturesDeletePhraseList_595363; versionId: string;
          phraselistId: int; appId: string): Recallable =
  ## featuresDeletePhraseList
  ## Deletes a phraselist feature from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   phraselistId: int (required)
  ##               : The ID of the feature to be deleted.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595371 = newJObject()
  add(path_595371, "versionId", newJString(versionId))
  add(path_595371, "phraselistId", newJInt(phraselistId))
  add(path_595371, "appId", newJString(appId))
  result = call_595370.call(path_595371, nil, nil, nil, nil)

var featuresDeletePhraseList* = Call_FeaturesDeletePhraseList_595363(
    name: "featuresDeletePhraseList", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/phraselists/{phraselistId}",
    validator: validate_FeaturesDeletePhraseList_595364, base: "",
    url: url_FeaturesDeletePhraseList_595365, schemes: {Scheme.Https})
type
  Call_ModelAddPrebuilt_595383 = ref object of OpenApiRestCall_593439
proc url_ModelAddPrebuilt_595385(protocol: Scheme; host: string; base: string;
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

proc validate_ModelAddPrebuilt_595384(path: JsonNode; query: JsonNode;
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
  var valid_595386 = path.getOrDefault("versionId")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "versionId", valid_595386
  var valid_595387 = path.getOrDefault("appId")
  valid_595387 = validateParameter(valid_595387, JString, required = true,
                                 default = nil)
  if valid_595387 != nil:
    section.add "appId", valid_595387
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

proc call*(call_595389: Call_ModelAddPrebuilt_595383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a list of prebuilt entities to a version of the application.
  ## 
  let valid = call_595389.validator(path, query, header, formData, body)
  let scheme = call_595389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595389.url(scheme.get, call_595389.host, call_595389.base,
                         call_595389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595389, url, valid)

proc call*(call_595390: Call_ModelAddPrebuilt_595383; versionId: string;
          appId: string; prebuiltExtractorNames: JsonNode): Recallable =
  ## modelAddPrebuilt
  ## Adds a list of prebuilt entities to a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   prebuiltExtractorNames: JArray (required)
  ##                         : An array of prebuilt entity extractor names.
  var path_595391 = newJObject()
  var body_595392 = newJObject()
  add(path_595391, "versionId", newJString(versionId))
  add(path_595391, "appId", newJString(appId))
  if prebuiltExtractorNames != nil:
    body_595392 = prebuiltExtractorNames
  result = call_595390.call(path_595391, nil, nil, nil, body_595392)

var modelAddPrebuilt* = Call_ModelAddPrebuilt_595383(name: "modelAddPrebuilt",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelAddPrebuilt_595384, base: "",
    url: url_ModelAddPrebuilt_595385, schemes: {Scheme.Https})
type
  Call_ModelListPrebuilts_595372 = ref object of OpenApiRestCall_593439
proc url_ModelListPrebuilts_595374(protocol: Scheme; host: string; base: string;
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

proc validate_ModelListPrebuilts_595373(path: JsonNode; query: JsonNode;
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
  var valid_595375 = path.getOrDefault("versionId")
  valid_595375 = validateParameter(valid_595375, JString, required = true,
                                 default = nil)
  if valid_595375 != nil:
    section.add "versionId", valid_595375
  var valid_595376 = path.getOrDefault("appId")
  valid_595376 = validateParameter(valid_595376, JString, required = true,
                                 default = nil)
  if valid_595376 != nil:
    section.add "appId", valid_595376
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595377 = query.getOrDefault("skip")
  valid_595377 = validateParameter(valid_595377, JInt, required = false,
                                 default = newJInt(0))
  if valid_595377 != nil:
    section.add "skip", valid_595377
  var valid_595378 = query.getOrDefault("take")
  valid_595378 = validateParameter(valid_595378, JInt, required = false,
                                 default = newJInt(100))
  if valid_595378 != nil:
    section.add "take", valid_595378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595379: Call_ModelListPrebuilts_595372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about all the prebuilt entities in a version of the application.
  ## 
  let valid = call_595379.validator(path, query, header, formData, body)
  let scheme = call_595379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595379.url(scheme.get, call_595379.host, call_595379.base,
                         call_595379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595379, url, valid)

proc call*(call_595380: Call_ModelListPrebuilts_595372; versionId: string;
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
  var path_595381 = newJObject()
  var query_595382 = newJObject()
  add(path_595381, "versionId", newJString(versionId))
  add(query_595382, "skip", newJInt(skip))
  add(query_595382, "take", newJInt(take))
  add(path_595381, "appId", newJString(appId))
  result = call_595380.call(path_595381, query_595382, nil, nil, nil)

var modelListPrebuilts* = Call_ModelListPrebuilts_595372(
    name: "modelListPrebuilts", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts",
    validator: validate_ModelListPrebuilts_595373, base: "",
    url: url_ModelListPrebuilts_595374, schemes: {Scheme.Https})
type
  Call_ModelCreatePrebuiltEntityRole_595402 = ref object of OpenApiRestCall_593439
proc url_ModelCreatePrebuiltEntityRole_595404(protocol: Scheme; host: string;
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

proc validate_ModelCreatePrebuiltEntityRole_595403(path: JsonNode; query: JsonNode;
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
  var valid_595405 = path.getOrDefault("versionId")
  valid_595405 = validateParameter(valid_595405, JString, required = true,
                                 default = nil)
  if valid_595405 != nil:
    section.add "versionId", valid_595405
  var valid_595406 = path.getOrDefault("entityId")
  valid_595406 = validateParameter(valid_595406, JString, required = true,
                                 default = nil)
  if valid_595406 != nil:
    section.add "entityId", valid_595406
  var valid_595407 = path.getOrDefault("appId")
  valid_595407 = validateParameter(valid_595407, JString, required = true,
                                 default = nil)
  if valid_595407 != nil:
    section.add "appId", valid_595407
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

proc call*(call_595409: Call_ModelCreatePrebuiltEntityRole_595402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595409.validator(path, query, header, formData, body)
  let scheme = call_595409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595409.url(scheme.get, call_595409.host, call_595409.base,
                         call_595409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595409, url, valid)

proc call*(call_595410: Call_ModelCreatePrebuiltEntityRole_595402;
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
  var path_595411 = newJObject()
  var body_595412 = newJObject()
  add(path_595411, "versionId", newJString(versionId))
  add(path_595411, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_595412 = entityRoleCreateObject
  add(path_595411, "appId", newJString(appId))
  result = call_595410.call(path_595411, nil, nil, nil, body_595412)

var modelCreatePrebuiltEntityRole* = Call_ModelCreatePrebuiltEntityRole_595402(
    name: "modelCreatePrebuiltEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelCreatePrebuiltEntityRole_595403, base: "",
    url: url_ModelCreatePrebuiltEntityRole_595404, schemes: {Scheme.Https})
type
  Call_ModelListPrebuiltEntityRoles_595393 = ref object of OpenApiRestCall_593439
proc url_ModelListPrebuiltEntityRoles_595395(protocol: Scheme; host: string;
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

proc validate_ModelListPrebuiltEntityRoles_595394(path: JsonNode; query: JsonNode;
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
  var valid_595396 = path.getOrDefault("versionId")
  valid_595396 = validateParameter(valid_595396, JString, required = true,
                                 default = nil)
  if valid_595396 != nil:
    section.add "versionId", valid_595396
  var valid_595397 = path.getOrDefault("entityId")
  valid_595397 = validateParameter(valid_595397, JString, required = true,
                                 default = nil)
  if valid_595397 != nil:
    section.add "entityId", valid_595397
  var valid_595398 = path.getOrDefault("appId")
  valid_595398 = validateParameter(valid_595398, JString, required = true,
                                 default = nil)
  if valid_595398 != nil:
    section.add "appId", valid_595398
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595399: Call_ModelListPrebuiltEntityRoles_595393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595399.validator(path, query, header, formData, body)
  let scheme = call_595399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595399.url(scheme.get, call_595399.host, call_595399.base,
                         call_595399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595399, url, valid)

proc call*(call_595400: Call_ModelListPrebuiltEntityRoles_595393;
          versionId: string; entityId: string; appId: string): Recallable =
  ## modelListPrebuiltEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_595401 = newJObject()
  add(path_595401, "versionId", newJString(versionId))
  add(path_595401, "entityId", newJString(entityId))
  add(path_595401, "appId", newJString(appId))
  result = call_595400.call(path_595401, nil, nil, nil, nil)

var modelListPrebuiltEntityRoles* = Call_ModelListPrebuiltEntityRoles_595393(
    name: "modelListPrebuiltEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles",
    validator: validate_ModelListPrebuiltEntityRoles_595394, base: "",
    url: url_ModelListPrebuiltEntityRoles_595395, schemes: {Scheme.Https})
type
  Call_ModelUpdatePrebuiltEntityRole_595423 = ref object of OpenApiRestCall_593439
proc url_ModelUpdatePrebuiltEntityRole_595425(protocol: Scheme; host: string;
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

proc validate_ModelUpdatePrebuiltEntityRole_595424(path: JsonNode; query: JsonNode;
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
  var valid_595426 = path.getOrDefault("versionId")
  valid_595426 = validateParameter(valid_595426, JString, required = true,
                                 default = nil)
  if valid_595426 != nil:
    section.add "versionId", valid_595426
  var valid_595427 = path.getOrDefault("entityId")
  valid_595427 = validateParameter(valid_595427, JString, required = true,
                                 default = nil)
  if valid_595427 != nil:
    section.add "entityId", valid_595427
  var valid_595428 = path.getOrDefault("appId")
  valid_595428 = validateParameter(valid_595428, JString, required = true,
                                 default = nil)
  if valid_595428 != nil:
    section.add "appId", valid_595428
  var valid_595429 = path.getOrDefault("roleId")
  valid_595429 = validateParameter(valid_595429, JString, required = true,
                                 default = nil)
  if valid_595429 != nil:
    section.add "roleId", valid_595429
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

proc call*(call_595431: Call_ModelUpdatePrebuiltEntityRole_595423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595431.validator(path, query, header, formData, body)
  let scheme = call_595431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595431.url(scheme.get, call_595431.host, call_595431.base,
                         call_595431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595431, url, valid)

proc call*(call_595432: Call_ModelUpdatePrebuiltEntityRole_595423;
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
  var path_595433 = newJObject()
  var body_595434 = newJObject()
  add(path_595433, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_595434 = entityRoleUpdateObject
  add(path_595433, "entityId", newJString(entityId))
  add(path_595433, "appId", newJString(appId))
  add(path_595433, "roleId", newJString(roleId))
  result = call_595432.call(path_595433, nil, nil, nil, body_595434)

var modelUpdatePrebuiltEntityRole* = Call_ModelUpdatePrebuiltEntityRole_595423(
    name: "modelUpdatePrebuiltEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdatePrebuiltEntityRole_595424, base: "",
    url: url_ModelUpdatePrebuiltEntityRole_595425, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuiltEntityRole_595413 = ref object of OpenApiRestCall_593439
proc url_ModelGetPrebuiltEntityRole_595415(protocol: Scheme; host: string;
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

proc validate_ModelGetPrebuiltEntityRole_595414(path: JsonNode; query: JsonNode;
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
  var valid_595416 = path.getOrDefault("versionId")
  valid_595416 = validateParameter(valid_595416, JString, required = true,
                                 default = nil)
  if valid_595416 != nil:
    section.add "versionId", valid_595416
  var valid_595417 = path.getOrDefault("entityId")
  valid_595417 = validateParameter(valid_595417, JString, required = true,
                                 default = nil)
  if valid_595417 != nil:
    section.add "entityId", valid_595417
  var valid_595418 = path.getOrDefault("appId")
  valid_595418 = validateParameter(valid_595418, JString, required = true,
                                 default = nil)
  if valid_595418 != nil:
    section.add "appId", valid_595418
  var valid_595419 = path.getOrDefault("roleId")
  valid_595419 = validateParameter(valid_595419, JString, required = true,
                                 default = nil)
  if valid_595419 != nil:
    section.add "roleId", valid_595419
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595420: Call_ModelGetPrebuiltEntityRole_595413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595420.validator(path, query, header, formData, body)
  let scheme = call_595420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595420.url(scheme.get, call_595420.host, call_595420.base,
                         call_595420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595420, url, valid)

proc call*(call_595421: Call_ModelGetPrebuiltEntityRole_595413; versionId: string;
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
  var path_595422 = newJObject()
  add(path_595422, "versionId", newJString(versionId))
  add(path_595422, "entityId", newJString(entityId))
  add(path_595422, "appId", newJString(appId))
  add(path_595422, "roleId", newJString(roleId))
  result = call_595421.call(path_595422, nil, nil, nil, nil)

var modelGetPrebuiltEntityRole* = Call_ModelGetPrebuiltEntityRole_595413(
    name: "modelGetPrebuiltEntityRole", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelGetPrebuiltEntityRole_595414, base: "",
    url: url_ModelGetPrebuiltEntityRole_595415, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuiltEntityRole_595435 = ref object of OpenApiRestCall_593439
proc url_ModelDeletePrebuiltEntityRole_595437(protocol: Scheme; host: string;
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

proc validate_ModelDeletePrebuiltEntityRole_595436(path: JsonNode; query: JsonNode;
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
  var valid_595438 = path.getOrDefault("versionId")
  valid_595438 = validateParameter(valid_595438, JString, required = true,
                                 default = nil)
  if valid_595438 != nil:
    section.add "versionId", valid_595438
  var valid_595439 = path.getOrDefault("entityId")
  valid_595439 = validateParameter(valid_595439, JString, required = true,
                                 default = nil)
  if valid_595439 != nil:
    section.add "entityId", valid_595439
  var valid_595440 = path.getOrDefault("appId")
  valid_595440 = validateParameter(valid_595440, JString, required = true,
                                 default = nil)
  if valid_595440 != nil:
    section.add "appId", valid_595440
  var valid_595441 = path.getOrDefault("roleId")
  valid_595441 = validateParameter(valid_595441, JString, required = true,
                                 default = nil)
  if valid_595441 != nil:
    section.add "roleId", valid_595441
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595442: Call_ModelDeletePrebuiltEntityRole_595435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595442.validator(path, query, header, formData, body)
  let scheme = call_595442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595442.url(scheme.get, call_595442.host, call_595442.base,
                         call_595442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595442, url, valid)

proc call*(call_595443: Call_ModelDeletePrebuiltEntityRole_595435;
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
  var path_595444 = newJObject()
  add(path_595444, "versionId", newJString(versionId))
  add(path_595444, "entityId", newJString(entityId))
  add(path_595444, "appId", newJString(appId))
  add(path_595444, "roleId", newJString(roleId))
  result = call_595443.call(path_595444, nil, nil, nil, nil)

var modelDeletePrebuiltEntityRole* = Call_ModelDeletePrebuiltEntityRole_595435(
    name: "modelDeletePrebuiltEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/prebuilts/{entityId}/roles/{roleId}",
    validator: validate_ModelDeletePrebuiltEntityRole_595436, base: "",
    url: url_ModelDeletePrebuiltEntityRole_595437, schemes: {Scheme.Https})
type
  Call_ModelGetPrebuilt_595445 = ref object of OpenApiRestCall_593439
proc url_ModelGetPrebuilt_595447(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetPrebuilt_595446(path: JsonNode; query: JsonNode;
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
  var valid_595448 = path.getOrDefault("versionId")
  valid_595448 = validateParameter(valid_595448, JString, required = true,
                                 default = nil)
  if valid_595448 != nil:
    section.add "versionId", valid_595448
  var valid_595449 = path.getOrDefault("prebuiltId")
  valid_595449 = validateParameter(valid_595449, JString, required = true,
                                 default = nil)
  if valid_595449 != nil:
    section.add "prebuiltId", valid_595449
  var valid_595450 = path.getOrDefault("appId")
  valid_595450 = validateParameter(valid_595450, JString, required = true,
                                 default = nil)
  if valid_595450 != nil:
    section.add "appId", valid_595450
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595451: Call_ModelGetPrebuilt_595445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a prebuilt entity model in a version of the application.
  ## 
  let valid = call_595451.validator(path, query, header, formData, body)
  let scheme = call_595451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595451.url(scheme.get, call_595451.host, call_595451.base,
                         call_595451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595451, url, valid)

proc call*(call_595452: Call_ModelGetPrebuilt_595445; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelGetPrebuilt
  ## Gets information about a prebuilt entity model in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595453 = newJObject()
  add(path_595453, "versionId", newJString(versionId))
  add(path_595453, "prebuiltId", newJString(prebuiltId))
  add(path_595453, "appId", newJString(appId))
  result = call_595452.call(path_595453, nil, nil, nil, nil)

var modelGetPrebuilt* = Call_ModelGetPrebuilt_595445(name: "modelGetPrebuilt",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelGetPrebuilt_595446, base: "",
    url: url_ModelGetPrebuilt_595447, schemes: {Scheme.Https})
type
  Call_ModelDeletePrebuilt_595454 = ref object of OpenApiRestCall_593439
proc url_ModelDeletePrebuilt_595456(protocol: Scheme; host: string; base: string;
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

proc validate_ModelDeletePrebuilt_595455(path: JsonNode; query: JsonNode;
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
  var valid_595457 = path.getOrDefault("versionId")
  valid_595457 = validateParameter(valid_595457, JString, required = true,
                                 default = nil)
  if valid_595457 != nil:
    section.add "versionId", valid_595457
  var valid_595458 = path.getOrDefault("prebuiltId")
  valid_595458 = validateParameter(valid_595458, JString, required = true,
                                 default = nil)
  if valid_595458 != nil:
    section.add "prebuiltId", valid_595458
  var valid_595459 = path.getOrDefault("appId")
  valid_595459 = validateParameter(valid_595459, JString, required = true,
                                 default = nil)
  if valid_595459 != nil:
    section.add "appId", valid_595459
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595460: Call_ModelDeletePrebuilt_595454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a prebuilt entity extractor from a version of the application.
  ## 
  let valid = call_595460.validator(path, query, header, formData, body)
  let scheme = call_595460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595460.url(scheme.get, call_595460.host, call_595460.base,
                         call_595460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595460, url, valid)

proc call*(call_595461: Call_ModelDeletePrebuilt_595454; versionId: string;
          prebuiltId: string; appId: string): Recallable =
  ## modelDeletePrebuilt
  ## Deletes a prebuilt entity extractor from a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   prebuiltId: string (required)
  ##             : The prebuilt entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595462 = newJObject()
  add(path_595462, "versionId", newJString(versionId))
  add(path_595462, "prebuiltId", newJString(prebuiltId))
  add(path_595462, "appId", newJString(appId))
  result = call_595461.call(path_595462, nil, nil, nil, nil)

var modelDeletePrebuilt* = Call_ModelDeletePrebuilt_595454(
    name: "modelDeletePrebuilt", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/prebuilts/{prebuiltId}",
    validator: validate_ModelDeletePrebuilt_595455, base: "",
    url: url_ModelDeletePrebuilt_595456, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityModel_595474 = ref object of OpenApiRestCall_593439
proc url_ModelCreateRegexEntityModel_595476(protocol: Scheme; host: string;
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

proc validate_ModelCreateRegexEntityModel_595475(path: JsonNode; query: JsonNode;
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
  var valid_595477 = path.getOrDefault("versionId")
  valid_595477 = validateParameter(valid_595477, JString, required = true,
                                 default = nil)
  if valid_595477 != nil:
    section.add "versionId", valid_595477
  var valid_595478 = path.getOrDefault("appId")
  valid_595478 = validateParameter(valid_595478, JString, required = true,
                                 default = nil)
  if valid_595478 != nil:
    section.add "appId", valid_595478
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

proc call*(call_595480: Call_ModelCreateRegexEntityModel_595474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595480.validator(path, query, header, formData, body)
  let scheme = call_595480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595480.url(scheme.get, call_595480.host, call_595480.base,
                         call_595480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595480, url, valid)

proc call*(call_595481: Call_ModelCreateRegexEntityModel_595474;
          regexEntityExtractorCreateObj: JsonNode; versionId: string; appId: string): Recallable =
  ## modelCreateRegexEntityModel
  ##   regexEntityExtractorCreateObj: JObject (required)
  ##                                : A model object containing the name and regex pattern for the new regular expression entity extractor.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595482 = newJObject()
  var body_595483 = newJObject()
  if regexEntityExtractorCreateObj != nil:
    body_595483 = regexEntityExtractorCreateObj
  add(path_595482, "versionId", newJString(versionId))
  add(path_595482, "appId", newJString(appId))
  result = call_595481.call(path_595482, nil, nil, nil, body_595483)

var modelCreateRegexEntityModel* = Call_ModelCreateRegexEntityModel_595474(
    name: "modelCreateRegexEntityModel", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelCreateRegexEntityModel_595475, base: "",
    url: url_ModelCreateRegexEntityModel_595476, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityInfos_595463 = ref object of OpenApiRestCall_593439
proc url_ModelListRegexEntityInfos_595465(protocol: Scheme; host: string;
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

proc validate_ModelListRegexEntityInfos_595464(path: JsonNode; query: JsonNode;
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
  var valid_595466 = path.getOrDefault("versionId")
  valid_595466 = validateParameter(valid_595466, JString, required = true,
                                 default = nil)
  if valid_595466 != nil:
    section.add "versionId", valid_595466
  var valid_595467 = path.getOrDefault("appId")
  valid_595467 = validateParameter(valid_595467, JString, required = true,
                                 default = nil)
  if valid_595467 != nil:
    section.add "appId", valid_595467
  result.add "path", section
  ## parameters in `query` object:
  ##   skip: JInt
  ##       : The number of entries to skip. Default value is 0.
  ##   take: JInt
  ##       : The number of entries to return. Maximum page size is 500. Default is 100.
  section = newJObject()
  var valid_595468 = query.getOrDefault("skip")
  valid_595468 = validateParameter(valid_595468, JInt, required = false,
                                 default = newJInt(0))
  if valid_595468 != nil:
    section.add "skip", valid_595468
  var valid_595469 = query.getOrDefault("take")
  valid_595469 = validateParameter(valid_595469, JInt, required = false,
                                 default = newJInt(100))
  if valid_595469 != nil:
    section.add "take", valid_595469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595470: Call_ModelListRegexEntityInfos_595463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595470.validator(path, query, header, formData, body)
  let scheme = call_595470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595470.url(scheme.get, call_595470.host, call_595470.base,
                         call_595470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595470, url, valid)

proc call*(call_595471: Call_ModelListRegexEntityInfos_595463; versionId: string;
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
  var path_595472 = newJObject()
  var query_595473 = newJObject()
  add(path_595472, "versionId", newJString(versionId))
  add(query_595473, "skip", newJInt(skip))
  add(query_595473, "take", newJInt(take))
  add(path_595472, "appId", newJString(appId))
  result = call_595471.call(path_595472, query_595473, nil, nil, nil)

var modelListRegexEntityInfos* = Call_ModelListRegexEntityInfos_595463(
    name: "modelListRegexEntityInfos", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities",
    validator: validate_ModelListRegexEntityInfos_595464, base: "",
    url: url_ModelListRegexEntityInfos_595465, schemes: {Scheme.Https})
type
  Call_ModelCreateRegexEntityRole_595493 = ref object of OpenApiRestCall_593439
proc url_ModelCreateRegexEntityRole_595495(protocol: Scheme; host: string;
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

proc validate_ModelCreateRegexEntityRole_595494(path: JsonNode; query: JsonNode;
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
  var valid_595496 = path.getOrDefault("versionId")
  valid_595496 = validateParameter(valid_595496, JString, required = true,
                                 default = nil)
  if valid_595496 != nil:
    section.add "versionId", valid_595496
  var valid_595497 = path.getOrDefault("entityId")
  valid_595497 = validateParameter(valid_595497, JString, required = true,
                                 default = nil)
  if valid_595497 != nil:
    section.add "entityId", valid_595497
  var valid_595498 = path.getOrDefault("appId")
  valid_595498 = validateParameter(valid_595498, JString, required = true,
                                 default = nil)
  if valid_595498 != nil:
    section.add "appId", valid_595498
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

proc call*(call_595500: Call_ModelCreateRegexEntityRole_595493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595500.validator(path, query, header, formData, body)
  let scheme = call_595500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595500.url(scheme.get, call_595500.host, call_595500.base,
                         call_595500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595500, url, valid)

proc call*(call_595501: Call_ModelCreateRegexEntityRole_595493; versionId: string;
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
  var path_595502 = newJObject()
  var body_595503 = newJObject()
  add(path_595502, "versionId", newJString(versionId))
  add(path_595502, "entityId", newJString(entityId))
  if entityRoleCreateObject != nil:
    body_595503 = entityRoleCreateObject
  add(path_595502, "appId", newJString(appId))
  result = call_595501.call(path_595502, nil, nil, nil, body_595503)

var modelCreateRegexEntityRole* = Call_ModelCreateRegexEntityRole_595493(
    name: "modelCreateRegexEntityRole", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelCreateRegexEntityRole_595494, base: "",
    url: url_ModelCreateRegexEntityRole_595495, schemes: {Scheme.Https})
type
  Call_ModelListRegexEntityRoles_595484 = ref object of OpenApiRestCall_593439
proc url_ModelListRegexEntityRoles_595486(protocol: Scheme; host: string;
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

proc validate_ModelListRegexEntityRoles_595485(path: JsonNode; query: JsonNode;
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
  var valid_595487 = path.getOrDefault("versionId")
  valid_595487 = validateParameter(valid_595487, JString, required = true,
                                 default = nil)
  if valid_595487 != nil:
    section.add "versionId", valid_595487
  var valid_595488 = path.getOrDefault("entityId")
  valid_595488 = validateParameter(valid_595488, JString, required = true,
                                 default = nil)
  if valid_595488 != nil:
    section.add "entityId", valid_595488
  var valid_595489 = path.getOrDefault("appId")
  valid_595489 = validateParameter(valid_595489, JString, required = true,
                                 default = nil)
  if valid_595489 != nil:
    section.add "appId", valid_595489
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595490: Call_ModelListRegexEntityRoles_595484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595490.validator(path, query, header, formData, body)
  let scheme = call_595490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595490.url(scheme.get, call_595490.host, call_595490.base,
                         call_595490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595490, url, valid)

proc call*(call_595491: Call_ModelListRegexEntityRoles_595484; versionId: string;
          entityId: string; appId: string): Recallable =
  ## modelListRegexEntityRoles
  ##   versionId: string (required)
  ##            : The version ID.
  ##   entityId: string (required)
  ##           : entity Id
  ##   appId: string (required)
  ##        : The application ID.
  var path_595492 = newJObject()
  add(path_595492, "versionId", newJString(versionId))
  add(path_595492, "entityId", newJString(entityId))
  add(path_595492, "appId", newJString(appId))
  result = call_595491.call(path_595492, nil, nil, nil, nil)

var modelListRegexEntityRoles* = Call_ModelListRegexEntityRoles_595484(
    name: "modelListRegexEntityRoles", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles",
    validator: validate_ModelListRegexEntityRoles_595485, base: "",
    url: url_ModelListRegexEntityRoles_595486, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityRole_595514 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateRegexEntityRole_595516(protocol: Scheme; host: string;
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

proc validate_ModelUpdateRegexEntityRole_595515(path: JsonNode; query: JsonNode;
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
  var valid_595517 = path.getOrDefault("versionId")
  valid_595517 = validateParameter(valid_595517, JString, required = true,
                                 default = nil)
  if valid_595517 != nil:
    section.add "versionId", valid_595517
  var valid_595518 = path.getOrDefault("entityId")
  valid_595518 = validateParameter(valid_595518, JString, required = true,
                                 default = nil)
  if valid_595518 != nil:
    section.add "entityId", valid_595518
  var valid_595519 = path.getOrDefault("appId")
  valid_595519 = validateParameter(valid_595519, JString, required = true,
                                 default = nil)
  if valid_595519 != nil:
    section.add "appId", valid_595519
  var valid_595520 = path.getOrDefault("roleId")
  valid_595520 = validateParameter(valid_595520, JString, required = true,
                                 default = nil)
  if valid_595520 != nil:
    section.add "roleId", valid_595520
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

proc call*(call_595522: Call_ModelUpdateRegexEntityRole_595514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595522.validator(path, query, header, formData, body)
  let scheme = call_595522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595522.url(scheme.get, call_595522.host, call_595522.base,
                         call_595522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595522, url, valid)

proc call*(call_595523: Call_ModelUpdateRegexEntityRole_595514; versionId: string;
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
  var path_595524 = newJObject()
  var body_595525 = newJObject()
  add(path_595524, "versionId", newJString(versionId))
  if entityRoleUpdateObject != nil:
    body_595525 = entityRoleUpdateObject
  add(path_595524, "entityId", newJString(entityId))
  add(path_595524, "appId", newJString(appId))
  add(path_595524, "roleId", newJString(roleId))
  result = call_595523.call(path_595524, nil, nil, nil, body_595525)

var modelUpdateRegexEntityRole* = Call_ModelUpdateRegexEntityRole_595514(
    name: "modelUpdateRegexEntityRole", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelUpdateRegexEntityRole_595515, base: "",
    url: url_ModelUpdateRegexEntityRole_595516, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityRole_595504 = ref object of OpenApiRestCall_593439
proc url_ModelGetRegexEntityRole_595506(protocol: Scheme; host: string; base: string;
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

proc validate_ModelGetRegexEntityRole_595505(path: JsonNode; query: JsonNode;
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
  var valid_595507 = path.getOrDefault("versionId")
  valid_595507 = validateParameter(valid_595507, JString, required = true,
                                 default = nil)
  if valid_595507 != nil:
    section.add "versionId", valid_595507
  var valid_595508 = path.getOrDefault("entityId")
  valid_595508 = validateParameter(valid_595508, JString, required = true,
                                 default = nil)
  if valid_595508 != nil:
    section.add "entityId", valid_595508
  var valid_595509 = path.getOrDefault("appId")
  valid_595509 = validateParameter(valid_595509, JString, required = true,
                                 default = nil)
  if valid_595509 != nil:
    section.add "appId", valid_595509
  var valid_595510 = path.getOrDefault("roleId")
  valid_595510 = validateParameter(valid_595510, JString, required = true,
                                 default = nil)
  if valid_595510 != nil:
    section.add "roleId", valid_595510
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595511: Call_ModelGetRegexEntityRole_595504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595511.validator(path, query, header, formData, body)
  let scheme = call_595511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595511.url(scheme.get, call_595511.host, call_595511.base,
                         call_595511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595511, url, valid)

proc call*(call_595512: Call_ModelGetRegexEntityRole_595504; versionId: string;
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
  var path_595513 = newJObject()
  add(path_595513, "versionId", newJString(versionId))
  add(path_595513, "entityId", newJString(entityId))
  add(path_595513, "appId", newJString(appId))
  add(path_595513, "roleId", newJString(roleId))
  result = call_595512.call(path_595513, nil, nil, nil, nil)

var modelGetRegexEntityRole* = Call_ModelGetRegexEntityRole_595504(
    name: "modelGetRegexEntityRole", meth: HttpMethod.HttpGet, host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelGetRegexEntityRole_595505, base: "",
    url: url_ModelGetRegexEntityRole_595506, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityRole_595526 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteRegexEntityRole_595528(protocol: Scheme; host: string;
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

proc validate_ModelDeleteRegexEntityRole_595527(path: JsonNode; query: JsonNode;
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
  var valid_595529 = path.getOrDefault("versionId")
  valid_595529 = validateParameter(valid_595529, JString, required = true,
                                 default = nil)
  if valid_595529 != nil:
    section.add "versionId", valid_595529
  var valid_595530 = path.getOrDefault("entityId")
  valid_595530 = validateParameter(valid_595530, JString, required = true,
                                 default = nil)
  if valid_595530 != nil:
    section.add "entityId", valid_595530
  var valid_595531 = path.getOrDefault("appId")
  valid_595531 = validateParameter(valid_595531, JString, required = true,
                                 default = nil)
  if valid_595531 != nil:
    section.add "appId", valid_595531
  var valid_595532 = path.getOrDefault("roleId")
  valid_595532 = validateParameter(valid_595532, JString, required = true,
                                 default = nil)
  if valid_595532 != nil:
    section.add "roleId", valid_595532
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595533: Call_ModelDeleteRegexEntityRole_595526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595533.validator(path, query, header, formData, body)
  let scheme = call_595533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595533.url(scheme.get, call_595533.host, call_595533.base,
                         call_595533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595533, url, valid)

proc call*(call_595534: Call_ModelDeleteRegexEntityRole_595526; versionId: string;
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
  var path_595535 = newJObject()
  add(path_595535, "versionId", newJString(versionId))
  add(path_595535, "entityId", newJString(entityId))
  add(path_595535, "appId", newJString(appId))
  add(path_595535, "roleId", newJString(roleId))
  result = call_595534.call(path_595535, nil, nil, nil, nil)

var modelDeleteRegexEntityRole* = Call_ModelDeleteRegexEntityRole_595526(
    name: "modelDeleteRegexEntityRole", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/regexentities/{entityId}/roles/{roleId}",
    validator: validate_ModelDeleteRegexEntityRole_595527, base: "",
    url: url_ModelDeleteRegexEntityRole_595528, schemes: {Scheme.Https})
type
  Call_ModelUpdateRegexEntityModel_595545 = ref object of OpenApiRestCall_593439
proc url_ModelUpdateRegexEntityModel_595547(protocol: Scheme; host: string;
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

proc validate_ModelUpdateRegexEntityModel_595546(path: JsonNode; query: JsonNode;
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
  var valid_595548 = path.getOrDefault("versionId")
  valid_595548 = validateParameter(valid_595548, JString, required = true,
                                 default = nil)
  if valid_595548 != nil:
    section.add "versionId", valid_595548
  var valid_595549 = path.getOrDefault("regexEntityId")
  valid_595549 = validateParameter(valid_595549, JString, required = true,
                                 default = nil)
  if valid_595549 != nil:
    section.add "regexEntityId", valid_595549
  var valid_595550 = path.getOrDefault("appId")
  valid_595550 = validateParameter(valid_595550, JString, required = true,
                                 default = nil)
  if valid_595550 != nil:
    section.add "appId", valid_595550
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

proc call*(call_595552: Call_ModelUpdateRegexEntityModel_595545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595552.validator(path, query, header, formData, body)
  let scheme = call_595552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595552.url(scheme.get, call_595552.host, call_595552.base,
                         call_595552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595552, url, valid)

proc call*(call_595553: Call_ModelUpdateRegexEntityModel_595545; versionId: string;
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
  var path_595554 = newJObject()
  var body_595555 = newJObject()
  add(path_595554, "versionId", newJString(versionId))
  add(path_595554, "regexEntityId", newJString(regexEntityId))
  add(path_595554, "appId", newJString(appId))
  if regexEntityUpdateObject != nil:
    body_595555 = regexEntityUpdateObject
  result = call_595553.call(path_595554, nil, nil, nil, body_595555)

var modelUpdateRegexEntityModel* = Call_ModelUpdateRegexEntityModel_595545(
    name: "modelUpdateRegexEntityModel", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelUpdateRegexEntityModel_595546, base: "",
    url: url_ModelUpdateRegexEntityModel_595547, schemes: {Scheme.Https})
type
  Call_ModelGetRegexEntityEntityInfo_595536 = ref object of OpenApiRestCall_593439
proc url_ModelGetRegexEntityEntityInfo_595538(protocol: Scheme; host: string;
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

proc validate_ModelGetRegexEntityEntityInfo_595537(path: JsonNode; query: JsonNode;
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
  var valid_595539 = path.getOrDefault("versionId")
  valid_595539 = validateParameter(valid_595539, JString, required = true,
                                 default = nil)
  if valid_595539 != nil:
    section.add "versionId", valid_595539
  var valid_595540 = path.getOrDefault("regexEntityId")
  valid_595540 = validateParameter(valid_595540, JString, required = true,
                                 default = nil)
  if valid_595540 != nil:
    section.add "regexEntityId", valid_595540
  var valid_595541 = path.getOrDefault("appId")
  valid_595541 = validateParameter(valid_595541, JString, required = true,
                                 default = nil)
  if valid_595541 != nil:
    section.add "appId", valid_595541
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595542: Call_ModelGetRegexEntityEntityInfo_595536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595542.validator(path, query, header, formData, body)
  let scheme = call_595542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595542.url(scheme.get, call_595542.host, call_595542.base,
                         call_595542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595542, url, valid)

proc call*(call_595543: Call_ModelGetRegexEntityEntityInfo_595536;
          versionId: string; regexEntityId: string; appId: string): Recallable =
  ## modelGetRegexEntityEntityInfo
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityId: string (required)
  ##                : The regular expression entity model ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595544 = newJObject()
  add(path_595544, "versionId", newJString(versionId))
  add(path_595544, "regexEntityId", newJString(regexEntityId))
  add(path_595544, "appId", newJString(appId))
  result = call_595543.call(path_595544, nil, nil, nil, nil)

var modelGetRegexEntityEntityInfo* = Call_ModelGetRegexEntityEntityInfo_595536(
    name: "modelGetRegexEntityEntityInfo", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelGetRegexEntityEntityInfo_595537, base: "",
    url: url_ModelGetRegexEntityEntityInfo_595538, schemes: {Scheme.Https})
type
  Call_ModelDeleteRegexEntityModel_595556 = ref object of OpenApiRestCall_593439
proc url_ModelDeleteRegexEntityModel_595558(protocol: Scheme; host: string;
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

proc validate_ModelDeleteRegexEntityModel_595557(path: JsonNode; query: JsonNode;
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
  var valid_595559 = path.getOrDefault("versionId")
  valid_595559 = validateParameter(valid_595559, JString, required = true,
                                 default = nil)
  if valid_595559 != nil:
    section.add "versionId", valid_595559
  var valid_595560 = path.getOrDefault("regexEntityId")
  valid_595560 = validateParameter(valid_595560, JString, required = true,
                                 default = nil)
  if valid_595560 != nil:
    section.add "regexEntityId", valid_595560
  var valid_595561 = path.getOrDefault("appId")
  valid_595561 = validateParameter(valid_595561, JString, required = true,
                                 default = nil)
  if valid_595561 != nil:
    section.add "appId", valid_595561
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595562: Call_ModelDeleteRegexEntityModel_595556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595562.validator(path, query, header, formData, body)
  let scheme = call_595562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595562.url(scheme.get, call_595562.host, call_595562.base,
                         call_595562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595562, url, valid)

proc call*(call_595563: Call_ModelDeleteRegexEntityModel_595556; versionId: string;
          regexEntityId: string; appId: string): Recallable =
  ## modelDeleteRegexEntityModel
  ##   versionId: string (required)
  ##            : The version ID.
  ##   regexEntityId: string (required)
  ##                : The regular expression entity extractor ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595564 = newJObject()
  add(path_595564, "versionId", newJString(versionId))
  add(path_595564, "regexEntityId", newJString(regexEntityId))
  add(path_595564, "appId", newJString(appId))
  result = call_595563.call(path_595564, nil, nil, nil, nil)

var modelDeleteRegexEntityModel* = Call_ModelDeleteRegexEntityModel_595556(
    name: "modelDeleteRegexEntityModel", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/regexentities/{regexEntityId}",
    validator: validate_ModelDeleteRegexEntityModel_595557, base: "",
    url: url_ModelDeleteRegexEntityModel_595558, schemes: {Scheme.Https})
type
  Call_SettingsUpdate_595573 = ref object of OpenApiRestCall_593439
proc url_SettingsUpdate_595575(protocol: Scheme; host: string; base: string;
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

proc validate_SettingsUpdate_595574(path: JsonNode; query: JsonNode;
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
  var valid_595576 = path.getOrDefault("versionId")
  valid_595576 = validateParameter(valid_595576, JString, required = true,
                                 default = nil)
  if valid_595576 != nil:
    section.add "versionId", valid_595576
  var valid_595577 = path.getOrDefault("appId")
  valid_595577 = validateParameter(valid_595577, JString, required = true,
                                 default = nil)
  if valid_595577 != nil:
    section.add "appId", valid_595577
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

proc call*(call_595579: Call_SettingsUpdate_595573; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings in a version of the application.
  ## 
  let valid = call_595579.validator(path, query, header, formData, body)
  let scheme = call_595579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595579.url(scheme.get, call_595579.host, call_595579.base,
                         call_595579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595579, url, valid)

proc call*(call_595580: Call_SettingsUpdate_595573; versionId: string; appId: string;
          listOfAppVersionSettingObject: JsonNode): Recallable =
  ## settingsUpdate
  ## Updates the settings in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   listOfAppVersionSettingObject: JArray (required)
  ##                                : A list of the updated application version settings.
  var path_595581 = newJObject()
  var body_595582 = newJObject()
  add(path_595581, "versionId", newJString(versionId))
  add(path_595581, "appId", newJString(appId))
  if listOfAppVersionSettingObject != nil:
    body_595582 = listOfAppVersionSettingObject
  result = call_595580.call(path_595581, nil, nil, nil, body_595582)

var settingsUpdate* = Call_SettingsUpdate_595573(name: "settingsUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsUpdate_595574, base: "", url: url_SettingsUpdate_595575,
    schemes: {Scheme.Https})
type
  Call_SettingsList_595565 = ref object of OpenApiRestCall_593439
proc url_SettingsList_595567(protocol: Scheme; host: string; base: string;
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

proc validate_SettingsList_595566(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595568 = path.getOrDefault("versionId")
  valid_595568 = validateParameter(valid_595568, JString, required = true,
                                 default = nil)
  if valid_595568 != nil:
    section.add "versionId", valid_595568
  var valid_595569 = path.getOrDefault("appId")
  valid_595569 = validateParameter(valid_595569, JString, required = true,
                                 default = nil)
  if valid_595569 != nil:
    section.add "appId", valid_595569
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595570: Call_SettingsList_595565; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the settings in a version of the application.
  ## 
  let valid = call_595570.validator(path, query, header, formData, body)
  let scheme = call_595570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595570.url(scheme.get, call_595570.host, call_595570.base,
                         call_595570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595570, url, valid)

proc call*(call_595571: Call_SettingsList_595565; versionId: string; appId: string): Recallable =
  ## settingsList
  ## Gets the settings in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595572 = newJObject()
  add(path_595572, "versionId", newJString(versionId))
  add(path_595572, "appId", newJString(appId))
  result = call_595571.call(path_595572, nil, nil, nil, nil)

var settingsList* = Call_SettingsList_595565(name: "settingsList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/settings",
    validator: validate_SettingsList_595566, base: "", url: url_SettingsList_595567,
    schemes: {Scheme.Https})
type
  Call_VersionsDeleteUnlabelledUtterance_595583 = ref object of OpenApiRestCall_593439
proc url_VersionsDeleteUnlabelledUtterance_595585(protocol: Scheme; host: string;
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

proc validate_VersionsDeleteUnlabelledUtterance_595584(path: JsonNode;
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
  var valid_595586 = path.getOrDefault("versionId")
  valid_595586 = validateParameter(valid_595586, JString, required = true,
                                 default = nil)
  if valid_595586 != nil:
    section.add "versionId", valid_595586
  var valid_595587 = path.getOrDefault("appId")
  valid_595587 = validateParameter(valid_595587, JString, required = true,
                                 default = nil)
  if valid_595587 != nil:
    section.add "appId", valid_595587
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

proc call*(call_595589: Call_VersionsDeleteUnlabelledUtterance_595583;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deleted an unlabelled utterance in a version of the application.
  ## 
  let valid = call_595589.validator(path, query, header, formData, body)
  let scheme = call_595589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595589.url(scheme.get, call_595589.host, call_595589.base,
                         call_595589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595589, url, valid)

proc call*(call_595590: Call_VersionsDeleteUnlabelledUtterance_595583;
          versionId: string; appId: string; utterance: JsonNode): Recallable =
  ## versionsDeleteUnlabelledUtterance
  ## Deleted an unlabelled utterance in a version of the application.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  ##   utterance: JString (required)
  ##            : The utterance text to delete.
  var path_595591 = newJObject()
  var body_595592 = newJObject()
  add(path_595591, "versionId", newJString(versionId))
  add(path_595591, "appId", newJString(appId))
  if utterance != nil:
    body_595592 = utterance
  result = call_595590.call(path_595591, nil, nil, nil, body_595592)

var versionsDeleteUnlabelledUtterance* = Call_VersionsDeleteUnlabelledUtterance_595583(
    name: "versionsDeleteUnlabelledUtterance", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/suggest",
    validator: validate_VersionsDeleteUnlabelledUtterance_595584, base: "",
    url: url_VersionsDeleteUnlabelledUtterance_595585, schemes: {Scheme.Https})
type
  Call_TrainTrainVersion_595601 = ref object of OpenApiRestCall_593439
proc url_TrainTrainVersion_595603(protocol: Scheme; host: string; base: string;
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

proc validate_TrainTrainVersion_595602(path: JsonNode; query: JsonNode;
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
  var valid_595604 = path.getOrDefault("versionId")
  valid_595604 = validateParameter(valid_595604, JString, required = true,
                                 default = nil)
  if valid_595604 != nil:
    section.add "versionId", valid_595604
  var valid_595605 = path.getOrDefault("appId")
  valid_595605 = validateParameter(valid_595605, JString, required = true,
                                 default = nil)
  if valid_595605 != nil:
    section.add "appId", valid_595605
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595606: Call_TrainTrainVersion_595601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ## 
  let valid = call_595606.validator(path, query, header, formData, body)
  let scheme = call_595606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595606.url(scheme.get, call_595606.host, call_595606.base,
                         call_595606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595606, url, valid)

proc call*(call_595607: Call_TrainTrainVersion_595601; versionId: string;
          appId: string): Recallable =
  ## trainTrainVersion
  ## Sends a training request for a version of a specified LUIS app. This POST request initiates a request asynchronously. To determine whether the training request is successful, submit a GET request to get training status. Note: The application version is not fully trained unless all the models (intents and entities) are trained successfully or are up to date. To verify training success, get the training status at least once after training is complete.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595608 = newJObject()
  add(path_595608, "versionId", newJString(versionId))
  add(path_595608, "appId", newJString(appId))
  result = call_595607.call(path_595608, nil, nil, nil, nil)

var trainTrainVersion* = Call_TrainTrainVersion_595601(name: "trainTrainVersion",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainTrainVersion_595602, base: "",
    url: url_TrainTrainVersion_595603, schemes: {Scheme.Https})
type
  Call_TrainGetStatus_595593 = ref object of OpenApiRestCall_593439
proc url_TrainGetStatus_595595(protocol: Scheme; host: string; base: string;
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

proc validate_TrainGetStatus_595594(path: JsonNode; query: JsonNode;
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
  var valid_595596 = path.getOrDefault("versionId")
  valid_595596 = validateParameter(valid_595596, JString, required = true,
                                 default = nil)
  if valid_595596 != nil:
    section.add "versionId", valid_595596
  var valid_595597 = path.getOrDefault("appId")
  valid_595597 = validateParameter(valid_595597, JString, required = true,
                                 default = nil)
  if valid_595597 != nil:
    section.add "appId", valid_595597
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595598: Call_TrainGetStatus_595593; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ## 
  let valid = call_595598.validator(path, query, header, formData, body)
  let scheme = call_595598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595598.url(scheme.get, call_595598.host, call_595598.base,
                         call_595598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595598, url, valid)

proc call*(call_595599: Call_TrainGetStatus_595593; versionId: string; appId: string): Recallable =
  ## trainGetStatus
  ## Gets the training status of all models (intents and entities) for the specified LUIS app. You must call the train API to train the LUIS app before you call this API to get training status. "appID" specifies the LUIS app ID. "versionId" specifies the version number of the LUIS app. For example, "0.1".
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595600 = newJObject()
  add(path_595600, "versionId", newJString(versionId))
  add(path_595600, "appId", newJString(appId))
  result = call_595599.call(path_595600, nil, nil, nil, nil)

var trainGetStatus* = Call_TrainGetStatus_595593(name: "trainGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apps/{appId}/versions/{versionId}/train",
    validator: validate_TrainGetStatus_595594, base: "", url: url_TrainGetStatus_595595,
    schemes: {Scheme.Https})
type
  Call_AzureAccountsListUserLUISAccounts_595609 = ref object of OpenApiRestCall_593439
proc url_AzureAccountsListUserLUISAccounts_595611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AzureAccountsListUserLUISAccounts_595610(path: JsonNode;
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
  var valid_595612 = header.getOrDefault("Authorization")
  valid_595612 = validateParameter(valid_595612, JString, required = true,
                                 default = nil)
  if valid_595612 != nil:
    section.add "Authorization", valid_595612
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595613: Call_AzureAccountsListUserLUISAccounts_595609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  ## 
  let valid = call_595613.validator(path, query, header, formData, body)
  let scheme = call_595613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595613.url(scheme.get, call_595613.host, call_595613.base,
                         call_595613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595613, url, valid)

proc call*(call_595614: Call_AzureAccountsListUserLUISAccounts_595609): Recallable =
  ## azureAccountsListUserLUISAccounts
  ## Gets the LUIS Azure accounts for the user using his ARM token.
  result = call_595614.call(nil, nil, nil, nil, nil)

var azureAccountsListUserLUISAccounts* = Call_AzureAccountsListUserLUISAccounts_595609(
    name: "azureAccountsListUserLUISAccounts", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/azureaccounts",
    validator: validate_AzureAccountsListUserLUISAccounts_595610, base: "",
    url: url_AzureAccountsListUserLUISAccounts_595611, schemes: {Scheme.Https})
type
  Call_AppsPackagePublishedApplicationAsGzip_595615 = ref object of OpenApiRestCall_593439
proc url_AppsPackagePublishedApplicationAsGzip_595617(protocol: Scheme;
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

proc validate_AppsPackagePublishedApplicationAsGzip_595616(path: JsonNode;
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
  var valid_595618 = path.getOrDefault("appId")
  valid_595618 = validateParameter(valid_595618, JString, required = true,
                                 default = nil)
  if valid_595618 != nil:
    section.add "appId", valid_595618
  var valid_595619 = path.getOrDefault("slotName")
  valid_595619 = validateParameter(valid_595619, JString, required = true,
                                 default = nil)
  if valid_595619 != nil:
    section.add "slotName", valid_595619
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595620: Call_AppsPackagePublishedApplicationAsGzip_595615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ## 
  let valid = call_595620.validator(path, query, header, formData, body)
  let scheme = call_595620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595620.url(scheme.get, call_595620.host, call_595620.base,
                         call_595620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595620, url, valid)

proc call*(call_595621: Call_AppsPackagePublishedApplicationAsGzip_595615;
          appId: string; slotName: string): Recallable =
  ## appsPackagePublishedApplicationAsGzip
  ## Packages a published LUIS application as a GZip file to be used in the LUIS container.
  ##   appId: string (required)
  ##        : The application ID.
  ##   slotName: string (required)
  ##           : The publishing slot name.
  var path_595622 = newJObject()
  add(path_595622, "appId", newJString(appId))
  add(path_595622, "slotName", newJString(slotName))
  result = call_595621.call(path_595622, nil, nil, nil, nil)

var appsPackagePublishedApplicationAsGzip* = Call_AppsPackagePublishedApplicationAsGzip_595615(
    name: "appsPackagePublishedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/slot/{slotName}/gzip",
    validator: validate_AppsPackagePublishedApplicationAsGzip_595616, base: "",
    url: url_AppsPackagePublishedApplicationAsGzip_595617, schemes: {Scheme.Https})
type
  Call_AppsPackageTrainedApplicationAsGzip_595623 = ref object of OpenApiRestCall_593439
proc url_AppsPackageTrainedApplicationAsGzip_595625(protocol: Scheme; host: string;
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

proc validate_AppsPackageTrainedApplicationAsGzip_595624(path: JsonNode;
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
  var valid_595626 = path.getOrDefault("versionId")
  valid_595626 = validateParameter(valid_595626, JString, required = true,
                                 default = nil)
  if valid_595626 != nil:
    section.add "versionId", valid_595626
  var valid_595627 = path.getOrDefault("appId")
  valid_595627 = validateParameter(valid_595627, JString, required = true,
                                 default = nil)
  if valid_595627 != nil:
    section.add "appId", valid_595627
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595628: Call_AppsPackageTrainedApplicationAsGzip_595623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ## 
  let valid = call_595628.validator(path, query, header, formData, body)
  let scheme = call_595628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595628.url(scheme.get, call_595628.host, call_595628.base,
                         call_595628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595628, url, valid)

proc call*(call_595629: Call_AppsPackageTrainedApplicationAsGzip_595623;
          versionId: string; appId: string): Recallable =
  ## appsPackageTrainedApplicationAsGzip
  ## Packages trained LUIS application as GZip file to be used in the LUIS container.
  ##   versionId: string (required)
  ##            : The version ID.
  ##   appId: string (required)
  ##        : The application ID.
  var path_595630 = newJObject()
  add(path_595630, "versionId", newJString(versionId))
  add(path_595630, "appId", newJString(appId))
  result = call_595629.call(path_595630, nil, nil, nil, nil)

var appsPackageTrainedApplicationAsGzip* = Call_AppsPackageTrainedApplicationAsGzip_595623(
    name: "appsPackageTrainedApplicationAsGzip", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/package/{appId}/versions/{versionId}/gzip",
    validator: validate_AppsPackageTrainedApplicationAsGzip_595624, base: "",
    url: url_AppsPackageTrainedApplicationAsGzip_595625, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
