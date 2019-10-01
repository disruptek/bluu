
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
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
  macServiceName = "security-iotSecuritySolutions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IoTSecuritySolutionsList_567879 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsList_567881(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_IoTSecuritySolutionsList_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of security solutions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : filter the Security Solution with OData syntax. supporting filter by iotHubs
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("$filter")
  valid_568057 = validateParameter(valid_568057, JString, required = false,
                                 default = nil)
  if valid_568057 != nil:
    section.add "$filter", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_IoTSecuritySolutionsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of security solutions
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_IoTSecuritySolutionsList_567879; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## ioTSecuritySolutionsList
  ## List of security solutions
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : filter the Security Solution with OData syntax. supporting filter by iotHubs
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "$filter", newJString(Filter))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var ioTSecuritySolutionsList* = Call_IoTSecuritySolutionsList_567879(
    name: "ioTSecuritySolutionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/iotSecuritySolutions",
    validator: validate_IoTSecuritySolutionsList_567880, base: "",
    url: url_IoTSecuritySolutionsList_567881, schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsResourceGroupList_568193 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsResourceGroupList_568195(protocol: Scheme;
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

proc validate_IoTSecuritySolutionsResourceGroupList_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of security solutions
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
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : filter the Security Solution with OData syntax. supporting filter by iotHubs
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("$filter")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$filter", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_IoTSecuritySolutionsResourceGroupList_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of security solutions
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_IoTSecuritySolutionsResourceGroupList_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## ioTSecuritySolutionsResourceGroupList
  ## List of security solutions
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : filter the Security Solution with OData syntax. supporting filter by iotHubs
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "$filter", newJString(Filter))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var ioTSecuritySolutionsResourceGroupList* = Call_IoTSecuritySolutionsResourceGroupList_568193(
    name: "ioTSecuritySolutionsResourceGroupList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions",
    validator: validate_IoTSecuritySolutionsResourceGroupList_568194, base: "",
    url: url_IoTSecuritySolutionsResourceGroupList_568195, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionCreate_568215 = ref object of OpenApiRestCall_567657
proc url_IotSecuritySolutionCreate_568217(protocol: Scheme; host: string;
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

proc validate_IotSecuritySolutionCreate_568216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create new solution manager
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568218 = path.getOrDefault("solutionName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "solutionName", valid_568218
  var valid_568219 = path.getOrDefault("resourceGroupName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "resourceGroupName", valid_568219
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
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

proc call*(call_568223: Call_IotSecuritySolutionCreate_568215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create new solution manager
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_IotSecuritySolutionCreate_568215;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; iotSecuritySolutionData: JsonNode): Recallable =
  ## iotSecuritySolutionCreate
  ## Create new solution manager
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   iotSecuritySolutionData: JObject (required)
  ##                          : The security solution data
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(path_568225, "solutionName", newJString(solutionName))
  add(path_568225, "resourceGroupName", newJString(resourceGroupName))
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if iotSecuritySolutionData != nil:
    body_568227 = iotSecuritySolutionData
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var iotSecuritySolutionCreate* = Call_IotSecuritySolutionCreate_568215(
    name: "iotSecuritySolutionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionCreate_568216, base: "",
    url: url_IotSecuritySolutionCreate_568217, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionGet_568204 = ref object of OpenApiRestCall_567657
proc url_IotSecuritySolutionGet_568206(protocol: Scheme; host: string; base: string;
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

proc validate_IotSecuritySolutionGet_568205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific iot security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568207 = path.getOrDefault("solutionName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "solutionName", valid_568207
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_IotSecuritySolutionGet_568204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific iot security solution
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_IotSecuritySolutionGet_568204; solutionName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## iotSecuritySolutionGet
  ## Details of a specific iot security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  add(path_568213, "solutionName", newJString(solutionName))
  add(path_568213, "resourceGroupName", newJString(resourceGroupName))
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  result = call_568212.call(path_568213, query_568214, nil, nil, nil)

var iotSecuritySolutionGet* = Call_IotSecuritySolutionGet_568204(
    name: "iotSecuritySolutionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionGet_568205, base: "",
    url: url_IotSecuritySolutionGet_568206, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionUpdate_568239 = ref object of OpenApiRestCall_567657
proc url_IotSecuritySolutionUpdate_568241(protocol: Scheme; host: string;
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

proc validate_IotSecuritySolutionUpdate_568240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## update existing Security Solution tags or user defined resources. To update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568242 = path.getOrDefault("solutionName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "solutionName", valid_568242
  var valid_568243 = path.getOrDefault("resourceGroupName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceGroupName", valid_568243
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
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

proc call*(call_568247: Call_IotSecuritySolutionUpdate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update existing Security Solution tags or user defined resources. To update other fields use the CreateOrUpdate method
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_IotSecuritySolutionUpdate_568239;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; updateIotSecuritySolutionData: JsonNode): Recallable =
  ## iotSecuritySolutionUpdate
  ## update existing Security Solution tags or user defined resources. To update other fields use the CreateOrUpdate method
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   updateIotSecuritySolutionData: JObject (required)
  ##                                : The security solution data
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "solutionName", newJString(solutionName))
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  if updateIotSecuritySolutionData != nil:
    body_568251 = updateIotSecuritySolutionData
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var iotSecuritySolutionUpdate* = Call_IotSecuritySolutionUpdate_568239(
    name: "iotSecuritySolutionUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionUpdate_568240, base: "",
    url: url_IotSecuritySolutionUpdate_568241, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionDelete_568228 = ref object of OpenApiRestCall_567657
proc url_IotSecuritySolutionDelete_568230(protocol: Scheme; host: string;
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

proc validate_IotSecuritySolutionDelete_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create new solution manager
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568231 = path.getOrDefault("solutionName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "solutionName", valid_568231
  var valid_568232 = path.getOrDefault("resourceGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_IotSecuritySolutionDelete_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create new solution manager
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_IotSecuritySolutionDelete_568228;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## iotSecuritySolutionDelete
  ## Create new solution manager
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "solutionName", newJString(solutionName))
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var iotSecuritySolutionDelete* = Call_IotSecuritySolutionDelete_568228(
    name: "iotSecuritySolutionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}",
    validator: validate_IotSecuritySolutionDelete_568229, base: "",
    url: url_IotSecuritySolutionDelete_568230, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
