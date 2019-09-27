
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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
  macServiceName = "security"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593663(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593662(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Exposes all available operations for discovery purposes.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593835 = query.getOrDefault("api-version")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593835 != nil:
    section.add "api-version", valid_593835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593858: Call_OperationsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes all available operations for discovery purposes.
  ## 
  let valid = call_593858.validator(path, query, header, formData, body)
  let scheme = call_593858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593858.url(scheme.get, call_593858.host, call_593858.base,
                         call_593858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593858, url, valid)

proc call*(call_593929: Call_OperationsList_593661;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## operationsList
  ## Exposes all available operations for discovery purposes.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  var query_593930 = newJObject()
  add(query_593930, "api-version", newJString(apiVersion))
  result = call_593929.call(nil, query_593930, nil, nil, nil)

var operationsList* = Call_OperationsList_593661(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Security/operations",
    validator: validate_OperationsList_593662, base: "", url: url_OperationsList_593663,
    schemes: {Scheme.Https})
type
  Call_AlertsList_593970 = ref object of OpenApiRestCall_593439
proc url_AlertsList_593972(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsList_593971(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  var valid_593990 = query.getOrDefault("$expand")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "$expand", valid_593990
  var valid_593991 = query.getOrDefault("$select")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$select", valid_593991
  var valid_593992 = query.getOrDefault("$filter")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "$filter", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_AlertsList_593970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_AlertsList_593970; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## alertsList
  ## List all the alerts that are associated with the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(query_593996, "$expand", newJString(Expand))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(query_593996, "$select", newJString(Select))
  add(query_593996, "$filter", newJString(Filter))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var alertsList* = Call_AlertsList_593970(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/alerts",
                                      validator: validate_AlertsList_593971,
                                      base: "", url: url_AlertsList_593972,
                                      schemes: {Scheme.Https})
type
  Call_AllowedConnectionsList_593997 = ref object of OpenApiRestCall_593439
proc url_AllowedConnectionsList_593999(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/allowedConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AllowedConnectionsList_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of all possible traffic between resources for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_AllowedConnectionsList_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_AllowedConnectionsList_593997; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## allowedConnectionsList
  ## Gets the list of all possible traffic between resources for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var allowedConnectionsList* = Call_AllowedConnectionsList_593997(
    name: "allowedConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/allowedConnections",
    validator: validate_AllowedConnectionsList_593998, base: "",
    url: url_AllowedConnectionsList_593999, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsList_594006 = ref object of OpenApiRestCall_593439
proc url_DiscoveredSecuritySolutionsList_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/discoveredSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiscoveredSecuritySolutionsList_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of discovered Security Solutions for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_DiscoveredSecuritySolutionsList_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_DiscoveredSecuritySolutionsList_594006;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## discoveredSecuritySolutionsList
  ## Gets a list of discovered Security Solutions for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var discoveredSecuritySolutionsList* = Call_DiscoveredSecuritySolutionsList_594006(
    name: "discoveredSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsList_594007, base: "",
    url: url_DiscoveredSecuritySolutionsList_594008, schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsList_594015 = ref object of OpenApiRestCall_593439
proc url_ExternalSecuritySolutionsList_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/externalSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSecuritySolutionsList_594016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of external security solutions for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_ExternalSecuritySolutionsList_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of external security solutions for the subscription.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ExternalSecuritySolutionsList_594015;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## externalSecuritySolutionsList
  ## Gets a list of external security solutions for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var externalSecuritySolutionsList* = Call_ExternalSecuritySolutionsList_594015(
    name: "externalSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/externalSecuritySolutions",
    validator: validate_ExternalSecuritySolutionsList_594016, base: "",
    url: url_ExternalSecuritySolutionsList_594017, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesList_594024 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesList_594026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/jitNetworkAccessPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesList_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policies for protecting resources using Just-in-Time access control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_JitNetworkAccessPoliciesList_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_JitNetworkAccessPoliciesList_594024;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesList
  ## Policies for protecting resources using Just-in-Time access control.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var jitNetworkAccessPoliciesList* = Call_JitNetworkAccessPoliciesList_594024(
    name: "jitNetworkAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesList_594025, base: "",
    url: url_JitNetworkAccessPoliciesList_594026, schemes: {Scheme.Https})
type
  Call_LocationsList_594033 = ref object of OpenApiRestCall_593439
proc url_LocationsList_594035(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsList_594034(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The location of the responsible ASC of the specific subscription (home region). For each subscription there is only one responsible location. The location in the response should be used to read or write other resources in ASC according to their ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_LocationsList_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The location of the responsible ASC of the specific subscription (home region). For each subscription there is only one responsible location. The location in the response should be used to read or write other resources in ASC according to their ID.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_LocationsList_594033; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## locationsList
  ## The location of the responsible ASC of the specific subscription (home region). For each subscription there is only one responsible location. The location in the response should be used to read or write other resources in ASC according to their ID.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var locationsList* = Call_LocationsList_594033(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations",
    validator: validate_LocationsList_594034, base: "", url: url_LocationsList_594035,
    schemes: {Scheme.Https})
type
  Call_LocationsGet_594042 = ref object of OpenApiRestCall_593439
proc url_LocationsGet_594044(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGet_594043(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594045 = path.getOrDefault("ascLocation")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "ascLocation", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_LocationsGet_594042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific location
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_LocationsGet_594042; ascLocation: string;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## locationsGet
  ## Details of a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "ascLocation", newJString(ascLocation))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var locationsGet* = Call_LocationsGet_594042(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}",
    validator: validate_LocationsGet_594043, base: "", url: url_LocationsGet_594044,
    schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsListByHomeRegion_594052 = ref object of OpenApiRestCall_593439
proc url_ExternalSecuritySolutionsListByHomeRegion_594054(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/ExternalSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSecuritySolutionsListByHomeRegion_594053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of external Security Solutions for the subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594055 = path.getOrDefault("ascLocation")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "ascLocation", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_ExternalSecuritySolutionsListByHomeRegion_594052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of external Security Solutions for the subscription and location.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_ExternalSecuritySolutionsListByHomeRegion_594052;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## externalSecuritySolutionsListByHomeRegion
  ## Gets a list of external Security Solutions for the subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "ascLocation", newJString(ascLocation))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var externalSecuritySolutionsListByHomeRegion* = Call_ExternalSecuritySolutionsListByHomeRegion_594052(
    name: "externalSecuritySolutionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/ExternalSecuritySolutions",
    validator: validate_ExternalSecuritySolutionsListByHomeRegion_594053,
    base: "", url: url_ExternalSecuritySolutionsListByHomeRegion_594054,
    schemes: {Scheme.Https})
type
  Call_AlertsListSubscriptionLevelAlertsByRegion_594062 = ref object of OpenApiRestCall_593439
proc url_AlertsListSubscriptionLevelAlertsByRegion_594064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListSubscriptionLevelAlertsByRegion_594063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594065 = path.getOrDefault("ascLocation")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "ascLocation", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594067 != nil:
    section.add "api-version", valid_594067
  var valid_594068 = query.getOrDefault("$expand")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "$expand", valid_594068
  var valid_594069 = query.getOrDefault("$select")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "$select", valid_594069
  var valid_594070 = query.getOrDefault("$filter")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$filter", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_AlertsListSubscriptionLevelAlertsByRegion_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_AlertsListSubscriptionLevelAlertsByRegion_594062;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## alertsListSubscriptionLevelAlertsByRegion
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(query_594074, "api-version", newJString(apiVersion))
  add(query_594074, "$expand", newJString(Expand))
  add(path_594073, "ascLocation", newJString(ascLocation))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(query_594074, "$select", newJString(Select))
  add(query_594074, "$filter", newJString(Filter))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var alertsListSubscriptionLevelAlertsByRegion* = Call_AlertsListSubscriptionLevelAlertsByRegion_594062(
    name: "alertsListSubscriptionLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListSubscriptionLevelAlertsByRegion_594063,
    base: "", url: url_AlertsListSubscriptionLevelAlertsByRegion_594064,
    schemes: {Scheme.Https})
type
  Call_AlertsGetSubscriptionLevelAlert_594075 = ref object of OpenApiRestCall_593439
proc url_AlertsGetSubscriptionLevelAlert_594077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetSubscriptionLevelAlert_594076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated with a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594078 = path.getOrDefault("ascLocation")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "ascLocation", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  var valid_594080 = path.getOrDefault("alertName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "alertName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_AlertsGetSubscriptionLevelAlert_594075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated with a subscription
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_AlertsGetSubscriptionLevelAlert_594075;
          ascLocation: string; subscriptionId: string; alertName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## alertsGetSubscriptionLevelAlert
  ## Get an alert that is associated with a subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "ascLocation", newJString(ascLocation))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  add(path_594084, "alertName", newJString(alertName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var alertsGetSubscriptionLevelAlert* = Call_AlertsGetSubscriptionLevelAlert_594075(
    name: "alertsGetSubscriptionLevelAlert", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetSubscriptionLevelAlert_594076, base: "",
    url: url_AlertsGetSubscriptionLevelAlert_594077, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionLevelAlertState_594086 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateSubscriptionLevelAlertState_594088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  assert "alertUpdateActionType" in path,
        "`alertUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "alertUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateSubscriptionLevelAlertState_594087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594089 = path.getOrDefault("ascLocation")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "ascLocation", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("alertUpdateActionType")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_594091 != nil:
    section.add "alertUpdateActionType", valid_594091
  var valid_594092 = path.getOrDefault("alertName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "alertName", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_AlertsUpdateSubscriptionLevelAlertState_594086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_AlertsUpdateSubscriptionLevelAlertState_594086;
          ascLocation: string; subscriptionId: string; alertName: string;
          apiVersion: string = "2015-06-01-preview";
          alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateSubscriptionLevelAlertState
  ## Update the alert's state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "ascLocation", newJString(ascLocation))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  add(path_594096, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_594096, "alertName", newJString(alertName))
  result = call_594095.call(path_594096, query_594097, nil, nil, nil)

var alertsUpdateSubscriptionLevelAlertState* = Call_AlertsUpdateSubscriptionLevelAlertState_594086(
    name: "alertsUpdateSubscriptionLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateSubscriptionLevelAlertState_594087, base: "",
    url: url_AlertsUpdateSubscriptionLevelAlertState_594088,
    schemes: {Scheme.Https})
type
  Call_AllowedConnectionsListByHomeRegion_594098 = ref object of OpenApiRestCall_593439
proc url_AllowedConnectionsListByHomeRegion_594100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/allowedConnections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AllowedConnectionsListByHomeRegion_594099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of all possible traffic between resources for the subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594101 = path.getOrDefault("ascLocation")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "ascLocation", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_AllowedConnectionsListByHomeRegion_594098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription and location.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_AllowedConnectionsListByHomeRegion_594098;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## allowedConnectionsListByHomeRegion
  ## Gets the list of all possible traffic between resources for the subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "ascLocation", newJString(ascLocation))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var allowedConnectionsListByHomeRegion* = Call_AllowedConnectionsListByHomeRegion_594098(
    name: "allowedConnectionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/allowedConnections",
    validator: validate_AllowedConnectionsListByHomeRegion_594099, base: "",
    url: url_AllowedConnectionsListByHomeRegion_594100, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsListByHomeRegion_594108 = ref object of OpenApiRestCall_593439
proc url_DiscoveredSecuritySolutionsListByHomeRegion_594110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/discoveredSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiscoveredSecuritySolutionsListByHomeRegion_594109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594111 = path.getOrDefault("ascLocation")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "ascLocation", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_DiscoveredSecuritySolutionsListByHomeRegion_594108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_DiscoveredSecuritySolutionsListByHomeRegion_594108;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## discoveredSecuritySolutionsListByHomeRegion
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "ascLocation", newJString(ascLocation))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var discoveredSecuritySolutionsListByHomeRegion* = Call_DiscoveredSecuritySolutionsListByHomeRegion_594108(
    name: "discoveredSecuritySolutionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsListByHomeRegion_594109,
    base: "", url: url_DiscoveredSecuritySolutionsListByHomeRegion_594110,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByRegion_594118 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesListByRegion_594120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesListByRegion_594119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594121 = path.getOrDefault("ascLocation")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "ascLocation", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_JitNetworkAccessPoliciesListByRegion_594118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_JitNetworkAccessPoliciesListByRegion_594118;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesListByRegion
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "ascLocation", newJString(ascLocation))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var jitNetworkAccessPoliciesListByRegion* = Call_JitNetworkAccessPoliciesListByRegion_594118(
    name: "jitNetworkAccessPoliciesListByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByRegion_594119, base: "",
    url: url_JitNetworkAccessPoliciesListByRegion_594120, schemes: {Scheme.Https})
type
  Call_TasksListByHomeRegion_594128 = ref object of OpenApiRestCall_593439
proc url_TasksListByHomeRegion_594130(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksListByHomeRegion_594129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594131 = path.getOrDefault("ascLocation")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "ascLocation", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  var valid_594134 = query.getOrDefault("$filter")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "$filter", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_TasksListByHomeRegion_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_TasksListByHomeRegion_594128; ascLocation: string;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview";
          Filter: string = ""): Recallable =
  ## tasksListByHomeRegion
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "ascLocation", newJString(ascLocation))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(query_594138, "$filter", newJString(Filter))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var tasksListByHomeRegion* = Call_TasksListByHomeRegion_594128(
    name: "tasksListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByHomeRegion_594129, base: "",
    url: url_TasksListByHomeRegion_594130, schemes: {Scheme.Https})
type
  Call_TasksGetSubscriptionLevelTask_594139 = ref object of OpenApiRestCall_593439
proc url_TasksGetSubscriptionLevelTask_594141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGetSubscriptionLevelTask_594140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594142 = path.getOrDefault("ascLocation")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "ascLocation", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  var valid_594144 = path.getOrDefault("taskName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "taskName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_TasksGetSubscriptionLevelTask_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_TasksGetSubscriptionLevelTask_594139;
          ascLocation: string; subscriptionId: string; taskName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## tasksGetSubscriptionLevelTask
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "ascLocation", newJString(ascLocation))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "taskName", newJString(taskName))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var tasksGetSubscriptionLevelTask* = Call_TasksGetSubscriptionLevelTask_594139(
    name: "tasksGetSubscriptionLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetSubscriptionLevelTask_594140, base: "",
    url: url_TasksGetSubscriptionLevelTask_594141, schemes: {Scheme.Https})
type
  Call_TasksUpdateSubscriptionLevelTaskState_594150 = ref object of OpenApiRestCall_593439
proc url_TasksUpdateSubscriptionLevelTaskState_594152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  assert "taskUpdateActionType" in path,
        "`taskUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "taskUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdateSubscriptionLevelTaskState_594151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: JString (required)
  ##                       : Type of the action to do on the task
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594153 = path.getOrDefault("ascLocation")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "ascLocation", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594155 = path.getOrDefault("taskName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "taskName", valid_594155
  var valid_594156 = path.getOrDefault("taskUpdateActionType")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = newJString("Activate"))
  if valid_594156 != nil:
    section.add "taskUpdateActionType", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594157 = query.getOrDefault("api-version")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594157 != nil:
    section.add "api-version", valid_594157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_TasksUpdateSubscriptionLevelTaskState_594150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_TasksUpdateSubscriptionLevelTaskState_594150;
          ascLocation: string; subscriptionId: string; taskName: string;
          apiVersion: string = "2015-06-01-preview";
          taskUpdateActionType: string = "Activate"): Recallable =
  ## tasksUpdateSubscriptionLevelTaskState
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: string (required)
  ##                       : Type of the action to do on the task
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  add(query_594161, "api-version", newJString(apiVersion))
  add(path_594160, "ascLocation", newJString(ascLocation))
  add(path_594160, "subscriptionId", newJString(subscriptionId))
  add(path_594160, "taskName", newJString(taskName))
  add(path_594160, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_594159.call(path_594160, query_594161, nil, nil, nil)

var tasksUpdateSubscriptionLevelTaskState* = Call_TasksUpdateSubscriptionLevelTaskState_594150(
    name: "tasksUpdateSubscriptionLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateSubscriptionLevelTaskState_594151, base: "",
    url: url_TasksUpdateSubscriptionLevelTaskState_594152, schemes: {Scheme.Https})
type
  Call_TopologyListByHomeRegion_594162 = ref object of OpenApiRestCall_593439
proc url_TopologyListByHomeRegion_594164(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/topologies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopologyListByHomeRegion_594163(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list that allows to build a topology view of a subscription and location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_594165 = path.getOrDefault("ascLocation")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "ascLocation", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_TopologyListByHomeRegion_594162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list that allows to build a topology view of a subscription and location.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_TopologyListByHomeRegion_594162; ascLocation: string;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## topologyListByHomeRegion
  ## Gets a list that allows to build a topology view of a subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "ascLocation", newJString(ascLocation))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var topologyListByHomeRegion* = Call_TopologyListByHomeRegion_594162(
    name: "topologyListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/topologies",
    validator: validate_TopologyListByHomeRegion_594163, base: "",
    url: url_TopologyListByHomeRegion_594164, schemes: {Scheme.Https})
type
  Call_TasksList_594172 = ref object of OpenApiRestCall_593439
proc url_TasksList_594174(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_594173(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594175 = path.getOrDefault("subscriptionId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "subscriptionId", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  var valid_594177 = query.getOrDefault("$filter")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "$filter", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_TasksList_594172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_TasksList_594172; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Filter: string = ""): Recallable =
  ## tasksList
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(query_594181, "api-version", newJString(apiVersion))
  add(path_594180, "subscriptionId", newJString(subscriptionId))
  add(query_594181, "$filter", newJString(Filter))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var tasksList* = Call_TasksList_594172(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/tasks",
                                    validator: validate_TasksList_594173,
                                    base: "", url: url_TasksList_594174,
                                    schemes: {Scheme.Https})
type
  Call_TopologyList_594182 = ref object of OpenApiRestCall_593439
proc url_TopologyList_594184(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/topologies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopologyList_594183(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list that allows to build a topology view of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_TopologyList_594182; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list that allows to build a topology view of a subscription.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_TopologyList_594182; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## topologyList
  ## Gets a list that allows to build a topology view of a subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "subscriptionId", newJString(subscriptionId))
  result = call_594188.call(path_594189, query_594190, nil, nil, nil)

var topologyList* = Call_TopologyList_594182(name: "topologyList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/topologies",
    validator: validate_TopologyList_594183, base: "", url: url_TopologyList_594184,
    schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroup_594191 = ref object of OpenApiRestCall_593439
proc url_AlertsListByResourceGroup_594193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByResourceGroup_594192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594194 = path.getOrDefault("resourceGroupName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "resourceGroupName", valid_594194
  var valid_594195 = path.getOrDefault("subscriptionId")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "subscriptionId", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  var valid_594197 = query.getOrDefault("$expand")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "$expand", valid_594197
  var valid_594198 = query.getOrDefault("$select")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "$select", valid_594198
  var valid_594199 = query.getOrDefault("$filter")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "$filter", valid_594199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594200: Call_AlertsListByResourceGroup_594191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_AlertsListByResourceGroup_594191;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## alertsListByResourceGroup
  ## List all the alerts that are associated with the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  add(path_594202, "resourceGroupName", newJString(resourceGroupName))
  add(query_594203, "api-version", newJString(apiVersion))
  add(query_594203, "$expand", newJString(Expand))
  add(path_594202, "subscriptionId", newJString(subscriptionId))
  add(query_594203, "$select", newJString(Select))
  add(query_594203, "$filter", newJString(Filter))
  result = call_594201.call(path_594202, query_594203, nil, nil, nil)

var alertsListByResourceGroup* = Call_AlertsListByResourceGroup_594191(
    name: "alertsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/alerts",
    validator: validate_AlertsListByResourceGroup_594192, base: "",
    url: url_AlertsListByResourceGroup_594193, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByResourceGroup_594204 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesListByResourceGroup_594206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/jitNetworkAccessPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesListByResourceGroup_594205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594209 = query.getOrDefault("api-version")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594209 != nil:
    section.add "api-version", valid_594209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_JitNetworkAccessPoliciesListByResourceGroup_594204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_JitNetworkAccessPoliciesListByResourceGroup_594204;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesListByResourceGroup
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var jitNetworkAccessPoliciesListByResourceGroup* = Call_JitNetworkAccessPoliciesListByResourceGroup_594204(
    name: "jitNetworkAccessPoliciesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByResourceGroup_594205,
    base: "", url: url_JitNetworkAccessPoliciesListByResourceGroup_594206,
    schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsGet_594214 = ref object of OpenApiRestCall_593439
proc url_ExternalSecuritySolutionsGet_594216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "externalSecuritySolutionsName" in path,
        "`externalSecuritySolutionsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/ExternalSecuritySolutions/"),
               (kind: VariableSegment, value: "externalSecuritySolutionsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExternalSecuritySolutionsGet_594215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific external Security Solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   externalSecuritySolutionsName: JString (required)
  ##                                : Name of an external security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `externalSecuritySolutionsName` field"
  var valid_594217 = path.getOrDefault("externalSecuritySolutionsName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "externalSecuritySolutionsName", valid_594217
  var valid_594218 = path.getOrDefault("resourceGroupName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "resourceGroupName", valid_594218
  var valid_594219 = path.getOrDefault("ascLocation")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "ascLocation", valid_594219
  var valid_594220 = path.getOrDefault("subscriptionId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "subscriptionId", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_ExternalSecuritySolutionsGet_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific external Security Solution.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_ExternalSecuritySolutionsGet_594214;
          externalSecuritySolutionsName: string; resourceGroupName: string;
          ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## externalSecuritySolutionsGet
  ## Gets a specific external Security Solution.
  ##   externalSecuritySolutionsName: string (required)
  ##                                : Name of an external security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "externalSecuritySolutionsName",
      newJString(externalSecuritySolutionsName))
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "ascLocation", newJString(ascLocation))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var externalSecuritySolutionsGet* = Call_ExternalSecuritySolutionsGet_594214(
    name: "externalSecuritySolutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/ExternalSecuritySolutions/{externalSecuritySolutionsName}",
    validator: validate_ExternalSecuritySolutionsGet_594215, base: "",
    url: url_ExternalSecuritySolutionsGet_594216, schemes: {Scheme.Https})
type
  Call_AlertsListResourceGroupLevelAlertsByRegion_594226 = ref object of OpenApiRestCall_593439
proc url_AlertsListResourceGroupLevelAlertsByRegion_594228(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListResourceGroupLevelAlertsByRegion_594227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("ascLocation")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "ascLocation", valid_594230
  var valid_594231 = path.getOrDefault("subscriptionId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "subscriptionId", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  var valid_594233 = query.getOrDefault("$expand")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "$expand", valid_594233
  var valid_594234 = query.getOrDefault("$select")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "$select", valid_594234
  var valid_594235 = query.getOrDefault("$filter")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "$filter", valid_594235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594236: Call_AlertsListResourceGroupLevelAlertsByRegion_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  let valid = call_594236.validator(path, query, header, formData, body)
  let scheme = call_594236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594236.url(scheme.get, call_594236.host, call_594236.base,
                         call_594236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594236, url, valid)

proc call*(call_594237: Call_AlertsListResourceGroupLevelAlertsByRegion_594226;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## alertsListResourceGroupLevelAlertsByRegion
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594238 = newJObject()
  var query_594239 = newJObject()
  add(path_594238, "resourceGroupName", newJString(resourceGroupName))
  add(query_594239, "api-version", newJString(apiVersion))
  add(query_594239, "$expand", newJString(Expand))
  add(path_594238, "ascLocation", newJString(ascLocation))
  add(path_594238, "subscriptionId", newJString(subscriptionId))
  add(query_594239, "$select", newJString(Select))
  add(query_594239, "$filter", newJString(Filter))
  result = call_594237.call(path_594238, query_594239, nil, nil, nil)

var alertsListResourceGroupLevelAlertsByRegion* = Call_AlertsListResourceGroupLevelAlertsByRegion_594226(
    name: "alertsListResourceGroupLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListResourceGroupLevelAlertsByRegion_594227,
    base: "", url: url_AlertsListResourceGroupLevelAlertsByRegion_594228,
    schemes: {Scheme.Https})
type
  Call_AlertsGetResourceGroupLevelAlerts_594240 = ref object of OpenApiRestCall_593439
proc url_AlertsGetResourceGroupLevelAlerts_594242(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetResourceGroupLevelAlerts_594241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594243 = path.getOrDefault("resourceGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "resourceGroupName", valid_594243
  var valid_594244 = path.getOrDefault("ascLocation")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "ascLocation", valid_594244
  var valid_594245 = path.getOrDefault("subscriptionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "subscriptionId", valid_594245
  var valid_594246 = path.getOrDefault("alertName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "alertName", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_AlertsGetResourceGroupLevelAlerts_594240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_AlertsGetResourceGroupLevelAlerts_594240;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          alertName: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## alertsGetResourceGroupLevelAlerts
  ## Get an alert that is associated a resource group or a resource in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  add(path_594250, "resourceGroupName", newJString(resourceGroupName))
  add(query_594251, "api-version", newJString(apiVersion))
  add(path_594250, "ascLocation", newJString(ascLocation))
  add(path_594250, "subscriptionId", newJString(subscriptionId))
  add(path_594250, "alertName", newJString(alertName))
  result = call_594249.call(path_594250, query_594251, nil, nil, nil)

var alertsGetResourceGroupLevelAlerts* = Call_AlertsGetResourceGroupLevelAlerts_594240(
    name: "alertsGetResourceGroupLevelAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetResourceGroupLevelAlerts_594241, base: "",
    url: url_AlertsGetResourceGroupLevelAlerts_594242, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupLevelAlertState_594252 = ref object of OpenApiRestCall_593439
proc url_AlertsUpdateResourceGroupLevelAlertState_594254(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  assert "alertUpdateActionType" in path,
        "`alertUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "alertUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateResourceGroupLevelAlertState_594253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594255 = path.getOrDefault("resourceGroupName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "resourceGroupName", valid_594255
  var valid_594256 = path.getOrDefault("ascLocation")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "ascLocation", valid_594256
  var valid_594257 = path.getOrDefault("subscriptionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "subscriptionId", valid_594257
  var valid_594258 = path.getOrDefault("alertUpdateActionType")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_594258 != nil:
    section.add "alertUpdateActionType", valid_594258
  var valid_594259 = path.getOrDefault("alertName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "alertName", valid_594259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594260 = query.getOrDefault("api-version")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594260 != nil:
    section.add "api-version", valid_594260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594261: Call_AlertsUpdateResourceGroupLevelAlertState_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_AlertsUpdateResourceGroupLevelAlertState_594252;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          alertName: string; apiVersion: string = "2015-06-01-preview";
          alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateResourceGroupLevelAlertState
  ## Update the alert's state
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  add(path_594263, "resourceGroupName", newJString(resourceGroupName))
  add(query_594264, "api-version", newJString(apiVersion))
  add(path_594263, "ascLocation", newJString(ascLocation))
  add(path_594263, "subscriptionId", newJString(subscriptionId))
  add(path_594263, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_594263, "alertName", newJString(alertName))
  result = call_594262.call(path_594263, query_594264, nil, nil, nil)

var alertsUpdateResourceGroupLevelAlertState* = Call_AlertsUpdateResourceGroupLevelAlertState_594252(
    name: "alertsUpdateResourceGroupLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateResourceGroupLevelAlertState_594253, base: "",
    url: url_AlertsUpdateResourceGroupLevelAlertState_594254,
    schemes: {Scheme.Https})
type
  Call_AllowedConnectionsGet_594265 = ref object of OpenApiRestCall_593439
proc url_AllowedConnectionsGet_594267(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "connectionType" in path, "`connectionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/allowedConnections/"),
               (kind: VariableSegment, value: "connectionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AllowedConnectionsGet_594266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of all possible traffic between resources for the subscription and location, based on connection type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   connectionType: JString (required)
  ##                 : The type of allowed connections (Internal, External)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594268 = path.getOrDefault("resourceGroupName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "resourceGroupName", valid_594268
  var valid_594269 = path.getOrDefault("ascLocation")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "ascLocation", valid_594269
  var valid_594270 = path.getOrDefault("subscriptionId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "subscriptionId", valid_594270
  var valid_594271 = path.getOrDefault("connectionType")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = newJString("Internal"))
  if valid_594271 != nil:
    section.add "connectionType", valid_594271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594272 = query.getOrDefault("api-version")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594272 != nil:
    section.add "api-version", valid_594272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594273: Call_AllowedConnectionsGet_594265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription and location, based on connection type.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_AllowedConnectionsGet_594265;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview";
          connectionType: string = "Internal"): Recallable =
  ## allowedConnectionsGet
  ## Gets the list of all possible traffic between resources for the subscription and location, based on connection type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   connectionType: string (required)
  ##                 : The type of allowed connections (Internal, External)
  var path_594275 = newJObject()
  var query_594276 = newJObject()
  add(path_594275, "resourceGroupName", newJString(resourceGroupName))
  add(query_594276, "api-version", newJString(apiVersion))
  add(path_594275, "ascLocation", newJString(ascLocation))
  add(path_594275, "subscriptionId", newJString(subscriptionId))
  add(path_594275, "connectionType", newJString(connectionType))
  result = call_594274.call(path_594275, query_594276, nil, nil, nil)

var allowedConnectionsGet* = Call_AllowedConnectionsGet_594265(
    name: "allowedConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/allowedConnections/{connectionType}",
    validator: validate_AllowedConnectionsGet_594266, base: "",
    url: url_AllowedConnectionsGet_594267, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsGet_594277 = ref object of OpenApiRestCall_593439
proc url_DiscoveredSecuritySolutionsGet_594279(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "discoveredSecuritySolutionName" in path,
        "`discoveredSecuritySolutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/discoveredSecuritySolutions/"),
               (kind: VariableSegment, value: "discoveredSecuritySolutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiscoveredSecuritySolutionsGet_594278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific discovered Security Solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   discoveredSecuritySolutionName: JString (required)
  ##                                 : Name of a discovered security solution.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594280 = path.getOrDefault("resourceGroupName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "resourceGroupName", valid_594280
  var valid_594281 = path.getOrDefault("ascLocation")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "ascLocation", valid_594281
  var valid_594282 = path.getOrDefault("subscriptionId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "subscriptionId", valid_594282
  var valid_594283 = path.getOrDefault("discoveredSecuritySolutionName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "discoveredSecuritySolutionName", valid_594283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594284 = query.getOrDefault("api-version")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594284 != nil:
    section.add "api-version", valid_594284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_DiscoveredSecuritySolutionsGet_594277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific discovered Security Solution.
  ## 
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_DiscoveredSecuritySolutionsGet_594277;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          discoveredSecuritySolutionName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## discoveredSecuritySolutionsGet
  ## Gets a specific discovered Security Solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   discoveredSecuritySolutionName: string (required)
  ##                                 : Name of a discovered security solution.
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  add(path_594287, "resourceGroupName", newJString(resourceGroupName))
  add(query_594288, "api-version", newJString(apiVersion))
  add(path_594287, "ascLocation", newJString(ascLocation))
  add(path_594287, "subscriptionId", newJString(subscriptionId))
  add(path_594287, "discoveredSecuritySolutionName",
      newJString(discoveredSecuritySolutionName))
  result = call_594286.call(path_594287, query_594288, nil, nil, nil)

var discoveredSecuritySolutionsGet* = Call_DiscoveredSecuritySolutionsGet_594277(
    name: "discoveredSecuritySolutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions/{discoveredSecuritySolutionName}",
    validator: validate_DiscoveredSecuritySolutionsGet_594278, base: "",
    url: url_DiscoveredSecuritySolutionsGet_594279, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594289 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594290(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594292 = path.getOrDefault("resourceGroupName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "resourceGroupName", valid_594292
  var valid_594293 = path.getOrDefault("ascLocation")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "ascLocation", valid_594293
  var valid_594294 = path.getOrDefault("subscriptionId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "subscriptionId", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594289;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesListByResourceGroupAndRegion
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "ascLocation", newJString(ascLocation))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var jitNetworkAccessPoliciesListByResourceGroupAndRegion* = Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594289(
    name: "jitNetworkAccessPoliciesListByResourceGroupAndRegion",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594290,
    base: "", url: url_JitNetworkAccessPoliciesListByResourceGroupAndRegion_594291,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesCreateOrUpdate_594312 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesCreateOrUpdate_594314(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "jitNetworkAccessPolicyName" in path,
        "`jitNetworkAccessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies/"),
               (kind: VariableSegment, value: "jitNetworkAccessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesCreateOrUpdate_594313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a policy for protecting resources using Just-in-Time access control
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: JString (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594315 = path.getOrDefault("resourceGroupName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "resourceGroupName", valid_594315
  var valid_594316 = path.getOrDefault("ascLocation")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "ascLocation", valid_594316
  var valid_594317 = path.getOrDefault("subscriptionId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "subscriptionId", valid_594317
  var valid_594318 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "jitNetworkAccessPolicyName", valid_594318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594319 = query.getOrDefault("api-version")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594319 != nil:
    section.add "api-version", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_JitNetworkAccessPoliciesCreateOrUpdate_594312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a policy for protecting resources using Just-in-Time access control
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_JitNetworkAccessPoliciesCreateOrUpdate_594312;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          jitNetworkAccessPolicyName: string; body: JsonNode;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesCreateOrUpdate
  ## Create a policy for protecting resources using Just-in-Time access control
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: string (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  ##   body: JObject (required)
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  var body_594325 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "ascLocation", newJString(ascLocation))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(path_594323, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  if body != nil:
    body_594325 = body
  result = call_594322.call(path_594323, query_594324, nil, nil, body_594325)

var jitNetworkAccessPoliciesCreateOrUpdate* = Call_JitNetworkAccessPoliciesCreateOrUpdate_594312(
    name: "jitNetworkAccessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesCreateOrUpdate_594313, base: "",
    url: url_JitNetworkAccessPoliciesCreateOrUpdate_594314,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesGet_594300 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesGet_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "jitNetworkAccessPolicyName" in path,
        "`jitNetworkAccessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies/"),
               (kind: VariableSegment, value: "jitNetworkAccessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesGet_594301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: JString (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594303 = path.getOrDefault("resourceGroupName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceGroupName", valid_594303
  var valid_594304 = path.getOrDefault("ascLocation")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "ascLocation", valid_594304
  var valid_594305 = path.getOrDefault("subscriptionId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "subscriptionId", valid_594305
  var valid_594306 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "jitNetworkAccessPolicyName", valid_594306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594307 = query.getOrDefault("api-version")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594307 != nil:
    section.add "api-version", valid_594307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594308: Call_JitNetworkAccessPoliciesGet_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_594308.validator(path, query, header, formData, body)
  let scheme = call_594308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594308.url(scheme.get, call_594308.host, call_594308.base,
                         call_594308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594308, url, valid)

proc call*(call_594309: Call_JitNetworkAccessPoliciesGet_594300;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          jitNetworkAccessPolicyName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesGet
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: string (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  var path_594310 = newJObject()
  var query_594311 = newJObject()
  add(path_594310, "resourceGroupName", newJString(resourceGroupName))
  add(query_594311, "api-version", newJString(apiVersion))
  add(path_594310, "ascLocation", newJString(ascLocation))
  add(path_594310, "subscriptionId", newJString(subscriptionId))
  add(path_594310, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  result = call_594309.call(path_594310, query_594311, nil, nil, nil)

var jitNetworkAccessPoliciesGet* = Call_JitNetworkAccessPoliciesGet_594300(
    name: "jitNetworkAccessPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesGet_594301, base: "",
    url: url_JitNetworkAccessPoliciesGet_594302, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesDelete_594326 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesDelete_594328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "jitNetworkAccessPolicyName" in path,
        "`jitNetworkAccessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies/"),
               (kind: VariableSegment, value: "jitNetworkAccessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesDelete_594327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Just-in-Time access control policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: JString (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594329 = path.getOrDefault("resourceGroupName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resourceGroupName", valid_594329
  var valid_594330 = path.getOrDefault("ascLocation")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "ascLocation", valid_594330
  var valid_594331 = path.getOrDefault("subscriptionId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "subscriptionId", valid_594331
  var valid_594332 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "jitNetworkAccessPolicyName", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594333 = query.getOrDefault("api-version")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594333 != nil:
    section.add "api-version", valid_594333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594334: Call_JitNetworkAccessPoliciesDelete_594326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Just-in-Time access control policy.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_JitNetworkAccessPoliciesDelete_594326;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          jitNetworkAccessPolicyName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesDelete
  ## Delete a Just-in-Time access control policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: string (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  add(path_594336, "resourceGroupName", newJString(resourceGroupName))
  add(query_594337, "api-version", newJString(apiVersion))
  add(path_594336, "ascLocation", newJString(ascLocation))
  add(path_594336, "subscriptionId", newJString(subscriptionId))
  add(path_594336, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  result = call_594335.call(path_594336, query_594337, nil, nil, nil)

var jitNetworkAccessPoliciesDelete* = Call_JitNetworkAccessPoliciesDelete_594326(
    name: "jitNetworkAccessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesDelete_594327, base: "",
    url: url_JitNetworkAccessPoliciesDelete_594328, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesInitiate_594338 = ref object of OpenApiRestCall_593439
proc url_JitNetworkAccessPoliciesInitiate_594340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "jitNetworkAccessPolicyName" in path,
        "`jitNetworkAccessPolicyName` is a required path parameter"
  assert "jitNetworkAccessPolicyInitiateType" in path,
        "`jitNetworkAccessPolicyInitiateType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/jitNetworkAccessPolicies/"),
               (kind: VariableSegment, value: "jitNetworkAccessPolicyName"),
               (kind: ConstantSegment, value: "/"), (kind: VariableSegment,
        value: "jitNetworkAccessPolicyInitiateType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JitNetworkAccessPoliciesInitiate_594339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiate a JIT access from a specific Just-in-Time policy configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jitNetworkAccessPolicyInitiateType: JString (required)
  ##                                     : Type of the action to do on the Just-in-Time access policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: JString (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jitNetworkAccessPolicyInitiateType` field"
  var valid_594341 = path.getOrDefault("jitNetworkAccessPolicyInitiateType")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = newJString("initiate"))
  if valid_594341 != nil:
    section.add "jitNetworkAccessPolicyInitiateType", valid_594341
  var valid_594342 = path.getOrDefault("resourceGroupName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "resourceGroupName", valid_594342
  var valid_594343 = path.getOrDefault("ascLocation")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "ascLocation", valid_594343
  var valid_594344 = path.getOrDefault("subscriptionId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "subscriptionId", valid_594344
  var valid_594345 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "jitNetworkAccessPolicyName", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594346 != nil:
    section.add "api-version", valid_594346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594348: Call_JitNetworkAccessPoliciesInitiate_594338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate a JIT access from a specific Just-in-Time policy configuration.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_JitNetworkAccessPoliciesInitiate_594338;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          jitNetworkAccessPolicyName: string; body: JsonNode;
          jitNetworkAccessPolicyInitiateType: string = "initiate";
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesInitiate
  ## Initiate a JIT access from a specific Just-in-Time policy configuration.
  ##   jitNetworkAccessPolicyInitiateType: string (required)
  ##                                     : Type of the action to do on the Just-in-Time access policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   jitNetworkAccessPolicyName: string (required)
  ##                             : Name of a Just-in-Time access configuration policy.
  ##   body: JObject (required)
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  var body_594352 = newJObject()
  add(path_594350, "jitNetworkAccessPolicyInitiateType",
      newJString(jitNetworkAccessPolicyInitiateType))
  add(path_594350, "resourceGroupName", newJString(resourceGroupName))
  add(query_594351, "api-version", newJString(apiVersion))
  add(path_594350, "ascLocation", newJString(ascLocation))
  add(path_594350, "subscriptionId", newJString(subscriptionId))
  add(path_594350, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  if body != nil:
    body_594352 = body
  result = call_594349.call(path_594350, query_594351, nil, nil, body_594352)

var jitNetworkAccessPoliciesInitiate* = Call_JitNetworkAccessPoliciesInitiate_594338(
    name: "jitNetworkAccessPoliciesInitiate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}/{jitNetworkAccessPolicyInitiateType}",
    validator: validate_JitNetworkAccessPoliciesInitiate_594339, base: "",
    url: url_JitNetworkAccessPoliciesInitiate_594340, schemes: {Scheme.Https})
type
  Call_TasksListByResourceGroup_594353 = ref object of OpenApiRestCall_593439
proc url_TasksListByResourceGroup_594355(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksListByResourceGroup_594354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594356 = path.getOrDefault("resourceGroupName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "resourceGroupName", valid_594356
  var valid_594357 = path.getOrDefault("ascLocation")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "ascLocation", valid_594357
  var valid_594358 = path.getOrDefault("subscriptionId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "subscriptionId", valid_594358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594359 = query.getOrDefault("api-version")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594359 != nil:
    section.add "api-version", valid_594359
  var valid_594360 = query.getOrDefault("$filter")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "$filter", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_TasksListByResourceGroup_594353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_TasksListByResourceGroup_594353;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Filter: string = ""): Recallable =
  ## tasksListByResourceGroup
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(path_594363, "resourceGroupName", newJString(resourceGroupName))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "ascLocation", newJString(ascLocation))
  add(path_594363, "subscriptionId", newJString(subscriptionId))
  add(query_594364, "$filter", newJString(Filter))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var tasksListByResourceGroup* = Call_TasksListByResourceGroup_594353(
    name: "tasksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByResourceGroup_594354, base: "",
    url: url_TasksListByResourceGroup_594355, schemes: {Scheme.Https})
type
  Call_TasksGetResourceGroupLevelTask_594365 = ref object of OpenApiRestCall_593439
proc url_TasksGetResourceGroupLevelTask_594367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGetResourceGroupLevelTask_594366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594368 = path.getOrDefault("resourceGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "resourceGroupName", valid_594368
  var valid_594369 = path.getOrDefault("ascLocation")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "ascLocation", valid_594369
  var valid_594370 = path.getOrDefault("subscriptionId")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "subscriptionId", valid_594370
  var valid_594371 = path.getOrDefault("taskName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "taskName", valid_594371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594372 = query.getOrDefault("api-version")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594372 != nil:
    section.add "api-version", valid_594372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594373: Call_TasksGetResourceGroupLevelTask_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594373.validator(path, query, header, formData, body)
  let scheme = call_594373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594373.url(scheme.get, call_594373.host, call_594373.base,
                         call_594373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594373, url, valid)

proc call*(call_594374: Call_TasksGetResourceGroupLevelTask_594365;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          taskName: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## tasksGetResourceGroupLevelTask
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  var path_594375 = newJObject()
  var query_594376 = newJObject()
  add(path_594375, "resourceGroupName", newJString(resourceGroupName))
  add(query_594376, "api-version", newJString(apiVersion))
  add(path_594375, "ascLocation", newJString(ascLocation))
  add(path_594375, "subscriptionId", newJString(subscriptionId))
  add(path_594375, "taskName", newJString(taskName))
  result = call_594374.call(path_594375, query_594376, nil, nil, nil)

var tasksGetResourceGroupLevelTask* = Call_TasksGetResourceGroupLevelTask_594365(
    name: "tasksGetResourceGroupLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetResourceGroupLevelTask_594366, base: "",
    url: url_TasksGetResourceGroupLevelTask_594367, schemes: {Scheme.Https})
type
  Call_TasksUpdateResourceGroupLevelTaskState_594377 = ref object of OpenApiRestCall_593439
proc url_TasksUpdateResourceGroupLevelTaskState_594379(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  assert "taskUpdateActionType" in path,
        "`taskUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "taskUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdateResourceGroupLevelTaskState_594378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: JString (required)
  ##                       : Type of the action to do on the task
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594380 = path.getOrDefault("resourceGroupName")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "resourceGroupName", valid_594380
  var valid_594381 = path.getOrDefault("ascLocation")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "ascLocation", valid_594381
  var valid_594382 = path.getOrDefault("subscriptionId")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "subscriptionId", valid_594382
  var valid_594383 = path.getOrDefault("taskName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "taskName", valid_594383
  var valid_594384 = path.getOrDefault("taskUpdateActionType")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = newJString("Activate"))
  if valid_594384 != nil:
    section.add "taskUpdateActionType", valid_594384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594385 = query.getOrDefault("api-version")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594385 != nil:
    section.add "api-version", valid_594385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594386: Call_TasksUpdateResourceGroupLevelTaskState_594377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594386.validator(path, query, header, formData, body)
  let scheme = call_594386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594386.url(scheme.get, call_594386.host, call_594386.base,
                         call_594386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594386, url, valid)

proc call*(call_594387: Call_TasksUpdateResourceGroupLevelTaskState_594377;
          resourceGroupName: string; ascLocation: string; subscriptionId: string;
          taskName: string; apiVersion: string = "2015-06-01-preview";
          taskUpdateActionType: string = "Activate"): Recallable =
  ## tasksUpdateResourceGroupLevelTaskState
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: string (required)
  ##                       : Type of the action to do on the task
  var path_594388 = newJObject()
  var query_594389 = newJObject()
  add(path_594388, "resourceGroupName", newJString(resourceGroupName))
  add(query_594389, "api-version", newJString(apiVersion))
  add(path_594388, "ascLocation", newJString(ascLocation))
  add(path_594388, "subscriptionId", newJString(subscriptionId))
  add(path_594388, "taskName", newJString(taskName))
  add(path_594388, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_594387.call(path_594388, query_594389, nil, nil, nil)

var tasksUpdateResourceGroupLevelTaskState* = Call_TasksUpdateResourceGroupLevelTaskState_594377(
    name: "tasksUpdateResourceGroupLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateResourceGroupLevelTaskState_594378, base: "",
    url: url_TasksUpdateResourceGroupLevelTaskState_594379,
    schemes: {Scheme.Https})
type
  Call_TopologyGet_594390 = ref object of OpenApiRestCall_593439
proc url_TopologyGet_594392(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "topologyResourceName" in path,
        "`topologyResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/topologies/"),
               (kind: VariableSegment, value: "topologyResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopologyGet_594391(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific topology component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   topologyResourceName: JString (required)
  ##                       : Name of a topology resources collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594393 = path.getOrDefault("resourceGroupName")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "resourceGroupName", valid_594393
  var valid_594394 = path.getOrDefault("ascLocation")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "ascLocation", valid_594394
  var valid_594395 = path.getOrDefault("subscriptionId")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "subscriptionId", valid_594395
  var valid_594396 = path.getOrDefault("topologyResourceName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "topologyResourceName", valid_594396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594397 = query.getOrDefault("api-version")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_594397 != nil:
    section.add "api-version", valid_594397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594398: Call_TopologyGet_594390; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific topology component.
  ## 
  let valid = call_594398.validator(path, query, header, formData, body)
  let scheme = call_594398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594398.url(scheme.get, call_594398.host, call_594398.base,
                         call_594398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594398, url, valid)

proc call*(call_594399: Call_TopologyGet_594390; resourceGroupName: string;
          ascLocation: string; subscriptionId: string; topologyResourceName: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## topologyGet
  ## Gets a specific topology component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   topologyResourceName: string (required)
  ##                       : Name of a topology resources collection.
  var path_594400 = newJObject()
  var query_594401 = newJObject()
  add(path_594400, "resourceGroupName", newJString(resourceGroupName))
  add(query_594401, "api-version", newJString(apiVersion))
  add(path_594400, "ascLocation", newJString(ascLocation))
  add(path_594400, "subscriptionId", newJString(subscriptionId))
  add(path_594400, "topologyResourceName", newJString(topologyResourceName))
  result = call_594399.call(path_594400, query_594401, nil, nil, nil)

var topologyGet* = Call_TopologyGet_594390(name: "topologyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/topologies/{topologyResourceName}",
                                        validator: validate_TopologyGet_594391,
                                        base: "", url: url_TopologyGet_594392,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
