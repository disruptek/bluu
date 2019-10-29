
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "sqlvirtualmachine-sqlvm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
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
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available SQL Rest API operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available SQL Rest API operations.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SqlVirtualMachine/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsList_564075 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsList_564077(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsList_564076(path: JsonNode; query: JsonNode;
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
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_SqlVirtualMachineGroupsList_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a subscription.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_SqlVirtualMachineGroupsList_564075;
          apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsList
  ## Gets all SQL virtual machine groups in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var sqlVirtualMachineGroupsList* = Call_SqlVirtualMachineGroupsList_564075(
    name: "sqlVirtualMachineGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsList_564076, base: "",
    url: url_SqlVirtualMachineGroupsList_564077, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesList_564098 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesList_564100(protocol: Scheme; host: string; base: string;
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

proc validate_SqlVirtualMachinesList_564099(path: JsonNode; query: JsonNode;
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
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_SqlVirtualMachinesList_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a subscription.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_SqlVirtualMachinesList_564098; apiVersion: string;
          subscriptionId: string): Recallable =
  ## sqlVirtualMachinesList
  ## Gets all SQL virtual machines in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var sqlVirtualMachinesList* = Call_SqlVirtualMachinesList_564098(
    name: "sqlVirtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesList_564099, base: "",
    url: url_SqlVirtualMachinesList_564100, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsListByResourceGroup_564107 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsListByResourceGroup_564109(protocol: Scheme;
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

proc validate_SqlVirtualMachineGroupsListByResourceGroup_564108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machine groups in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_SqlVirtualMachineGroupsListByResourceGroup_564107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a resource group.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_SqlVirtualMachineGroupsListByResourceGroup_564107;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## sqlVirtualMachineGroupsListByResourceGroup
  ## Gets all SQL virtual machine groups in a resource group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  add(path_564115, "resourceGroupName", newJString(resourceGroupName))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var sqlVirtualMachineGroupsListByResourceGroup* = Call_SqlVirtualMachineGroupsListByResourceGroup_564107(
    name: "sqlVirtualMachineGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsListByResourceGroup_564108,
    base: "", url: url_SqlVirtualMachineGroupsListByResourceGroup_564109,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsCreateOrUpdate_564128 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsCreateOrUpdate_564130(protocol: Scheme;
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

proc validate_SqlVirtualMachineGroupsCreateOrUpdate_564129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineGroupName` field"
  var valid_564131 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564131
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
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

proc call*(call_564136: Call_SqlVirtualMachineGroupsCreateOrUpdate_564128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine group.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_SqlVirtualMachineGroupsCreateOrUpdate_564128;
          apiVersion: string; sqlVirtualMachineGroupName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachineGroupsCreateOrUpdate
  ## Creates or updates a SQL virtual machine group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  var body_564140 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564138, "subscriptionId", newJString(subscriptionId))
  add(path_564138, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564140 = parameters
  result = call_564137.call(path_564138, query_564139, nil, nil, body_564140)

var sqlVirtualMachineGroupsCreateOrUpdate* = Call_SqlVirtualMachineGroupsCreateOrUpdate_564128(
    name: "sqlVirtualMachineGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsCreateOrUpdate_564129, base: "",
    url: url_SqlVirtualMachineGroupsCreateOrUpdate_564130, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsGet_564117 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsGet_564119(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsGet_564118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineGroupName` field"
  var valid_564120 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564120
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_SqlVirtualMachineGroupsGet_564117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine group.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_SqlVirtualMachineGroupsGet_564117; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## sqlVirtualMachineGroupsGet
  ## Gets a SQL virtual machine group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var sqlVirtualMachineGroupsGet* = Call_SqlVirtualMachineGroupsGet_564117(
    name: "sqlVirtualMachineGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsGet_564118, base: "",
    url: url_SqlVirtualMachineGroupsGet_564119, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsUpdate_564152 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsUpdate_564154(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsUpdate_564153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates SQL virtual machine group tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineGroupName` field"
  var valid_564155 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564155
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
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

proc call*(call_564160: Call_SqlVirtualMachineGroupsUpdate_564152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates SQL virtual machine group tags.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_SqlVirtualMachineGroupsUpdate_564152;
          apiVersion: string; sqlVirtualMachineGroupName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachineGroupsUpdate
  ## Updates SQL virtual machine group tags.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine group.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  var body_564164 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564164 = parameters
  result = call_564161.call(path_564162, query_564163, nil, nil, body_564164)

var sqlVirtualMachineGroupsUpdate* = Call_SqlVirtualMachineGroupsUpdate_564152(
    name: "sqlVirtualMachineGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsUpdate_564153, base: "",
    url: url_SqlVirtualMachineGroupsUpdate_564154, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsDelete_564141 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachineGroupsDelete_564143(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsDelete_564142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineGroupName` field"
  var valid_564144 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564144
  var valid_564145 = path.getOrDefault("subscriptionId")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "subscriptionId", valid_564145
  var valid_564146 = path.getOrDefault("resourceGroupName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceGroupName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_SqlVirtualMachineGroupsDelete_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine group.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_SqlVirtualMachineGroupsDelete_564141;
          apiVersion: string; sqlVirtualMachineGroupName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## sqlVirtualMachineGroupsDelete
  ## Deletes a SQL virtual machine group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  add(path_564150, "resourceGroupName", newJString(resourceGroupName))
  result = call_564149.call(path_564150, query_564151, nil, nil, nil)

var sqlVirtualMachineGroupsDelete* = Call_SqlVirtualMachineGroupsDelete_564141(
    name: "sqlVirtualMachineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsDelete_564142, base: "",
    url: url_SqlVirtualMachineGroupsDelete_564143, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersListByGroup_564165 = ref object of OpenApiRestCall_563555
proc url_AvailabilityGroupListenersListByGroup_564167(protocol: Scheme;
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

proc validate_AvailabilityGroupListenersListByGroup_564166(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability group listeners in a SQL virtual machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineGroupName` field"
  var valid_564168 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564168
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_AvailabilityGroupListenersListByGroup_564165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability group listeners in a SQL virtual machine group.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_AvailabilityGroupListenersListByGroup_564165;
          apiVersion: string; sqlVirtualMachineGroupName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## availabilityGroupListenersListByGroup
  ## Lists all availability group listeners in a SQL virtual machine group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var availabilityGroupListenersListByGroup* = Call_AvailabilityGroupListenersListByGroup_564165(
    name: "availabilityGroupListenersListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners",
    validator: validate_AvailabilityGroupListenersListByGroup_564166, base: "",
    url: url_AvailabilityGroupListenersListByGroup_564167, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersCreateOrUpdate_564188 = ref object of OpenApiRestCall_563555
proc url_AvailabilityGroupListenersCreateOrUpdate_564190(protocol: Scheme;
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

proc validate_AvailabilityGroupListenersCreateOrUpdate_564189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilityGroupListenerName` field"
  var valid_564191 = path.getOrDefault("availabilityGroupListenerName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "availabilityGroupListenerName", valid_564191
  var valid_564192 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
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

proc call*(call_564197: Call_AvailabilityGroupListenersCreateOrUpdate_564188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an availability group listener.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_AvailabilityGroupListenersCreateOrUpdate_564188;
          availabilityGroupListenerName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## availabilityGroupListenersCreateOrUpdate
  ## Creates or updates an availability group listener.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The availability group listener.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  var body_564201 = newJObject()
  add(path_564199, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(path_564199, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564201 = parameters
  result = call_564198.call(path_564199, query_564200, nil, nil, body_564201)

var availabilityGroupListenersCreateOrUpdate* = Call_AvailabilityGroupListenersCreateOrUpdate_564188(
    name: "availabilityGroupListenersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersCreateOrUpdate_564189, base: "",
    url: url_AvailabilityGroupListenersCreateOrUpdate_564190,
    schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersGet_564176 = ref object of OpenApiRestCall_563555
proc url_AvailabilityGroupListenersGet_564178(protocol: Scheme; host: string;
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

proc validate_AvailabilityGroupListenersGet_564177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilityGroupListenerName` field"
  var valid_564179 = path.getOrDefault("availabilityGroupListenerName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "availabilityGroupListenerName", valid_564179
  var valid_564180 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564180
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_AvailabilityGroupListenersGet_564176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an availability group listener.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_AvailabilityGroupListenersGet_564176;
          availabilityGroupListenerName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## availabilityGroupListenersGet
  ## Gets an availability group listener.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(path_564186, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var availabilityGroupListenersGet* = Call_AvailabilityGroupListenersGet_564176(
    name: "availabilityGroupListenersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersGet_564177, base: "",
    url: url_AvailabilityGroupListenersGet_564178, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersDelete_564202 = ref object of OpenApiRestCall_563555
proc url_AvailabilityGroupListenersDelete_564204(protocol: Scheme; host: string;
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

proc validate_AvailabilityGroupListenersDelete_564203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an availability group listener.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilityGroupListenerName: JString (required)
  ##                                : Name of the availability group listener.
  ##   sqlVirtualMachineGroupName: JString (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilityGroupListenerName` field"
  var valid_564205 = path.getOrDefault("availabilityGroupListenerName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "availabilityGroupListenerName", valid_564205
  var valid_564206 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "sqlVirtualMachineGroupName", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_AvailabilityGroupListenersDelete_564202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an availability group listener.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_AvailabilityGroupListenersDelete_564202;
          availabilityGroupListenerName: string; apiVersion: string;
          sqlVirtualMachineGroupName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## availabilityGroupListenersDelete
  ## Deletes an availability group listener.
  ##   availabilityGroupListenerName: string (required)
  ##                                : Name of the availability group listener.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   sqlVirtualMachineGroupName: string (required)
  ##                             : Name of the SQL virtual machine group.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(path_564212, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var availabilityGroupListenersDelete* = Call_AvailabilityGroupListenersDelete_564202(
    name: "availabilityGroupListenersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersDelete_564203, base: "",
    url: url_AvailabilityGroupListenersDelete_564204, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesListByResourceGroup_564214 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesListByResourceGroup_564216(protocol: Scheme;
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

proc validate_SqlVirtualMachinesListByResourceGroup_564215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all SQL virtual machines in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564217 = path.getOrDefault("subscriptionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "subscriptionId", valid_564217
  var valid_564218 = path.getOrDefault("resourceGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceGroupName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_SqlVirtualMachinesListByResourceGroup_564214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a resource group.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_SqlVirtualMachinesListByResourceGroup_564214;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## sqlVirtualMachinesListByResourceGroup
  ## Gets all SQL virtual machines in a resource group.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var sqlVirtualMachinesListByResourceGroup* = Call_SqlVirtualMachinesListByResourceGroup_564214(
    name: "sqlVirtualMachinesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesListByResourceGroup_564215, base: "",
    url: url_SqlVirtualMachinesListByResourceGroup_564216, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesCreateOrUpdate_564237 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesCreateOrUpdate_564239(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesCreateOrUpdate_564238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineName` field"
  var valid_564240 = path.getOrDefault("sqlVirtualMachineName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "sqlVirtualMachineName", valid_564240
  var valid_564241 = path.getOrDefault("subscriptionId")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "subscriptionId", valid_564241
  var valid_564242 = path.getOrDefault("resourceGroupName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "resourceGroupName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "api-version", valid_564243
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

proc call*(call_564245: Call_SqlVirtualMachinesCreateOrUpdate_564237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_SqlVirtualMachinesCreateOrUpdate_564237;
          sqlVirtualMachineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachinesCreateOrUpdate
  ## Creates or updates a SQL virtual machine.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  var body_564249 = newJObject()
  add(path_564247, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564249 = parameters
  result = call_564246.call(path_564247, query_564248, nil, nil, body_564249)

var sqlVirtualMachinesCreateOrUpdate* = Call_SqlVirtualMachinesCreateOrUpdate_564237(
    name: "sqlVirtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesCreateOrUpdate_564238, base: "",
    url: url_SqlVirtualMachinesCreateOrUpdate_564239, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesGet_564224 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesGet_564226(protocol: Scheme; host: string; base: string;
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

proc validate_SqlVirtualMachinesGet_564225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineName` field"
  var valid_564228 = path.getOrDefault("sqlVirtualMachineName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "sqlVirtualMachineName", valid_564228
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("resourceGroupName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceGroupName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  ##   $expand: JString
  ##          : The child resources to include in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  var valid_564232 = query.getOrDefault("$expand")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "$expand", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_SqlVirtualMachinesGet_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_SqlVirtualMachinesGet_564224;
          sqlVirtualMachineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; Expand: string = ""): Recallable =
  ## sqlVirtualMachinesGet
  ## Gets a SQL virtual machine.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   Expand: string
  ##         : The child resources to include in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(path_564235, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  add(query_564236, "api-version", newJString(apiVersion))
  add(query_564236, "$expand", newJString(Expand))
  add(path_564235, "subscriptionId", newJString(subscriptionId))
  add(path_564235, "resourceGroupName", newJString(resourceGroupName))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var sqlVirtualMachinesGet* = Call_SqlVirtualMachinesGet_564224(
    name: "sqlVirtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesGet_564225, base: "",
    url: url_SqlVirtualMachinesGet_564226, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesUpdate_564261 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesUpdate_564263(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesUpdate_564262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineName` field"
  var valid_564264 = path.getOrDefault("sqlVirtualMachineName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "sqlVirtualMachineName", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("resourceGroupName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "resourceGroupName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
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

proc call*(call_564269: Call_SqlVirtualMachinesUpdate_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a SQL virtual machine.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_SqlVirtualMachinesUpdate_564261;
          sqlVirtualMachineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## sqlVirtualMachinesUpdate
  ## Updates a SQL virtual machine.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The SQL virtual machine.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  var body_564273 = newJObject()
  add(path_564271, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564273 = parameters
  result = call_564270.call(path_564271, query_564272, nil, nil, body_564273)

var sqlVirtualMachinesUpdate* = Call_SqlVirtualMachinesUpdate_564261(
    name: "sqlVirtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesUpdate_564262, base: "",
    url: url_SqlVirtualMachinesUpdate_564263, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesDelete_564250 = ref object of OpenApiRestCall_563555
proc url_SqlVirtualMachinesDelete_564252(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesDelete_564251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a SQL virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sqlVirtualMachineName: JString (required)
  ##                        : Name of the SQL virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sqlVirtualMachineName` field"
  var valid_564253 = path.getOrDefault("sqlVirtualMachineName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "sqlVirtualMachineName", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_SqlVirtualMachinesDelete_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine.
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_SqlVirtualMachinesDelete_564250;
          sqlVirtualMachineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## sqlVirtualMachinesDelete
  ## Deletes a SQL virtual machine.
  ##   sqlVirtualMachineName: string (required)
  ##                        : Name of the SQL virtual machine.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(path_564259, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  add(query_564260, "api-version", newJString(apiVersion))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var sqlVirtualMachinesDelete* = Call_SqlVirtualMachinesDelete_564250(
    name: "sqlVirtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesDelete_564251, base: "",
    url: url_SqlVirtualMachinesDelete_564252, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
