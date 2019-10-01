
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "security"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
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
  var valid_568064 = query.getOrDefault("api-version")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568064 != nil:
    section.add "api-version", valid_568064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568087: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes all available operations for discovery purposes.
  ## 
  let valid = call_568087.validator(path, query, header, formData, body)
  let scheme = call_568087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568087.url(scheme.get, call_568087.host, call_568087.base,
                         call_568087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568087, url, valid)

proc call*(call_568158: Call_OperationsList_567890;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## operationsList
  ## Exposes all available operations for discovery purposes.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  var query_568159 = newJObject()
  add(query_568159, "api-version", newJString(apiVersion))
  result = call_568158.call(nil, query_568159, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Security/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_AlertsList_568199 = ref object of OpenApiRestCall_567668
proc url_AlertsList_568201(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsList_568200(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
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
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  var valid_568219 = query.getOrDefault("$expand")
  valid_568219 = validateParameter(valid_568219, JString, required = false,
                                 default = nil)
  if valid_568219 != nil:
    section.add "$expand", valid_568219
  var valid_568220 = query.getOrDefault("$select")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$select", valid_568220
  var valid_568221 = query.getOrDefault("$filter")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "$filter", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_AlertsList_568199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_AlertsList_568199; subscriptionId: string;
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
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(query_568225, "$expand", newJString(Expand))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(query_568225, "$select", newJString(Select))
  add(query_568225, "$filter", newJString(Filter))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var alertsList* = Call_AlertsList_568199(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/alerts",
                                      validator: validate_AlertsList_568200,
                                      base: "", url: url_AlertsList_568201,
                                      schemes: {Scheme.Https})
type
  Call_AllowedConnectionsList_568226 = ref object of OpenApiRestCall_567668
proc url_AllowedConnectionsList_568228(protocol: Scheme; host: string; base: string;
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

proc validate_AllowedConnectionsList_568227(path: JsonNode; query: JsonNode;
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
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_AllowedConnectionsList_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_AllowedConnectionsList_568226; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## allowedConnectionsList
  ## Gets the list of all possible traffic between resources for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var allowedConnectionsList* = Call_AllowedConnectionsList_568226(
    name: "allowedConnectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/allowedConnections",
    validator: validate_AllowedConnectionsList_568227, base: "",
    url: url_AllowedConnectionsList_568228, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsList_568235 = ref object of OpenApiRestCall_567668
proc url_DiscoveredSecuritySolutionsList_568237(protocol: Scheme; host: string;
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

proc validate_DiscoveredSecuritySolutionsList_568236(path: JsonNode;
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
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_DiscoveredSecuritySolutionsList_568235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_DiscoveredSecuritySolutionsList_568235;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## discoveredSecuritySolutionsList
  ## Gets a list of discovered Security Solutions for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var discoveredSecuritySolutionsList* = Call_DiscoveredSecuritySolutionsList_568235(
    name: "discoveredSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsList_568236, base: "",
    url: url_DiscoveredSecuritySolutionsList_568237, schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsList_568244 = ref object of OpenApiRestCall_567668
proc url_ExternalSecuritySolutionsList_568246(protocol: Scheme; host: string;
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

proc validate_ExternalSecuritySolutionsList_568245(path: JsonNode; query: JsonNode;
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
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ExternalSecuritySolutionsList_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of external security solutions for the subscription.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ExternalSecuritySolutionsList_568244;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## externalSecuritySolutionsList
  ## Gets a list of external security solutions for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var externalSecuritySolutionsList* = Call_ExternalSecuritySolutionsList_568244(
    name: "externalSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/externalSecuritySolutions",
    validator: validate_ExternalSecuritySolutionsList_568245, base: "",
    url: url_ExternalSecuritySolutionsList_568246, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesList_568253 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesList_568255(protocol: Scheme; host: string;
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

proc validate_JitNetworkAccessPoliciesList_568254(path: JsonNode; query: JsonNode;
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
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_JitNetworkAccessPoliciesList_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_JitNetworkAccessPoliciesList_568253;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## jitNetworkAccessPoliciesList
  ## Policies for protecting resources using Just-in-Time access control.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var jitNetworkAccessPoliciesList* = Call_JitNetworkAccessPoliciesList_568253(
    name: "jitNetworkAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesList_568254, base: "",
    url: url_JitNetworkAccessPoliciesList_568255, schemes: {Scheme.Https})
type
  Call_LocationsList_568262 = ref object of OpenApiRestCall_567668
proc url_LocationsList_568264(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsList_568263(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_LocationsList_568262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The location of the responsible ASC of the specific subscription (home region). For each subscription there is only one responsible location. The location in the response should be used to read or write other resources in ASC according to their ID.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_LocationsList_568262; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## locationsList
  ## The location of the responsible ASC of the specific subscription (home region). For each subscription there is only one responsible location. The location in the response should be used to read or write other resources in ASC according to their ID.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var locationsList* = Call_LocationsList_568262(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations",
    validator: validate_LocationsList_568263, base: "", url: url_LocationsList_568264,
    schemes: {Scheme.Https})
type
  Call_LocationsGet_568271 = ref object of OpenApiRestCall_567668
proc url_LocationsGet_568273(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsGet_568272(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568274 = path.getOrDefault("ascLocation")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "ascLocation", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_LocationsGet_568271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific location
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_LocationsGet_568271; ascLocation: string;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## locationsGet
  ## Details of a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "ascLocation", newJString(ascLocation))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var locationsGet* = Call_LocationsGet_568271(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}",
    validator: validate_LocationsGet_568272, base: "", url: url_LocationsGet_568273,
    schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsListByHomeRegion_568281 = ref object of OpenApiRestCall_567668
proc url_ExternalSecuritySolutionsListByHomeRegion_568283(protocol: Scheme;
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

proc validate_ExternalSecuritySolutionsListByHomeRegion_568282(path: JsonNode;
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
  var valid_568284 = path.getOrDefault("ascLocation")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "ascLocation", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568287: Call_ExternalSecuritySolutionsListByHomeRegion_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of external Security Solutions for the subscription and location.
  ## 
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_ExternalSecuritySolutionsListByHomeRegion_568281;
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
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "ascLocation", newJString(ascLocation))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  result = call_568288.call(path_568289, query_568290, nil, nil, nil)

var externalSecuritySolutionsListByHomeRegion* = Call_ExternalSecuritySolutionsListByHomeRegion_568281(
    name: "externalSecuritySolutionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/ExternalSecuritySolutions",
    validator: validate_ExternalSecuritySolutionsListByHomeRegion_568282,
    base: "", url: url_ExternalSecuritySolutionsListByHomeRegion_568283,
    schemes: {Scheme.Https})
type
  Call_AlertsListSubscriptionLevelAlertsByRegion_568291 = ref object of OpenApiRestCall_567668
proc url_AlertsListSubscriptionLevelAlertsByRegion_568293(protocol: Scheme;
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

proc validate_AlertsListSubscriptionLevelAlertsByRegion_568292(path: JsonNode;
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
  var valid_568294 = path.getOrDefault("ascLocation")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "ascLocation", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
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
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  var valid_568297 = query.getOrDefault("$expand")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "$expand", valid_568297
  var valid_568298 = query.getOrDefault("$select")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "$select", valid_568298
  var valid_568299 = query.getOrDefault("$filter")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "$filter", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_AlertsListSubscriptionLevelAlertsByRegion_568291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_AlertsListSubscriptionLevelAlertsByRegion_568291;
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
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(query_568303, "api-version", newJString(apiVersion))
  add(query_568303, "$expand", newJString(Expand))
  add(path_568302, "ascLocation", newJString(ascLocation))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(query_568303, "$select", newJString(Select))
  add(query_568303, "$filter", newJString(Filter))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var alertsListSubscriptionLevelAlertsByRegion* = Call_AlertsListSubscriptionLevelAlertsByRegion_568291(
    name: "alertsListSubscriptionLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListSubscriptionLevelAlertsByRegion_568292,
    base: "", url: url_AlertsListSubscriptionLevelAlertsByRegion_568293,
    schemes: {Scheme.Https})
type
  Call_AlertsGetSubscriptionLevelAlert_568304 = ref object of OpenApiRestCall_567668
proc url_AlertsGetSubscriptionLevelAlert_568306(protocol: Scheme; host: string;
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

proc validate_AlertsGetSubscriptionLevelAlert_568305(path: JsonNode;
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
  var valid_568307 = path.getOrDefault("ascLocation")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "ascLocation", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("alertName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "alertName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568310 != nil:
    section.add "api-version", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_AlertsGetSubscriptionLevelAlert_568304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated with a subscription
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_AlertsGetSubscriptionLevelAlert_568304;
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
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "ascLocation", newJString(ascLocation))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "alertName", newJString(alertName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var alertsGetSubscriptionLevelAlert* = Call_AlertsGetSubscriptionLevelAlert_568304(
    name: "alertsGetSubscriptionLevelAlert", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetSubscriptionLevelAlert_568305, base: "",
    url: url_AlertsGetSubscriptionLevelAlert_568306, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionLevelAlertState_568315 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateSubscriptionLevelAlertState_568317(protocol: Scheme;
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

proc validate_AlertsUpdateSubscriptionLevelAlertState_568316(path: JsonNode;
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
  var valid_568318 = path.getOrDefault("ascLocation")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "ascLocation", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("alertUpdateActionType")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_568320 != nil:
    section.add "alertUpdateActionType", valid_568320
  var valid_568321 = path.getOrDefault("alertName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "alertName", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_AlertsUpdateSubscriptionLevelAlertState_568315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_AlertsUpdateSubscriptionLevelAlertState_568315;
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
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  add(query_568326, "api-version", newJString(apiVersion))
  add(path_568325, "ascLocation", newJString(ascLocation))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  add(path_568325, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_568325, "alertName", newJString(alertName))
  result = call_568324.call(path_568325, query_568326, nil, nil, nil)

var alertsUpdateSubscriptionLevelAlertState* = Call_AlertsUpdateSubscriptionLevelAlertState_568315(
    name: "alertsUpdateSubscriptionLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateSubscriptionLevelAlertState_568316, base: "",
    url: url_AlertsUpdateSubscriptionLevelAlertState_568317,
    schemes: {Scheme.Https})
type
  Call_AllowedConnectionsListByHomeRegion_568327 = ref object of OpenApiRestCall_567668
proc url_AllowedConnectionsListByHomeRegion_568329(protocol: Scheme; host: string;
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

proc validate_AllowedConnectionsListByHomeRegion_568328(path: JsonNode;
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
  var valid_568330 = path.getOrDefault("ascLocation")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "ascLocation", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_AllowedConnectionsListByHomeRegion_568327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription and location.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_AllowedConnectionsListByHomeRegion_568327;
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
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "ascLocation", newJString(ascLocation))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var allowedConnectionsListByHomeRegion* = Call_AllowedConnectionsListByHomeRegion_568327(
    name: "allowedConnectionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/allowedConnections",
    validator: validate_AllowedConnectionsListByHomeRegion_568328, base: "",
    url: url_AllowedConnectionsListByHomeRegion_568329, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsListByHomeRegion_568337 = ref object of OpenApiRestCall_567668
proc url_DiscoveredSecuritySolutionsListByHomeRegion_568339(protocol: Scheme;
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

proc validate_DiscoveredSecuritySolutionsListByHomeRegion_568338(path: JsonNode;
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
  var valid_568340 = path.getOrDefault("ascLocation")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "ascLocation", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_DiscoveredSecuritySolutionsListByHomeRegion_568337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_DiscoveredSecuritySolutionsListByHomeRegion_568337;
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
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "ascLocation", newJString(ascLocation))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var discoveredSecuritySolutionsListByHomeRegion* = Call_DiscoveredSecuritySolutionsListByHomeRegion_568337(
    name: "discoveredSecuritySolutionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsListByHomeRegion_568338,
    base: "", url: url_DiscoveredSecuritySolutionsListByHomeRegion_568339,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByRegion_568347 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesListByRegion_568349(protocol: Scheme;
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

proc validate_JitNetworkAccessPoliciesListByRegion_568348(path: JsonNode;
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
  var valid_568350 = path.getOrDefault("ascLocation")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "ascLocation", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_JitNetworkAccessPoliciesListByRegion_568347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_JitNetworkAccessPoliciesListByRegion_568347;
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
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "ascLocation", newJString(ascLocation))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var jitNetworkAccessPoliciesListByRegion* = Call_JitNetworkAccessPoliciesListByRegion_568347(
    name: "jitNetworkAccessPoliciesListByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByRegion_568348, base: "",
    url: url_JitNetworkAccessPoliciesListByRegion_568349, schemes: {Scheme.Https})
type
  Call_TasksListByHomeRegion_568357 = ref object of OpenApiRestCall_567668
proc url_TasksListByHomeRegion_568359(protocol: Scheme; host: string; base: string;
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

proc validate_TasksListByHomeRegion_568358(path: JsonNode; query: JsonNode;
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
  var valid_568360 = path.getOrDefault("ascLocation")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "ascLocation", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  var valid_568363 = query.getOrDefault("$filter")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "$filter", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_TasksListByHomeRegion_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_TasksListByHomeRegion_568357; ascLocation: string;
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
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "ascLocation", newJString(ascLocation))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(query_568367, "$filter", newJString(Filter))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var tasksListByHomeRegion* = Call_TasksListByHomeRegion_568357(
    name: "tasksListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByHomeRegion_568358, base: "",
    url: url_TasksListByHomeRegion_568359, schemes: {Scheme.Https})
type
  Call_TasksGetSubscriptionLevelTask_568368 = ref object of OpenApiRestCall_567668
proc url_TasksGetSubscriptionLevelTask_568370(protocol: Scheme; host: string;
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

proc validate_TasksGetSubscriptionLevelTask_568369(path: JsonNode; query: JsonNode;
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
  var valid_568371 = path.getOrDefault("ascLocation")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "ascLocation", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  var valid_568373 = path.getOrDefault("taskName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "taskName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_TasksGetSubscriptionLevelTask_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_TasksGetSubscriptionLevelTask_568368;
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
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "ascLocation", newJString(ascLocation))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "taskName", newJString(taskName))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var tasksGetSubscriptionLevelTask* = Call_TasksGetSubscriptionLevelTask_568368(
    name: "tasksGetSubscriptionLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetSubscriptionLevelTask_568369, base: "",
    url: url_TasksGetSubscriptionLevelTask_568370, schemes: {Scheme.Https})
type
  Call_TasksUpdateSubscriptionLevelTaskState_568379 = ref object of OpenApiRestCall_567668
proc url_TasksUpdateSubscriptionLevelTaskState_568381(protocol: Scheme;
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

proc validate_TasksUpdateSubscriptionLevelTaskState_568380(path: JsonNode;
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
  var valid_568382 = path.getOrDefault("ascLocation")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "ascLocation", valid_568382
  var valid_568383 = path.getOrDefault("subscriptionId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "subscriptionId", valid_568383
  var valid_568384 = path.getOrDefault("taskName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "taskName", valid_568384
  var valid_568385 = path.getOrDefault("taskUpdateActionType")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = newJString("Activate"))
  if valid_568385 != nil:
    section.add "taskUpdateActionType", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568387: Call_TasksUpdateSubscriptionLevelTaskState_568379;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568387.validator(path, query, header, formData, body)
  let scheme = call_568387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568387.url(scheme.get, call_568387.host, call_568387.base,
                         call_568387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568387, url, valid)

proc call*(call_568388: Call_TasksUpdateSubscriptionLevelTaskState_568379;
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
  var path_568389 = newJObject()
  var query_568390 = newJObject()
  add(query_568390, "api-version", newJString(apiVersion))
  add(path_568389, "ascLocation", newJString(ascLocation))
  add(path_568389, "subscriptionId", newJString(subscriptionId))
  add(path_568389, "taskName", newJString(taskName))
  add(path_568389, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_568388.call(path_568389, query_568390, nil, nil, nil)

var tasksUpdateSubscriptionLevelTaskState* = Call_TasksUpdateSubscriptionLevelTaskState_568379(
    name: "tasksUpdateSubscriptionLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateSubscriptionLevelTaskState_568380, base: "",
    url: url_TasksUpdateSubscriptionLevelTaskState_568381, schemes: {Scheme.Https})
type
  Call_TopologyListByHomeRegion_568391 = ref object of OpenApiRestCall_567668
proc url_TopologyListByHomeRegion_568393(protocol: Scheme; host: string;
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

proc validate_TopologyListByHomeRegion_568392(path: JsonNode; query: JsonNode;
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
  var valid_568394 = path.getOrDefault("ascLocation")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "ascLocation", valid_568394
  var valid_568395 = path.getOrDefault("subscriptionId")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "subscriptionId", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_TopologyListByHomeRegion_568391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list that allows to build a topology view of a subscription and location.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_TopologyListByHomeRegion_568391; ascLocation: string;
          subscriptionId: string; apiVersion: string = "2015-06-01-preview"): Recallable =
  ## topologyListByHomeRegion
  ## Gets a list that allows to build a topology view of a subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "ascLocation", newJString(ascLocation))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var topologyListByHomeRegion* = Call_TopologyListByHomeRegion_568391(
    name: "topologyListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/topologies",
    validator: validate_TopologyListByHomeRegion_568392, base: "",
    url: url_TopologyListByHomeRegion_568393, schemes: {Scheme.Https})
type
  Call_TasksList_568401 = ref object of OpenApiRestCall_567668
proc url_TasksList_568403(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TasksList_568402(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  var valid_568406 = query.getOrDefault("$filter")
  valid_568406 = validateParameter(valid_568406, JString, required = false,
                                 default = nil)
  if valid_568406 != nil:
    section.add "$filter", valid_568406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_TasksList_568401; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_TasksList_568401; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"; Filter: string = ""): Recallable =
  ## tasksList
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(query_568410, "$filter", newJString(Filter))
  result = call_568408.call(path_568409, query_568410, nil, nil, nil)

var tasksList* = Call_TasksList_568401(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/tasks",
                                    validator: validate_TasksList_568402,
                                    base: "", url: url_TasksList_568403,
                                    schemes: {Scheme.Https})
type
  Call_TopologyList_568411 = ref object of OpenApiRestCall_567668
proc url_TopologyList_568413(protocol: Scheme; host: string; base: string;
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

proc validate_TopologyList_568412(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_TopologyList_568411; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list that allows to build a topology view of a subscription.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_TopologyList_568411; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## topologyList
  ## Gets a list that allows to build a topology view of a subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var topologyList* = Call_TopologyList_568411(name: "topologyList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/topologies",
    validator: validate_TopologyList_568412, base: "", url: url_TopologyList_568413,
    schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroup_568420 = ref object of OpenApiRestCall_567668
proc url_AlertsListByResourceGroup_568422(protocol: Scheme; host: string;
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

proc validate_AlertsListByResourceGroup_568421(path: JsonNode; query: JsonNode;
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
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
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
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  var valid_568426 = query.getOrDefault("$expand")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "$expand", valid_568426
  var valid_568427 = query.getOrDefault("$select")
  valid_568427 = validateParameter(valid_568427, JString, required = false,
                                 default = nil)
  if valid_568427 != nil:
    section.add "$select", valid_568427
  var valid_568428 = query.getOrDefault("$filter")
  valid_568428 = validateParameter(valid_568428, JString, required = false,
                                 default = nil)
  if valid_568428 != nil:
    section.add "$filter", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_AlertsListByResourceGroup_568420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_AlertsListByResourceGroup_568420;
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
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(query_568432, "$expand", newJString(Expand))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(query_568432, "$select", newJString(Select))
  add(query_568432, "$filter", newJString(Filter))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var alertsListByResourceGroup* = Call_AlertsListByResourceGroup_568420(
    name: "alertsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/alerts",
    validator: validate_AlertsListByResourceGroup_568421, base: "",
    url: url_AlertsListByResourceGroup_568422, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByResourceGroup_568433 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesListByResourceGroup_568435(protocol: Scheme;
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

proc validate_JitNetworkAccessPoliciesListByResourceGroup_568434(path: JsonNode;
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
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568438 != nil:
    section.add "api-version", valid_568438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_JitNetworkAccessPoliciesListByResourceGroup_568433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_JitNetworkAccessPoliciesListByResourceGroup_568433;
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
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var jitNetworkAccessPoliciesListByResourceGroup* = Call_JitNetworkAccessPoliciesListByResourceGroup_568433(
    name: "jitNetworkAccessPoliciesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByResourceGroup_568434,
    base: "", url: url_JitNetworkAccessPoliciesListByResourceGroup_568435,
    schemes: {Scheme.Https})
type
  Call_ExternalSecuritySolutionsGet_568443 = ref object of OpenApiRestCall_567668
proc url_ExternalSecuritySolutionsGet_568445(protocol: Scheme; host: string;
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

proc validate_ExternalSecuritySolutionsGet_568444(path: JsonNode; query: JsonNode;
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
  var valid_568446 = path.getOrDefault("externalSecuritySolutionsName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "externalSecuritySolutionsName", valid_568446
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("ascLocation")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "ascLocation", valid_568448
  var valid_568449 = path.getOrDefault("subscriptionId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "subscriptionId", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ExternalSecuritySolutionsGet_568443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific external Security Solution.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_ExternalSecuritySolutionsGet_568443;
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
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "externalSecuritySolutionsName",
      newJString(externalSecuritySolutionsName))
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "ascLocation", newJString(ascLocation))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var externalSecuritySolutionsGet* = Call_ExternalSecuritySolutionsGet_568443(
    name: "externalSecuritySolutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/ExternalSecuritySolutions/{externalSecuritySolutionsName}",
    validator: validate_ExternalSecuritySolutionsGet_568444, base: "",
    url: url_ExternalSecuritySolutionsGet_568445, schemes: {Scheme.Https})
type
  Call_AlertsListResourceGroupLevelAlertsByRegion_568455 = ref object of OpenApiRestCall_567668
proc url_AlertsListResourceGroupLevelAlertsByRegion_568457(protocol: Scheme;
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

proc validate_AlertsListResourceGroupLevelAlertsByRegion_568456(path: JsonNode;
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
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("ascLocation")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "ascLocation", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
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
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  var valid_568462 = query.getOrDefault("$expand")
  valid_568462 = validateParameter(valid_568462, JString, required = false,
                                 default = nil)
  if valid_568462 != nil:
    section.add "$expand", valid_568462
  var valid_568463 = query.getOrDefault("$select")
  valid_568463 = validateParameter(valid_568463, JString, required = false,
                                 default = nil)
  if valid_568463 != nil:
    section.add "$select", valid_568463
  var valid_568464 = query.getOrDefault("$filter")
  valid_568464 = validateParameter(valid_568464, JString, required = false,
                                 default = nil)
  if valid_568464 != nil:
    section.add "$filter", valid_568464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568465: Call_AlertsListResourceGroupLevelAlertsByRegion_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_AlertsListResourceGroupLevelAlertsByRegion_568455;
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
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  add(path_568467, "resourceGroupName", newJString(resourceGroupName))
  add(query_568468, "api-version", newJString(apiVersion))
  add(query_568468, "$expand", newJString(Expand))
  add(path_568467, "ascLocation", newJString(ascLocation))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  add(query_568468, "$select", newJString(Select))
  add(query_568468, "$filter", newJString(Filter))
  result = call_568466.call(path_568467, query_568468, nil, nil, nil)

var alertsListResourceGroupLevelAlertsByRegion* = Call_AlertsListResourceGroupLevelAlertsByRegion_568455(
    name: "alertsListResourceGroupLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListResourceGroupLevelAlertsByRegion_568456,
    base: "", url: url_AlertsListResourceGroupLevelAlertsByRegion_568457,
    schemes: {Scheme.Https})
type
  Call_AlertsGetResourceGroupLevelAlerts_568469 = ref object of OpenApiRestCall_567668
proc url_AlertsGetResourceGroupLevelAlerts_568471(protocol: Scheme; host: string;
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

proc validate_AlertsGetResourceGroupLevelAlerts_568470(path: JsonNode;
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
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("ascLocation")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "ascLocation", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("alertName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "alertName", valid_568475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568476 = query.getOrDefault("api-version")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568476 != nil:
    section.add "api-version", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_AlertsGetResourceGroupLevelAlerts_568469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_AlertsGetResourceGroupLevelAlerts_568469;
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
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "ascLocation", newJString(ascLocation))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(path_568479, "alertName", newJString(alertName))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var alertsGetResourceGroupLevelAlerts* = Call_AlertsGetResourceGroupLevelAlerts_568469(
    name: "alertsGetResourceGroupLevelAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetResourceGroupLevelAlerts_568470, base: "",
    url: url_AlertsGetResourceGroupLevelAlerts_568471, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupLevelAlertState_568481 = ref object of OpenApiRestCall_567668
proc url_AlertsUpdateResourceGroupLevelAlertState_568483(protocol: Scheme;
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

proc validate_AlertsUpdateResourceGroupLevelAlertState_568482(path: JsonNode;
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
  var valid_568484 = path.getOrDefault("resourceGroupName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "resourceGroupName", valid_568484
  var valid_568485 = path.getOrDefault("ascLocation")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "ascLocation", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("alertUpdateActionType")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_568487 != nil:
    section.add "alertUpdateActionType", valid_568487
  var valid_568488 = path.getOrDefault("alertName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "alertName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568490: Call_AlertsUpdateResourceGroupLevelAlertState_568481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_568490.validator(path, query, header, formData, body)
  let scheme = call_568490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568490.url(scheme.get, call_568490.host, call_568490.base,
                         call_568490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568490, url, valid)

proc call*(call_568491: Call_AlertsUpdateResourceGroupLevelAlertState_568481;
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
  var path_568492 = newJObject()
  var query_568493 = newJObject()
  add(path_568492, "resourceGroupName", newJString(resourceGroupName))
  add(query_568493, "api-version", newJString(apiVersion))
  add(path_568492, "ascLocation", newJString(ascLocation))
  add(path_568492, "subscriptionId", newJString(subscriptionId))
  add(path_568492, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_568492, "alertName", newJString(alertName))
  result = call_568491.call(path_568492, query_568493, nil, nil, nil)

var alertsUpdateResourceGroupLevelAlertState* = Call_AlertsUpdateResourceGroupLevelAlertState_568481(
    name: "alertsUpdateResourceGroupLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateResourceGroupLevelAlertState_568482, base: "",
    url: url_AlertsUpdateResourceGroupLevelAlertState_568483,
    schemes: {Scheme.Https})
type
  Call_AllowedConnectionsGet_568494 = ref object of OpenApiRestCall_567668
proc url_AllowedConnectionsGet_568496(protocol: Scheme; host: string; base: string;
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

proc validate_AllowedConnectionsGet_568495(path: JsonNode; query: JsonNode;
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
  var valid_568497 = path.getOrDefault("resourceGroupName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "resourceGroupName", valid_568497
  var valid_568498 = path.getOrDefault("ascLocation")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "ascLocation", valid_568498
  var valid_568499 = path.getOrDefault("subscriptionId")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "subscriptionId", valid_568499
  var valid_568500 = path.getOrDefault("connectionType")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = newJString("Internal"))
  if valid_568500 != nil:
    section.add "connectionType", valid_568500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568501 = query.getOrDefault("api-version")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568501 != nil:
    section.add "api-version", valid_568501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_AllowedConnectionsGet_568494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of all possible traffic between resources for the subscription and location, based on connection type.
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_AllowedConnectionsGet_568494;
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
  var path_568504 = newJObject()
  var query_568505 = newJObject()
  add(path_568504, "resourceGroupName", newJString(resourceGroupName))
  add(query_568505, "api-version", newJString(apiVersion))
  add(path_568504, "ascLocation", newJString(ascLocation))
  add(path_568504, "subscriptionId", newJString(subscriptionId))
  add(path_568504, "connectionType", newJString(connectionType))
  result = call_568503.call(path_568504, query_568505, nil, nil, nil)

var allowedConnectionsGet* = Call_AllowedConnectionsGet_568494(
    name: "allowedConnectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/allowedConnections/{connectionType}",
    validator: validate_AllowedConnectionsGet_568495, base: "",
    url: url_AllowedConnectionsGet_568496, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsGet_568506 = ref object of OpenApiRestCall_567668
proc url_DiscoveredSecuritySolutionsGet_568508(protocol: Scheme; host: string;
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

proc validate_DiscoveredSecuritySolutionsGet_568507(path: JsonNode;
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
  var valid_568509 = path.getOrDefault("resourceGroupName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "resourceGroupName", valid_568509
  var valid_568510 = path.getOrDefault("ascLocation")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "ascLocation", valid_568510
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  var valid_568512 = path.getOrDefault("discoveredSecuritySolutionName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "discoveredSecuritySolutionName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_DiscoveredSecuritySolutionsGet_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific discovered Security Solution.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_DiscoveredSecuritySolutionsGet_568506;
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
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "ascLocation", newJString(ascLocation))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "discoveredSecuritySolutionName",
      newJString(discoveredSecuritySolutionName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var discoveredSecuritySolutionsGet* = Call_DiscoveredSecuritySolutionsGet_568506(
    name: "discoveredSecuritySolutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions/{discoveredSecuritySolutionName}",
    validator: validate_DiscoveredSecuritySolutionsGet_568507, base: "",
    url: url_DiscoveredSecuritySolutionsGet_568508, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568518 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568520(
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

proc validate_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568519(
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
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("ascLocation")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "ascLocation", valid_568522
  var valid_568523 = path.getOrDefault("subscriptionId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "subscriptionId", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568518;
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
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "ascLocation", newJString(ascLocation))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var jitNetworkAccessPoliciesListByResourceGroupAndRegion* = Call_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568518(
    name: "jitNetworkAccessPoliciesListByResourceGroupAndRegion",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies",
    validator: validate_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568519,
    base: "", url: url_JitNetworkAccessPoliciesListByResourceGroupAndRegion_568520,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesCreateOrUpdate_568541 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesCreateOrUpdate_568543(protocol: Scheme;
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

proc validate_JitNetworkAccessPoliciesCreateOrUpdate_568542(path: JsonNode;
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
  var valid_568544 = path.getOrDefault("resourceGroupName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "resourceGroupName", valid_568544
  var valid_568545 = path.getOrDefault("ascLocation")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "ascLocation", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "jitNetworkAccessPolicyName", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568548 != nil:
    section.add "api-version", valid_568548
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

proc call*(call_568550: Call_JitNetworkAccessPoliciesCreateOrUpdate_568541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a policy for protecting resources using Just-in-Time access control
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_JitNetworkAccessPoliciesCreateOrUpdate_568541;
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
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  var body_568554 = newJObject()
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "ascLocation", newJString(ascLocation))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  add(path_568552, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  if body != nil:
    body_568554 = body
  result = call_568551.call(path_568552, query_568553, nil, nil, body_568554)

var jitNetworkAccessPoliciesCreateOrUpdate* = Call_JitNetworkAccessPoliciesCreateOrUpdate_568541(
    name: "jitNetworkAccessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesCreateOrUpdate_568542, base: "",
    url: url_JitNetworkAccessPoliciesCreateOrUpdate_568543,
    schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesGet_568529 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesGet_568531(protocol: Scheme; host: string;
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

proc validate_JitNetworkAccessPoliciesGet_568530(path: JsonNode; query: JsonNode;
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
  var valid_568532 = path.getOrDefault("resourceGroupName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceGroupName", valid_568532
  var valid_568533 = path.getOrDefault("ascLocation")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "ascLocation", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "jitNetworkAccessPolicyName", valid_568535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568536 = query.getOrDefault("api-version")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568536 != nil:
    section.add "api-version", valid_568536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_JitNetworkAccessPoliciesGet_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Policies for protecting resources using Just-in-Time access control for the subscription, location
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_JitNetworkAccessPoliciesGet_568529;
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
  var path_568539 = newJObject()
  var query_568540 = newJObject()
  add(path_568539, "resourceGroupName", newJString(resourceGroupName))
  add(query_568540, "api-version", newJString(apiVersion))
  add(path_568539, "ascLocation", newJString(ascLocation))
  add(path_568539, "subscriptionId", newJString(subscriptionId))
  add(path_568539, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  result = call_568538.call(path_568539, query_568540, nil, nil, nil)

var jitNetworkAccessPoliciesGet* = Call_JitNetworkAccessPoliciesGet_568529(
    name: "jitNetworkAccessPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesGet_568530, base: "",
    url: url_JitNetworkAccessPoliciesGet_568531, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesDelete_568555 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesDelete_568557(protocol: Scheme; host: string;
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

proc validate_JitNetworkAccessPoliciesDelete_568556(path: JsonNode;
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
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("ascLocation")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "ascLocation", valid_568559
  var valid_568560 = path.getOrDefault("subscriptionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "subscriptionId", valid_568560
  var valid_568561 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "jitNetworkAccessPolicyName", valid_568561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568562 != nil:
    section.add "api-version", valid_568562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_JitNetworkAccessPoliciesDelete_568555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Just-in-Time access control policy.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_JitNetworkAccessPoliciesDelete_568555;
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
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "ascLocation", newJString(ascLocation))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  add(path_568565, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  result = call_568564.call(path_568565, query_568566, nil, nil, nil)

var jitNetworkAccessPoliciesDelete* = Call_JitNetworkAccessPoliciesDelete_568555(
    name: "jitNetworkAccessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}",
    validator: validate_JitNetworkAccessPoliciesDelete_568556, base: "",
    url: url_JitNetworkAccessPoliciesDelete_568557, schemes: {Scheme.Https})
type
  Call_JitNetworkAccessPoliciesInitiate_568567 = ref object of OpenApiRestCall_567668
proc url_JitNetworkAccessPoliciesInitiate_568569(protocol: Scheme; host: string;
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

proc validate_JitNetworkAccessPoliciesInitiate_568568(path: JsonNode;
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
  var valid_568570 = path.getOrDefault("jitNetworkAccessPolicyInitiateType")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = newJString("initiate"))
  if valid_568570 != nil:
    section.add "jitNetworkAccessPolicyInitiateType", valid_568570
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("ascLocation")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "ascLocation", valid_568572
  var valid_568573 = path.getOrDefault("subscriptionId")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "subscriptionId", valid_568573
  var valid_568574 = path.getOrDefault("jitNetworkAccessPolicyName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "jitNetworkAccessPolicyName", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568575 != nil:
    section.add "api-version", valid_568575
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

proc call*(call_568577: Call_JitNetworkAccessPoliciesInitiate_568567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiate a JIT access from a specific Just-in-Time policy configuration.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_JitNetworkAccessPoliciesInitiate_568567;
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
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  var body_568581 = newJObject()
  add(path_568579, "jitNetworkAccessPolicyInitiateType",
      newJString(jitNetworkAccessPolicyInitiateType))
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "ascLocation", newJString(ascLocation))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  add(path_568579, "jitNetworkAccessPolicyName",
      newJString(jitNetworkAccessPolicyName))
  if body != nil:
    body_568581 = body
  result = call_568578.call(path_568579, query_568580, nil, nil, body_568581)

var jitNetworkAccessPoliciesInitiate* = Call_JitNetworkAccessPoliciesInitiate_568567(
    name: "jitNetworkAccessPoliciesInitiate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/jitNetworkAccessPolicies/{jitNetworkAccessPolicyName}/{jitNetworkAccessPolicyInitiateType}",
    validator: validate_JitNetworkAccessPoliciesInitiate_568568, base: "",
    url: url_JitNetworkAccessPoliciesInitiate_568569, schemes: {Scheme.Https})
type
  Call_TasksListByResourceGroup_568582 = ref object of OpenApiRestCall_567668
proc url_TasksListByResourceGroup_568584(protocol: Scheme; host: string;
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

proc validate_TasksListByResourceGroup_568583(path: JsonNode; query: JsonNode;
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
  var valid_568585 = path.getOrDefault("resourceGroupName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "resourceGroupName", valid_568585
  var valid_568586 = path.getOrDefault("ascLocation")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "ascLocation", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568588 != nil:
    section.add "api-version", valid_568588
  var valid_568589 = query.getOrDefault("$filter")
  valid_568589 = validateParameter(valid_568589, JString, required = false,
                                 default = nil)
  if valid_568589 != nil:
    section.add "$filter", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_TasksListByResourceGroup_568582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_TasksListByResourceGroup_568582;
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
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "ascLocation", newJString(ascLocation))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  add(query_568593, "$filter", newJString(Filter))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var tasksListByResourceGroup* = Call_TasksListByResourceGroup_568582(
    name: "tasksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByResourceGroup_568583, base: "",
    url: url_TasksListByResourceGroup_568584, schemes: {Scheme.Https})
type
  Call_TasksGetResourceGroupLevelTask_568594 = ref object of OpenApiRestCall_567668
proc url_TasksGetResourceGroupLevelTask_568596(protocol: Scheme; host: string;
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

proc validate_TasksGetResourceGroupLevelTask_568595(path: JsonNode;
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
  var valid_568597 = path.getOrDefault("resourceGroupName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "resourceGroupName", valid_568597
  var valid_568598 = path.getOrDefault("ascLocation")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "ascLocation", valid_568598
  var valid_568599 = path.getOrDefault("subscriptionId")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "subscriptionId", valid_568599
  var valid_568600 = path.getOrDefault("taskName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "taskName", valid_568600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568601 = query.getOrDefault("api-version")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568601 != nil:
    section.add "api-version", valid_568601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568602: Call_TasksGetResourceGroupLevelTask_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568602.validator(path, query, header, formData, body)
  let scheme = call_568602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568602.url(scheme.get, call_568602.host, call_568602.base,
                         call_568602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568602, url, valid)

proc call*(call_568603: Call_TasksGetResourceGroupLevelTask_568594;
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
  var path_568604 = newJObject()
  var query_568605 = newJObject()
  add(path_568604, "resourceGroupName", newJString(resourceGroupName))
  add(query_568605, "api-version", newJString(apiVersion))
  add(path_568604, "ascLocation", newJString(ascLocation))
  add(path_568604, "subscriptionId", newJString(subscriptionId))
  add(path_568604, "taskName", newJString(taskName))
  result = call_568603.call(path_568604, query_568605, nil, nil, nil)

var tasksGetResourceGroupLevelTask* = Call_TasksGetResourceGroupLevelTask_568594(
    name: "tasksGetResourceGroupLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetResourceGroupLevelTask_568595, base: "",
    url: url_TasksGetResourceGroupLevelTask_568596, schemes: {Scheme.Https})
type
  Call_TasksUpdateResourceGroupLevelTaskState_568606 = ref object of OpenApiRestCall_567668
proc url_TasksUpdateResourceGroupLevelTaskState_568608(protocol: Scheme;
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

proc validate_TasksUpdateResourceGroupLevelTaskState_568607(path: JsonNode;
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
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("ascLocation")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "ascLocation", valid_568610
  var valid_568611 = path.getOrDefault("subscriptionId")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "subscriptionId", valid_568611
  var valid_568612 = path.getOrDefault("taskName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "taskName", valid_568612
  var valid_568613 = path.getOrDefault("taskUpdateActionType")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = newJString("Activate"))
  if valid_568613 != nil:
    section.add "taskUpdateActionType", valid_568613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568614 = query.getOrDefault("api-version")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568614 != nil:
    section.add "api-version", valid_568614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_TasksUpdateResourceGroupLevelTaskState_568606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_TasksUpdateResourceGroupLevelTaskState_568606;
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
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "ascLocation", newJString(ascLocation))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  add(path_568617, "taskName", newJString(taskName))
  add(path_568617, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_568616.call(path_568617, query_568618, nil, nil, nil)

var tasksUpdateResourceGroupLevelTaskState* = Call_TasksUpdateResourceGroupLevelTaskState_568606(
    name: "tasksUpdateResourceGroupLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateResourceGroupLevelTaskState_568607, base: "",
    url: url_TasksUpdateResourceGroupLevelTaskState_568608,
    schemes: {Scheme.Https})
type
  Call_TopologyGet_568619 = ref object of OpenApiRestCall_567668
proc url_TopologyGet_568621(protocol: Scheme; host: string; base: string;
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

proc validate_TopologyGet_568620(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568622 = path.getOrDefault("resourceGroupName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "resourceGroupName", valid_568622
  var valid_568623 = path.getOrDefault("ascLocation")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "ascLocation", valid_568623
  var valid_568624 = path.getOrDefault("subscriptionId")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "subscriptionId", valid_568624
  var valid_568625 = path.getOrDefault("topologyResourceName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "topologyResourceName", valid_568625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568626 = query.getOrDefault("api-version")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_568626 != nil:
    section.add "api-version", valid_568626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568627: Call_TopologyGet_568619; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific topology component.
  ## 
  let valid = call_568627.validator(path, query, header, formData, body)
  let scheme = call_568627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568627.url(scheme.get, call_568627.host, call_568627.base,
                         call_568627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568627, url, valid)

proc call*(call_568628: Call_TopologyGet_568619; resourceGroupName: string;
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
  var path_568629 = newJObject()
  var query_568630 = newJObject()
  add(path_568629, "resourceGroupName", newJString(resourceGroupName))
  add(query_568630, "api-version", newJString(apiVersion))
  add(path_568629, "ascLocation", newJString(ascLocation))
  add(path_568629, "subscriptionId", newJString(subscriptionId))
  add(path_568629, "topologyResourceName", newJString(topologyResourceName))
  result = call_568628.call(path_568629, query_568630, nil, nil, nil)

var topologyGet* = Call_TopologyGet_568619(name: "topologyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/topologies/{topologyResourceName}",
                                        validator: validate_TopologyGet_568620,
                                        base: "", url: url_TopologyGet_568621,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
