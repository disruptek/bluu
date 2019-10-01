
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "network-applicationSecurityGroup"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApplicationSecurityGroupsListAll_567863 = ref object of OpenApiRestCall_567641
proc url_ApplicationSecurityGroupsListAll_567865(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network/applicationSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationSecurityGroupsListAll_567864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all application security groups in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568038 = path.getOrDefault("subscriptionId")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "subscriptionId", valid_568038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568039 = query.getOrDefault("api-version")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "api-version", valid_568039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568062: Call_ApplicationSecurityGroupsListAll_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all application security groups in a subscription.
  ## 
  let valid = call_568062.validator(path, query, header, formData, body)
  let scheme = call_568062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568062.url(scheme.get, call_568062.host, call_568062.base,
                         call_568062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568062, url, valid)

proc call*(call_568133: Call_ApplicationSecurityGroupsListAll_567863;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationSecurityGroupsListAll
  ## Gets all application security groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568134 = newJObject()
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  add(path_568134, "subscriptionId", newJString(subscriptionId))
  result = call_568133.call(path_568134, query_568136, nil, nil, nil)

var applicationSecurityGroupsListAll* = Call_ApplicationSecurityGroupsListAll_567863(
    name: "applicationSecurityGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/applicationSecurityGroups",
    validator: validate_ApplicationSecurityGroupsListAll_567864, base: "",
    url: url_ApplicationSecurityGroupsListAll_567865, schemes: {Scheme.Https})
type
  Call_ApplicationSecurityGroupsList_568175 = ref object of OpenApiRestCall_567641
proc url_ApplicationSecurityGroupsList_568177(protocol: Scheme; host: string;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationSecurityGroupsList_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the application security groups in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568178 = path.getOrDefault("resourceGroupName")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "resourceGroupName", valid_568178
  var valid_568179 = path.getOrDefault("subscriptionId")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "subscriptionId", valid_568179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_ApplicationSecurityGroupsList_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the application security groups in a resource group.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_ApplicationSecurityGroupsList_568175;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationSecurityGroupsList
  ## Gets all the application security groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(path_568183, "resourceGroupName", newJString(resourceGroupName))
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var applicationSecurityGroupsList* = Call_ApplicationSecurityGroupsList_568175(
    name: "applicationSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups",
    validator: validate_ApplicationSecurityGroupsList_568176, base: "",
    url: url_ApplicationSecurityGroupsList_568177, schemes: {Scheme.Https})
type
  Call_ApplicationSecurityGroupsCreateOrUpdate_568196 = ref object of OpenApiRestCall_567641
proc url_ApplicationSecurityGroupsCreateOrUpdate_568198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationSecurityGroupName" in path,
        "`applicationSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationSecurityGroups/"),
               (kind: VariableSegment, value: "applicationSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationSecurityGroupsCreateOrUpdate_568197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an application security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: JString (required)
  ##                               : The name of the application security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  var valid_568218 = path.getOrDefault("applicationSecurityGroupName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "applicationSecurityGroupName", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update ApplicationSecurityGroup operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_ApplicationSecurityGroupsCreateOrUpdate_568196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an application security group.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_ApplicationSecurityGroupsCreateOrUpdate_568196;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationSecurityGroupName: string; parameters: JsonNode): Recallable =
  ## applicationSecurityGroupsCreateOrUpdate
  ## Creates or updates an application security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: string (required)
  ##                               : The name of the application security group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update ApplicationSecurityGroup operation.
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  var body_568225 = newJObject()
  add(path_568223, "resourceGroupName", newJString(resourceGroupName))
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(path_568223, "applicationSecurityGroupName",
      newJString(applicationSecurityGroupName))
  if parameters != nil:
    body_568225 = parameters
  result = call_568222.call(path_568223, query_568224, nil, nil, body_568225)

var applicationSecurityGroupsCreateOrUpdate* = Call_ApplicationSecurityGroupsCreateOrUpdate_568196(
    name: "applicationSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{applicationSecurityGroupName}",
    validator: validate_ApplicationSecurityGroupsCreateOrUpdate_568197, base: "",
    url: url_ApplicationSecurityGroupsCreateOrUpdate_568198,
    schemes: {Scheme.Https})
type
  Call_ApplicationSecurityGroupsGet_568185 = ref object of OpenApiRestCall_567641
proc url_ApplicationSecurityGroupsGet_568187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationSecurityGroupName" in path,
        "`applicationSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationSecurityGroups/"),
               (kind: VariableSegment, value: "applicationSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationSecurityGroupsGet_568186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified application security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: JString (required)
  ##                               : The name of the application security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  var valid_568190 = path.getOrDefault("applicationSecurityGroupName")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "applicationSecurityGroupName", valid_568190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568191 = query.getOrDefault("api-version")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "api-version", valid_568191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568192: Call_ApplicationSecurityGroupsGet_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified application security group.
  ## 
  let valid = call_568192.validator(path, query, header, formData, body)
  let scheme = call_568192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568192.url(scheme.get, call_568192.host, call_568192.base,
                         call_568192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568192, url, valid)

proc call*(call_568193: Call_ApplicationSecurityGroupsGet_568185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationSecurityGroupName: string): Recallable =
  ## applicationSecurityGroupsGet
  ## Gets information about the specified application security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: string (required)
  ##                               : The name of the application security group.
  var path_568194 = newJObject()
  var query_568195 = newJObject()
  add(path_568194, "resourceGroupName", newJString(resourceGroupName))
  add(query_568195, "api-version", newJString(apiVersion))
  add(path_568194, "subscriptionId", newJString(subscriptionId))
  add(path_568194, "applicationSecurityGroupName",
      newJString(applicationSecurityGroupName))
  result = call_568193.call(path_568194, query_568195, nil, nil, nil)

var applicationSecurityGroupsGet* = Call_ApplicationSecurityGroupsGet_568185(
    name: "applicationSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{applicationSecurityGroupName}",
    validator: validate_ApplicationSecurityGroupsGet_568186, base: "",
    url: url_ApplicationSecurityGroupsGet_568187, schemes: {Scheme.Https})
type
  Call_ApplicationSecurityGroupsDelete_568226 = ref object of OpenApiRestCall_567641
proc url_ApplicationSecurityGroupsDelete_568228(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationSecurityGroupName" in path,
        "`applicationSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/applicationSecurityGroups/"),
               (kind: VariableSegment, value: "applicationSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationSecurityGroupsDelete_568227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified application security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: JString (required)
  ##                               : The name of the application security group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  var valid_568231 = path.getOrDefault("applicationSecurityGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "applicationSecurityGroupName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_ApplicationSecurityGroupsDelete_568226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified application security group.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_ApplicationSecurityGroupsDelete_568226;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationSecurityGroupName: string): Recallable =
  ## applicationSecurityGroupsDelete
  ## Deletes the specified application security group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applicationSecurityGroupName: string (required)
  ##                               : The name of the application security group.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "applicationSecurityGroupName",
      newJString(applicationSecurityGroupName))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var applicationSecurityGroupsDelete* = Call_ApplicationSecurityGroupsDelete_568226(
    name: "applicationSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{applicationSecurityGroupName}",
    validator: validate_ApplicationSecurityGroupsDelete_568227, base: "",
    url: url_ApplicationSecurityGroupsDelete_568228, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
