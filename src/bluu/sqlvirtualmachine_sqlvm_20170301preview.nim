
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlVirtualMachineManagementClient
## version: 2017-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The SQL virtual machine management API provides a RESTful set of web APIs that interact with Azure Compute, Network & Storage services to manage your SQL Server virtual machine. The API enables users to create, delete and retrieve a SQL virtual machine, SQL virtual machine group or availability group listener.
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
  macServiceName = "sqlvirtualmachine-sqlvm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available SQL Rest API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available SQL Rest API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available SQL Rest API operations.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SqlVirtualMachine/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsList_568175 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsList_568177(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsList_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machine groups in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_SqlVirtualMachineGroupsList_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a subscription.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_SqlVirtualMachineGroupsList_568175;
          apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsList
  ## Gets all SQL virtual machine groups in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var sqlVirtualMachineGroupsList* = Call_SqlVirtualMachineGroupsList_568175(
    name: "sqlVirtualMachineGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsList_568176, base: "",
    url: url_SqlVirtualMachineGroupsList_568177, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesList_568198 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesList_568200(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesList_568199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machines in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_SqlVirtualMachinesList_568198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a subscription.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_SqlVirtualMachinesList_568198; apiVersion: string;
          subscriptionId: string): Recallable =
  ## sqlVirtualMachinesList
  ## Gets all SQL virtual machines in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "subscriptionId", newJString(subscriptionId))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var sqlVirtualMachinesList* = Call_SqlVirtualMachinesList_568198(
    name: "sqlVirtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesList_568199, base: "",
    url: url_SqlVirtualMachinesList_568200, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsListByResourceGroup_568207 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsListByResourceGroup_568209(protocol: Scheme;
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
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsListByResourceGroup_568208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machine groups in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568210 = path.getOrDefault("resourceGroupName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceGroupName", valid_568210
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_SqlVirtualMachineGroupsListByResourceGroup_568207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a resource group.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_SqlVirtualMachineGroupsListByResourceGroup_568207;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsListByResourceGroup
  ## Gets all SQL virtual machine groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(path_568215, "resourceGroupName", newJString(resourceGroupName))
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var sqlVirtualMachineGroupsListByResourceGroup* = Call_SqlVirtualMachineGroupsListByResourceGroup_568207(
    name: "sqlVirtualMachineGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsListByResourceGroup_568208,
    base: "", url: url_SqlVirtualMachineGroupsListByResourceGroup_568209,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsCreateOrUpdate_568228 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsCreateOrUpdate_568230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsCreateOrUpdate_568229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568232
  var valid_568233 = path.getOrDefault("subscriptionId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "subscriptionId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_SqlVirtualMachineGroupsCreateOrUpdate_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine group.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_SqlVirtualMachineGroupsCreateOrUpdate_568228;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## sqlVirtualMachineGroupsCreateOrUpdate
  ## Creates or updates a SQL virtual machine group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  var body_568240 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568240 = parameters
  result = call_568237.call(path_568238, query_568239, nil, nil, body_568240)

var sqlVirtualMachineGroupsCreateOrUpdate* = Call_SqlVirtualMachineGroupsCreateOrUpdate_568228(
    name: "sqlVirtualMachineGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsCreateOrUpdate_568229, base: "",
    url: url_SqlVirtualMachineGroupsCreateOrUpdate_568230, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsGet_568217 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsGet_568219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsGet_568218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_SqlVirtualMachineGroupsGet_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine group.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_SqlVirtualMachineGroupsGet_568217;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsGet
  ## Gets a SQL virtual machine group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var sqlVirtualMachineGroupsGet* = Call_SqlVirtualMachineGroupsGet_568217(
    name: "sqlVirtualMachineGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsGet_568218, base: "",
    url: url_SqlVirtualMachineGroupsGet_568219, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsUpdate_568252 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsUpdate_568254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsUpdate_568253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates SQL virtual machine group tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_SqlVirtualMachineGroupsUpdate_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates SQL virtual machine group tags.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_SqlVirtualMachineGroupsUpdate_568252;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## sqlVirtualMachineGroupsUpdate
  ## Updates SQL virtual machine group tags.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  var body_568264 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568264 = parameters
  result = call_568261.call(path_568262, query_568263, nil, nil, body_568264)

var sqlVirtualMachineGroupsUpdate* = Call_SqlVirtualMachineGroupsUpdate_568252(
    name: "sqlVirtualMachineGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsUpdate_568253, base: "",
    url: url_SqlVirtualMachineGroupsUpdate_568254, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsDelete_568241 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachineGroupsDelete_568243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachineGroupsDelete_568242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_SqlVirtualMachineGroupsDelete_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine group.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_SqlVirtualMachineGroupsDelete_568241;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsDelete
  ## Deletes a SQL virtual machine group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var sqlVirtualMachineGroupsDelete* = Call_SqlVirtualMachineGroupsDelete_568241(
    name: "sqlVirtualMachineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsDelete_568242, base: "",
    url: url_SqlVirtualMachineGroupsDelete_568243, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersListByGroup_568265 = ref object of OpenApiRestCall_567657
proc url_AvailabilityGroupListenersListByGroup_568267(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName"),
               (kind: ConstantSegment, value: "/availabilityGroupListeners")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityGroupListenersListByGroup_568266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability group listeners in a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_AvailabilityGroupListenersListByGroup_568265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability group listeners in a SQL virtual machine group.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_AvailabilityGroupListenersListByGroup_568265;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string): Recallable =
  ## availabilityGroupListenersListByGroup
  ## Lists all availability group listeners in a SQL virtual machine group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var availabilityGroupListenersListByGroup* = Call_AvailabilityGroupListenersListByGroup_568265(
    name: "availabilityGroupListenersListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners",
    validator: validate_AvailabilityGroupListenersListByGroup_568266, base: "",
    url: url_AvailabilityGroupListenersListByGroup_568267, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersCreateOrUpdate_568288 = ref object of OpenApiRestCall_567657
proc url_AvailabilityGroupListenersCreateOrUpdate_568290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  assert "availabilityGroupListenerName" in path,
        "`availabilityGroupListenerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName"),
               (kind: ConstantSegment, value: "/availabilityGroupListeners/"),
               (kind: VariableSegment, value: "availabilityGroupListenerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityGroupListenersCreateOrUpdate_568289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("availabilityGroupListenerName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "availabilityGroupListenerName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The availability group listener.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_AvailabilityGroupListenersCreateOrUpdate_568288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an availability group listener.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_AvailabilityGroupListenersCreateOrUpdate_568288;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          availabilityGroupListenerName: string; parameters: JsonNode): Recallable =
  ## availabilityGroupListenersCreateOrUpdate
  ## Creates or updates an availability group listener.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  ##   parameters: JObject (required)
  ##             : The availability group listener.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  var body_568301 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(path_568299, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  if parameters != nil:
    body_568301 = parameters
  result = call_568298.call(path_568299, query_568300, nil, nil, body_568301)

var availabilityGroupListenersCreateOrUpdate* = Call_AvailabilityGroupListenersCreateOrUpdate_568288(
    name: "availabilityGroupListenersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersCreateOrUpdate_568289, base: "",
    url: url_AvailabilityGroupListenersCreateOrUpdate_568290,
    schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersGet_568276 = ref object of OpenApiRestCall_567657
proc url_AvailabilityGroupListenersGet_568278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  assert "availabilityGroupListenerName" in path,
        "`availabilityGroupListenerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName"),
               (kind: ConstantSegment, value: "/availabilityGroupListeners/"),
               (kind: VariableSegment, value: "availabilityGroupListenerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityGroupListenersGet_568277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  var valid_568282 = path.getOrDefault("availabilityGroupListenerName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "availabilityGroupListenerName", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_AvailabilityGroupListenersGet_568276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an availability group listener.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_AvailabilityGroupListenersGet_568276;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          availabilityGroupListenerName: string): Recallable =
  ## availabilityGroupListenersGet
  ## Gets an availability group listener.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  result = call_568285.call(path_568286, query_568287, nil, nil, nil)

var availabilityGroupListenersGet* = Call_AvailabilityGroupListenersGet_568276(
    name: "availabilityGroupListenersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersGet_568277, base: "",
    url: url_AvailabilityGroupListenersGet_568278, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersDelete_568302 = ref object of OpenApiRestCall_567657
proc url_AvailabilityGroupListenersDelete_568304(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineGroupName" in path,
        "`sqlVirtualMachineGroupName` is a required path parameter"
  assert "availabilityGroupListenerName" in path,
        "`availabilityGroupListenerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/"),
               (kind: VariableSegment, value: "sqlVirtualMachineGroupName"),
               (kind: ConstantSegment, value: "/availabilityGroupListeners/"),
               (kind: VariableSegment, value: "availabilityGroupListenerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityGroupListenersDelete_568303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "sqlVirtualMachineGroupName", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("availabilityGroupListenerName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "availabilityGroupListenerName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_AvailabilityGroupListenersDelete_568302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an availability group listener.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_AvailabilityGroupListenersDelete_568302;
          resourceGroupName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          availabilityGroupListenerName: string): Recallable =
  ## availabilityGroupListenersDelete
  ## Deletes an availability group listener.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  add(path_568312, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var availabilityGroupListenersDelete* = Call_AvailabilityGroupListenersDelete_568302(
    name: "availabilityGroupListenersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersDelete_568303, base: "",
    url: url_AvailabilityGroupListenersDelete_568304, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesListByResourceGroup_568314 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesListByResourceGroup_568316(protocol: Scheme;
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
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesListByResourceGroup_568315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machines in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568317 = path.getOrDefault("resourceGroupName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "resourceGroupName", valid_568317
  var valid_568318 = path.getOrDefault("subscriptionId")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "subscriptionId", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_SqlVirtualMachinesListByResourceGroup_568314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a resource group.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_SqlVirtualMachinesListByResourceGroup_568314;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachinesListByResourceGroup
  ## Gets all SQL virtual machines in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var sqlVirtualMachinesListByResourceGroup* = Call_SqlVirtualMachinesListByResourceGroup_568314(
    name: "sqlVirtualMachinesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesListByResourceGroup_568315, base: "",
    url: url_SqlVirtualMachinesListByResourceGroup_568316, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesCreateOrUpdate_568337 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesCreateOrUpdate_568339(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineName" in path,
        "`sqlVirtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/"),
               (kind: VariableSegment, value: "sqlVirtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesCreateOrUpdate_568338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  var valid_568342 = path.getOrDefault("sqlVirtualMachineName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "sqlVirtualMachineName", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_SqlVirtualMachinesCreateOrUpdate_568337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_SqlVirtualMachinesCreateOrUpdate_568337;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlVirtualMachineName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachinesCreateOrUpdate
  ## Creates or updates a SQL virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  var body_568349 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(path_568347, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  if parameters != nil:
    body_568349 = parameters
  result = call_568346.call(path_568347, query_568348, nil, nil, body_568349)

var sqlVirtualMachinesCreateOrUpdate* = Call_SqlVirtualMachinesCreateOrUpdate_568337(
    name: "sqlVirtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesCreateOrUpdate_568338, base: "",
    url: url_SqlVirtualMachinesCreateOrUpdate_568339, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesGet_568324 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesGet_568326(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineName" in path,
        "`sqlVirtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/"),
               (kind: VariableSegment, value: "sqlVirtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesGet_568325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("sqlVirtualMachineName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "sqlVirtualMachineName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The child resources to include in the response.
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  var valid_568331 = query.getOrDefault("$expand")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "$expand", valid_568331
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568333: Call_SqlVirtualMachinesGet_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine.
  ## 
  let valid = call_568333.validator(path, query, header, formData, body)
  let scheme = call_568333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568333.url(scheme.get, call_568333.host, call_568333.base,
                         call_568333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568333, url, valid)

proc call*(call_568334: Call_SqlVirtualMachinesGet_568324;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlVirtualMachineName: string; Expand: string = ""): Recallable =
  ## sqlVirtualMachinesGet
  ## Gets a SQL virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  var path_568335 = newJObject()
  var query_568336 = newJObject()
  add(path_568335, "resourceGroupName", newJString(resourceGroupName))
  add(query_568336, "$expand", newJString(Expand))
  add(query_568336, "api-version", newJString(apiVersion))
  add(path_568335, "subscriptionId", newJString(subscriptionId))
  add(path_568335, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  result = call_568334.call(path_568335, query_568336, nil, nil, nil)

var sqlVirtualMachinesGet* = Call_SqlVirtualMachinesGet_568324(
    name: "sqlVirtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesGet_568325, base: "",
    url: url_SqlVirtualMachinesGet_568326, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesUpdate_568361 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesUpdate_568363(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineName" in path,
        "`sqlVirtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/"),
               (kind: VariableSegment, value: "sqlVirtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesUpdate_568362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("sqlVirtualMachineName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "sqlVirtualMachineName", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_SqlVirtualMachinesUpdate_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a SQL virtual machine.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_SqlVirtualMachinesUpdate_568361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlVirtualMachineName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachinesUpdate
  ## Updates a SQL virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  var body_568373 = newJObject()
  add(path_568371, "resourceGroupName", newJString(resourceGroupName))
  add(query_568372, "api-version", newJString(apiVersion))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  add(path_568371, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  if parameters != nil:
    body_568373 = parameters
  result = call_568370.call(path_568371, query_568372, nil, nil, body_568373)

var sqlVirtualMachinesUpdate* = Call_SqlVirtualMachinesUpdate_568361(
    name: "sqlVirtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesUpdate_568362, base: "",
    url: url_SqlVirtualMachinesUpdate_568363, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesDelete_568350 = ref object of OpenApiRestCall_567657
proc url_SqlVirtualMachinesDelete_568352(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "sqlVirtualMachineName" in path,
        "`sqlVirtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/"),
               (kind: VariableSegment, value: "sqlVirtualMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlVirtualMachinesDelete_568351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("sqlVirtualMachineName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "sqlVirtualMachineName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_SqlVirtualMachinesDelete_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine.
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_SqlVirtualMachinesDelete_568350;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sqlVirtualMachineName: string): Recallable =
  ## sqlVirtualMachinesDelete
  ## Deletes a SQL virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(path_568359, "resourceGroupName", newJString(resourceGroupName))
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var sqlVirtualMachinesDelete* = Call_SqlVirtualMachinesDelete_568350(
    name: "sqlVirtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesDelete_568351, base: "",
    url: url_SqlVirtualMachinesDelete_568352, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
