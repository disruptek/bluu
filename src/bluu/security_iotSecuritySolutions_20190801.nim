
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-08-01
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "security-iotSecuritySolutions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IotSecuritySolutionListBySubscription_573879 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionListBySubscription_573881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionListBySubscription_573880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to get the list of IoT Security solutions by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574055 = path.getOrDefault("subscriptionId")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "subscriptionId", valid_574055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : Filter the IoT Security solution with OData syntax. Supports filtering by iotHubs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574056 = query.getOrDefault("api-version")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "api-version", valid_574056
  var valid_574057 = query.getOrDefault("$filter")
  valid_574057 = validateParameter(valid_574057, JString, required = false,
                                 default = nil)
  if valid_574057 != nil:
    section.add "$filter", valid_574057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574080: Call_IotSecuritySolutionListBySubscription_573879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get the list of IoT Security solutions by subscription.
  ## 
  let valid = call_574080.validator(path, query, header, formData, body)
  let scheme = call_574080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574080.url(scheme.get, call_574080.host, call_574080.base,
                         call_574080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574080, url, valid)

proc call*(call_574151: Call_IotSecuritySolutionListBySubscription_573879;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## iotSecuritySolutionListBySubscription
  ## Use this method to get the list of IoT Security solutions by subscription.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : Filter the IoT Security solution with OData syntax. Supports filtering by iotHubs.
  var path_574152 = newJObject()
  var query_574154 = newJObject()
  add(query_574154, "api-version", newJString(apiVersion))
  add(path_574152, "subscriptionId", newJString(subscriptionId))
  add(query_574154, "$filter", newJString(Filter))
  result = call_574151.call(path_574152, query_574154, nil, nil, nil)

var iotSecuritySolutionListBySubscription* = Call_IotSecuritySolutionListBySubscription_573879(
    name: "iotSecuritySolutionListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/iotSecuritySolutions",
    validator: validate_IotSecuritySolutionListBySubscription_573880, base: "",
    url: url_IotSecuritySolutionListBySubscription_573881, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionListByResourceGroup_574193 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionListByResourceGroup_574195(protocol: Scheme;
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
        value: "/providers/Microsoft.Security/iotSecuritySolutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionListByResourceGroup_574194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to get the list IoT Security solutions organized by resource group.
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
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("subscriptionId")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "subscriptionId", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : Filter the IoT Security solution with OData syntax. Supports filtering by iotHubs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  var valid_574199 = query.getOrDefault("$filter")
  valid_574199 = validateParameter(valid_574199, JString, required = false,
                                 default = nil)
  if valid_574199 != nil:
    section.add "$filter", valid_574199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574200: Call_IotSecuritySolutionListByResourceGroup_574193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get the list IoT Security solutions organized by resource group.
  ## 
  let valid = call_574200.validator(path, query, header, formData, body)
  let scheme = call_574200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574200.url(scheme.get, call_574200.host, call_574200.base,
                         call_574200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574200, url, valid)

proc call*(call_574201: Call_IotSecuritySolutionListByResourceGroup_574193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## iotSecuritySolutionListByResourceGroup
  ## Use this method to get the list IoT Security solutions organized by resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : Filter the IoT Security solution with OData syntax. Supports filtering by iotHubs.
  var path_574202 = newJObject()
  var query_574203 = newJObject()
  add(path_574202, "resourceGroupName", newJString(resourceGroupName))
  add(query_574203, "api-version", newJString(apiVersion))
  add(path_574202, "subscriptionId", newJString(subscriptionId))
  add(query_574203, "$filter", newJString(Filter))
  result = call_574201.call(path_574202, query_574203, nil, nil, nil)

var iotSecuritySolutionListByResourceGroup* = Call_IotSecuritySolutionListByResourceGroup_574193(
    name: "iotSecuritySolutionListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions",
    validator: validate_IotSecuritySolutionListByResourceGroup_574194, base: "",
    url: url_IotSecuritySolutionListByResourceGroup_574195,
    schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionCreateOrUpdate_574215 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionCreateOrUpdate_574217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionCreateOrUpdate_574216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to create or update yours IoT Security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574218 = path.getOrDefault("solutionName")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "solutionName", valid_574218
  var valid_574219 = path.getOrDefault("resourceGroupName")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "resourceGroupName", valid_574219
  var valid_574220 = path.getOrDefault("subscriptionId")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "subscriptionId", valid_574220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574221 = query.getOrDefault("api-version")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "api-version", valid_574221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   iotSecuritySolutionData: JObject (required)
  ##                          : The security solution data
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_IotSecuritySolutionCreateOrUpdate_574215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to create or update yours IoT Security solution
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_IotSecuritySolutionCreateOrUpdate_574215;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; iotSecuritySolutionData: JsonNode): Recallable =
  ## iotSecuritySolutionCreateOrUpdate
  ## Use this method to create or update yours IoT Security solution
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   iotSecuritySolutionData: JObject (required)
  ##                          : The security solution data
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  var body_574227 = newJObject()
  add(path_574225, "solutionName", newJString(solutionName))
  add(path_574225, "resourceGroupName", newJString(resourceGroupName))
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  if iotSecuritySolutionData != nil:
    body_574227 = iotSecuritySolutionData
  result = call_574224.call(path_574225, query_574226, nil, nil, body_574227)

var iotSecuritySolutionCreateOrUpdate* = Call_IotSecuritySolutionCreateOrUpdate_574215(
    name: "iotSecuritySolutionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionCreateOrUpdate_574216, base: "",
    url: url_IotSecuritySolutionCreateOrUpdate_574217, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionGet_574204 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionGet_574206(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionGet_574205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## User this method to get details of a specific IoT Security solution based on solution name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574207 = path.getOrDefault("solutionName")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "solutionName", valid_574207
  var valid_574208 = path.getOrDefault("resourceGroupName")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "resourceGroupName", valid_574208
  var valid_574209 = path.getOrDefault("subscriptionId")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "subscriptionId", valid_574209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574210 = query.getOrDefault("api-version")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "api-version", valid_574210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574211: Call_IotSecuritySolutionGet_574204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## User this method to get details of a specific IoT Security solution based on solution name
  ## 
  let valid = call_574211.validator(path, query, header, formData, body)
  let scheme = call_574211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574211.url(scheme.get, call_574211.host, call_574211.base,
                         call_574211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574211, url, valid)

proc call*(call_574212: Call_IotSecuritySolutionGet_574204; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotSecuritySolutionGet
  ## User this method to get details of a specific IoT Security solution based on solution name
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574213 = newJObject()
  var query_574214 = newJObject()
  add(path_574213, "solutionName", newJString(solutionName))
  add(path_574213, "resourceGroupName", newJString(resourceGroupName))
  add(query_574214, "api-version", newJString(apiVersion))
  add(path_574213, "subscriptionId", newJString(subscriptionId))
  result = call_574212.call(path_574213, query_574214, nil, nil, nil)

var iotSecuritySolutionGet* = Call_IotSecuritySolutionGet_574204(
    name: "iotSecuritySolutionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionGet_574205, base: "",
    url: url_IotSecuritySolutionGet_574206, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionUpdate_574239 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionUpdate_574241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionUpdate_574240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to update existing IoT Security solution tags or user defined resources. To update other fields use the CreateOrUpdate method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574242 = path.getOrDefault("solutionName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "solutionName", valid_574242
  var valid_574243 = path.getOrDefault("resourceGroupName")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "resourceGroupName", valid_574243
  var valid_574244 = path.getOrDefault("subscriptionId")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "subscriptionId", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateIotSecuritySolutionData: JObject (required)
  ##                                : The security solution data
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_IotSecuritySolutionUpdate_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Use this method to update existing IoT Security solution tags or user defined resources. To update other fields use the CreateOrUpdate method.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_IotSecuritySolutionUpdate_574239;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; updateIotSecuritySolutionData: JsonNode): Recallable =
  ## iotSecuritySolutionUpdate
  ## Use this method to update existing IoT Security solution tags or user defined resources. To update other fields use the CreateOrUpdate method.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   updateIotSecuritySolutionData: JObject (required)
  ##                                : The security solution data
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(path_574249, "solutionName", newJString(solutionName))
  add(path_574249, "resourceGroupName", newJString(resourceGroupName))
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "subscriptionId", newJString(subscriptionId))
  if updateIotSecuritySolutionData != nil:
    body_574251 = updateIotSecuritySolutionData
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var iotSecuritySolutionUpdate* = Call_IotSecuritySolutionUpdate_574239(
    name: "iotSecuritySolutionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionUpdate_574240, base: "",
    url: url_IotSecuritySolutionUpdate_574241, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionDelete_574228 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionDelete_574230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionDelete_574229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to delete yours IoT Security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574231 = path.getOrDefault("solutionName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "solutionName", valid_574231
  var valid_574232 = path.getOrDefault("resourceGroupName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "resourceGroupName", valid_574232
  var valid_574233 = path.getOrDefault("subscriptionId")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "subscriptionId", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574235: Call_IotSecuritySolutionDelete_574228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Use this method to delete yours IoT Security solution
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_IotSecuritySolutionDelete_574228;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## iotSecuritySolutionDelete
  ## Use this method to delete yours IoT Security solution
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  add(path_574237, "solutionName", newJString(solutionName))
  add(path_574237, "resourceGroupName", newJString(resourceGroupName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  result = call_574236.call(path_574237, query_574238, nil, nil, nil)

var iotSecuritySolutionDelete* = Call_IotSecuritySolutionDelete_574228(
    name: "iotSecuritySolutionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionDelete_574229, base: "",
    url: url_IotSecuritySolutionDelete_574230, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
