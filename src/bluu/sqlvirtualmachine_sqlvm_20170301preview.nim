
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "sqlvirtualmachine-sqlvm"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available SQL Rest API operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available SQL Rest API operations.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SqlVirtualMachine/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsList_593942 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsList_593944(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsList_593943(path: JsonNode; query: JsonNode;
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
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_SqlVirtualMachineGroupsList_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a subscription.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_SqlVirtualMachineGroupsList_593942;
          apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsList
  ## Gets all SQL virtual machine groups in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var sqlVirtualMachineGroupsList* = Call_SqlVirtualMachineGroupsList_593942(
    name: "sqlVirtualMachineGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsList_593943, base: "",
    url: url_SqlVirtualMachineGroupsList_593944, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesList_593965 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesList_593967(protocol: Scheme; host: string; base: string;
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

proc validate_SqlVirtualMachinesList_593966(path: JsonNode; query: JsonNode;
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
  var valid_593968 = path.getOrDefault("subscriptionId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "subscriptionId", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_SqlVirtualMachinesList_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a subscription.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_SqlVirtualMachinesList_593965; apiVersion: string;
          subscriptionId: string): Recallable =
  ## sqlVirtualMachinesList
  ## Gets all SQL virtual machines in a subscription.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "subscriptionId", newJString(subscriptionId))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var sqlVirtualMachinesList* = Call_SqlVirtualMachinesList_593965(
    name: "sqlVirtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesList_593966, base: "",
    url: url_SqlVirtualMachinesList_593967, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsListByResourceGroup_593974 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsListByResourceGroup_593976(protocol: Scheme;
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

proc validate_SqlVirtualMachineGroupsListByResourceGroup_593975(path: JsonNode;
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
  var valid_593977 = path.getOrDefault("resourceGroupName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "resourceGroupName", valid_593977
  var valid_593978 = path.getOrDefault("subscriptionId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "subscriptionId", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_SqlVirtualMachineGroupsListByResourceGroup_593974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machine groups in a resource group.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_SqlVirtualMachineGroupsListByResourceGroup_593974;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachineGroupsListByResourceGroup
  ## Gets all SQL virtual machine groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(path_593982, "resourceGroupName", newJString(resourceGroupName))
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var sqlVirtualMachineGroupsListByResourceGroup* = Call_SqlVirtualMachineGroupsListByResourceGroup_593974(
    name: "sqlVirtualMachineGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups",
    validator: validate_SqlVirtualMachineGroupsListByResourceGroup_593975,
    base: "", url: url_SqlVirtualMachineGroupsListByResourceGroup_593976,
    schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsCreateOrUpdate_593995 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsCreateOrUpdate_593997(protocol: Scheme;
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

proc validate_SqlVirtualMachineGroupsCreateOrUpdate_593996(path: JsonNode;
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
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "sqlVirtualMachineGroupName", valid_593999
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
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

proc call*(call_594003: Call_SqlVirtualMachineGroupsCreateOrUpdate_593995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine group.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_SqlVirtualMachineGroupsCreateOrUpdate_593995;
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
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594007 = parameters
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var sqlVirtualMachineGroupsCreateOrUpdate* = Call_SqlVirtualMachineGroupsCreateOrUpdate_593995(
    name: "sqlVirtualMachineGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsCreateOrUpdate_593996, base: "",
    url: url_SqlVirtualMachineGroupsCreateOrUpdate_593997, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsGet_593984 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsGet_593986(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsGet_593985(path: JsonNode; query: JsonNode;
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
  var valid_593987 = path.getOrDefault("resourceGroupName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "resourceGroupName", valid_593987
  var valid_593988 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "sqlVirtualMachineGroupName", valid_593988
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_SqlVirtualMachineGroupsGet_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine group.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_SqlVirtualMachineGroupsGet_593984;
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
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var sqlVirtualMachineGroupsGet* = Call_SqlVirtualMachineGroupsGet_593984(
    name: "sqlVirtualMachineGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsGet_593985, base: "",
    url: url_SqlVirtualMachineGroupsGet_593986, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsUpdate_594019 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsUpdate_594021(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsUpdate_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
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

proc call*(call_594027: Call_SqlVirtualMachineGroupsUpdate_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates SQL virtual machine group tags.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_SqlVirtualMachineGroupsUpdate_594019;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594031 = parameters
  result = call_594028.call(path_594029, query_594030, nil, nil, body_594031)

var sqlVirtualMachineGroupsUpdate* = Call_SqlVirtualMachineGroupsUpdate_594019(
    name: "sqlVirtualMachineGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsUpdate_594020, base: "",
    url: url_SqlVirtualMachineGroupsUpdate_594021, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachineGroupsDelete_594008 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachineGroupsDelete_594010(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachineGroupsDelete_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_SqlVirtualMachineGroupsDelete_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine group.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_SqlVirtualMachineGroupsDelete_594008;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var sqlVirtualMachineGroupsDelete* = Call_SqlVirtualMachineGroupsDelete_594008(
    name: "sqlVirtualMachineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}",
    validator: validate_SqlVirtualMachineGroupsDelete_594009, base: "",
    url: url_SqlVirtualMachineGroupsDelete_594010, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersListByGroup_594032 = ref object of OpenApiRestCall_593424
proc url_AvailabilityGroupListenersListByGroup_594034(protocol: Scheme;
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

proc validate_AvailabilityGroupListenersListByGroup_594033(path: JsonNode;
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
  var valid_594035 = path.getOrDefault("resourceGroupName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceGroupName", valid_594035
  var valid_594036 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_AvailabilityGroupListenersListByGroup_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability group listeners in a SQL virtual machine group.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_AvailabilityGroupListenersListByGroup_594032;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var availabilityGroupListenersListByGroup* = Call_AvailabilityGroupListenersListByGroup_594032(
    name: "availabilityGroupListenersListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners",
    validator: validate_AvailabilityGroupListenersListByGroup_594033, base: "",
    url: url_AvailabilityGroupListenersListByGroup_594034, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersCreateOrUpdate_594055 = ref object of OpenApiRestCall_593424
proc url_AvailabilityGroupListenersCreateOrUpdate_594057(protocol: Scheme;
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

proc validate_AvailabilityGroupListenersCreateOrUpdate_594056(path: JsonNode;
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
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("availabilityGroupListenerName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "availabilityGroupListenerName", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "api-version", valid_594062
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

proc call*(call_594064: Call_AvailabilityGroupListenersCreateOrUpdate_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an availability group listener.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_AvailabilityGroupListenersCreateOrUpdate_594055;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  if parameters != nil:
    body_594068 = parameters
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var availabilityGroupListenersCreateOrUpdate* = Call_AvailabilityGroupListenersCreateOrUpdate_594055(
    name: "availabilityGroupListenersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersCreateOrUpdate_594056, base: "",
    url: url_AvailabilityGroupListenersCreateOrUpdate_594057,
    schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersGet_594043 = ref object of OpenApiRestCall_593424
proc url_AvailabilityGroupListenersGet_594045(protocol: Scheme; host: string;
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

proc validate_AvailabilityGroupListenersGet_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  var valid_594049 = path.getOrDefault("availabilityGroupListenerName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "availabilityGroupListenerName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_AvailabilityGroupListenersGet_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an availability group listener.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_AvailabilityGroupListenersGet_594043;
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var availabilityGroupListenersGet* = Call_AvailabilityGroupListenersGet_594043(
    name: "availabilityGroupListenersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersGet_594044, base: "",
    url: url_AvailabilityGroupListenersGet_594045, schemes: {Scheme.Https})
type
  Call_AvailabilityGroupListenersDelete_594069 = ref object of OpenApiRestCall_593424
proc url_AvailabilityGroupListenersDelete_594071(protocol: Scheme; host: string;
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

proc validate_AvailabilityGroupListenersDelete_594070(path: JsonNode;
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
  var valid_594072 = path.getOrDefault("resourceGroupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "resourceGroupName", valid_594072
  var valid_594073 = path.getOrDefault("sqlVirtualMachineGroupName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "sqlVirtualMachineGroupName", valid_594073
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  var valid_594075 = path.getOrDefault("availabilityGroupListenerName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "availabilityGroupListenerName", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_AvailabilityGroupListenersDelete_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an availability group listener.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_AvailabilityGroupListenersDelete_594069;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "sqlVirtualMachineGroupName",
      newJString(sqlVirtualMachineGroupName))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  add(path_594079, "availabilityGroupListenerName",
      newJString(availabilityGroupListenerName))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var availabilityGroupListenersDelete* = Call_AvailabilityGroupListenersDelete_594069(
    name: "availabilityGroupListenersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachineGroups/{sqlVirtualMachineGroupName}/availabilityGroupListeners/{availabilityGroupListenerName}",
    validator: validate_AvailabilityGroupListenersDelete_594070, base: "",
    url: url_AvailabilityGroupListenersDelete_594071, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesListByResourceGroup_594081 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesListByResourceGroup_594083(protocol: Scheme;
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

proc validate_SqlVirtualMachinesListByResourceGroup_594082(path: JsonNode;
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
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_SqlVirtualMachinesListByResourceGroup_594081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all SQL virtual machines in a resource group.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_SqlVirtualMachinesListByResourceGroup_594081;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## sqlVirtualMachinesListByResourceGroup
  ## Gets all SQL virtual machines in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID that identifies an Azure subscription.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var sqlVirtualMachinesListByResourceGroup* = Call_SqlVirtualMachinesListByResourceGroup_594081(
    name: "sqlVirtualMachinesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines",
    validator: validate_SqlVirtualMachinesListByResourceGroup_594082, base: "",
    url: url_SqlVirtualMachinesListByResourceGroup_594083, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesCreateOrUpdate_594104 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesCreateOrUpdate_594106(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesCreateOrUpdate_594105(path: JsonNode;
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
  var valid_594107 = path.getOrDefault("resourceGroupName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "resourceGroupName", valid_594107
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("sqlVirtualMachineName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "sqlVirtualMachineName", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
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

proc call*(call_594112: Call_SqlVirtualMachinesCreateOrUpdate_594104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a SQL virtual machine.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_SqlVirtualMachinesCreateOrUpdate_594104;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(path_594114, "resourceGroupName", newJString(resourceGroupName))
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  if parameters != nil:
    body_594116 = parameters
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var sqlVirtualMachinesCreateOrUpdate* = Call_SqlVirtualMachinesCreateOrUpdate_594104(
    name: "sqlVirtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesCreateOrUpdate_594105, base: "",
    url: url_SqlVirtualMachinesCreateOrUpdate_594106, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesGet_594091 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesGet_594093(protocol: Scheme; host: string; base: string;
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

proc validate_SqlVirtualMachinesGet_594092(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("sqlVirtualMachineName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "sqlVirtualMachineName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The child resources to include in the response.
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  var valid_594098 = query.getOrDefault("$expand")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "$expand", valid_594098
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_SqlVirtualMachinesGet_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a SQL virtual machine.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_SqlVirtualMachinesGet_594091;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(query_594103, "$expand", newJString(Expand))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(path_594102, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var sqlVirtualMachinesGet* = Call_SqlVirtualMachinesGet_594091(
    name: "sqlVirtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesGet_594092, base: "",
    url: url_SqlVirtualMachinesGet_594093, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesUpdate_594128 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesUpdate_594130(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesUpdate_594129(path: JsonNode; query: JsonNode;
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
  var valid_594131 = path.getOrDefault("resourceGroupName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "resourceGroupName", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  var valid_594133 = path.getOrDefault("sqlVirtualMachineName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "sqlVirtualMachineName", valid_594133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594134 = query.getOrDefault("api-version")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "api-version", valid_594134
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

proc call*(call_594136: Call_SqlVirtualMachinesUpdate_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a SQL virtual machine.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_SqlVirtualMachinesUpdate_594128;
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
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  var body_594140 = newJObject()
  add(path_594138, "resourceGroupName", newJString(resourceGroupName))
  add(query_594139, "api-version", newJString(apiVersion))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  add(path_594138, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  if parameters != nil:
    body_594140 = parameters
  result = call_594137.call(path_594138, query_594139, nil, nil, body_594140)

var sqlVirtualMachinesUpdate* = Call_SqlVirtualMachinesUpdate_594128(
    name: "sqlVirtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesUpdate_594129, base: "",
    url: url_SqlVirtualMachinesUpdate_594130, schemes: {Scheme.Https})
type
  Call_SqlVirtualMachinesDelete_594117 = ref object of OpenApiRestCall_593424
proc url_SqlVirtualMachinesDelete_594119(protocol: Scheme; host: string;
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

proc validate_SqlVirtualMachinesDelete_594118(path: JsonNode; query: JsonNode;
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
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  var valid_594122 = path.getOrDefault("sqlVirtualMachineName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "sqlVirtualMachineName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_SqlVirtualMachinesDelete_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a SQL virtual machine.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_SqlVirtualMachinesDelete_594117;
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
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(path_594126, "resourceGroupName", newJString(resourceGroupName))
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  add(path_594126, "sqlVirtualMachineName", newJString(sqlVirtualMachineName))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var sqlVirtualMachinesDelete* = Call_SqlVirtualMachinesDelete_594117(
    name: "sqlVirtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/{sqlVirtualMachineName}",
    validator: validate_SqlVirtualMachinesDelete_594118, base: "",
    url: url_SqlVirtualMachinesDelete_594119, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
