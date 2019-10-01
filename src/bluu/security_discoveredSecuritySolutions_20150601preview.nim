
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "security-discoveredSecuritySolutions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiscoveredSecuritySolutionsList_567879 = ref object of OpenApiRestCall_567657
proc url_DiscoveredSecuritySolutionsList_567881(protocol: Scheme; host: string;
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

proc validate_DiscoveredSecuritySolutionsList_567880(path: JsonNode;
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
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_DiscoveredSecuritySolutionsList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription.
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_DiscoveredSecuritySolutionsList_567879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## discoveredSecuritySolutionsList
  ## Gets a list of discovered Security Solutions for the subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568141 = newJObject()
  var query_568143 = newJObject()
  add(query_568143, "api-version", newJString(apiVersion))
  add(path_568141, "subscriptionId", newJString(subscriptionId))
  result = call_568140.call(path_568141, query_568143, nil, nil, nil)

var discoveredSecuritySolutionsList* = Call_DiscoveredSecuritySolutionsList_567879(
    name: "discoveredSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsList_567880, base: "",
    url: url_DiscoveredSecuritySolutionsList_567881, schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsListByHomeRegion_568182 = ref object of OpenApiRestCall_567657
proc url_DiscoveredSecuritySolutionsListByHomeRegion_568184(protocol: Scheme;
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

proc validate_DiscoveredSecuritySolutionsListByHomeRegion_568183(path: JsonNode;
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
  var valid_568185 = path.getOrDefault("ascLocation")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "ascLocation", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_DiscoveredSecuritySolutionsListByHomeRegion_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_DiscoveredSecuritySolutionsListByHomeRegion_568182;
          apiVersion: string; ascLocation: string; subscriptionId: string): Recallable =
  ## discoveredSecuritySolutionsListByHomeRegion
  ## Gets a list of discovered Security Solutions for the subscription and location.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "ascLocation", newJString(ascLocation))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var discoveredSecuritySolutionsListByHomeRegion* = Call_DiscoveredSecuritySolutionsListByHomeRegion_568182(
    name: "discoveredSecuritySolutionsListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions",
    validator: validate_DiscoveredSecuritySolutionsListByHomeRegion_568183,
    base: "", url: url_DiscoveredSecuritySolutionsListByHomeRegion_568184,
    schemes: {Scheme.Https})
type
  Call_DiscoveredSecuritySolutionsGet_568192 = ref object of OpenApiRestCall_567657
proc url_DiscoveredSecuritySolutionsGet_568194(protocol: Scheme; host: string;
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

proc validate_DiscoveredSecuritySolutionsGet_568193(path: JsonNode;
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
  var valid_568204 = path.getOrDefault("resourceGroupName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceGroupName", valid_568204
  var valid_568205 = path.getOrDefault("ascLocation")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "ascLocation", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  var valid_568207 = path.getOrDefault("discoveredSecuritySolutionName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "discoveredSecuritySolutionName", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_DiscoveredSecuritySolutionsGet_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific discovered Security Solution.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_DiscoveredSecuritySolutionsGet_568192;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; discoveredSecuritySolutionName: string): Recallable =
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
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(path_568211, "resourceGroupName", newJString(resourceGroupName))
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "ascLocation", newJString(ascLocation))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  add(path_568211, "discoveredSecuritySolutionName",
      newJString(discoveredSecuritySolutionName))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var discoveredSecuritySolutionsGet* = Call_DiscoveredSecuritySolutionsGet_568192(
    name: "discoveredSecuritySolutionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/discoveredSecuritySolutions/{discoveredSecuritySolutionName}",
    validator: validate_DiscoveredSecuritySolutionsGet_568193, base: "",
    url: url_DiscoveredSecuritySolutionsGet_568194, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
