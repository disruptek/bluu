
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2016-06-01
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

  OpenApiRestCall_563549 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563549](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563549): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesGet_563771 = ref object of OpenApiRestCall_563549
proc url_BackupEnginesGet_563773(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupEngines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupEnginesGet_563772(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_563949 = path.getOrDefault("vaultName")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "vaultName", valid_563949
  var valid_563950 = path.getOrDefault("subscriptionId")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "subscriptionId", valid_563950
  var valid_563951 = path.getOrDefault("resourceGroupName")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "resourceGroupName", valid_563951
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  var valid_563952 = query.getOrDefault("$skipToken")
  valid_563952 = validateParameter(valid_563952, JString, required = false,
                                 default = nil)
  if valid_563952 != nil:
    section.add "$skipToken", valid_563952
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563953 = query.getOrDefault("api-version")
  valid_563953 = validateParameter(valid_563953, JString, required = true,
                                 default = nil)
  if valid_563953 != nil:
    section.add "api-version", valid_563953
  var valid_563954 = query.getOrDefault("$filter")
  valid_563954 = validateParameter(valid_563954, JString, required = false,
                                 default = nil)
  if valid_563954 != nil:
    section.add "$filter", valid_563954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563977: Call_BackupEnginesGet_563771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  let valid = call_563977.validator(path, query, header, formData, body)
  let scheme = call_563977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563977.url(scheme.get, call_563977.host, call_563977.base,
                         call_563977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563977, url, valid)

proc call*(call_564048: Call_BackupEnginesGet_563771; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_564049 = newJObject()
  var query_564051 = newJObject()
  add(query_564051, "$skipToken", newJString(SkipToken))
  add(path_564049, "vaultName", newJString(vaultName))
  add(query_564051, "api-version", newJString(apiVersion))
  add(path_564049, "subscriptionId", newJString(subscriptionId))
  add(path_564049, "resourceGroupName", newJString(resourceGroupName))
  add(query_564051, "$filter", newJString(Filter))
  result = call_564048.call(path_564049, query_564051, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_563771(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesGet_563772, base: "",
    url: url_BackupEnginesGet_563773, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_564090 = ref object of OpenApiRestCall_563549
proc url_ProtectionContainerRefreshOperationResultsGet_564092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainerRefreshOperationResultsGet_564091(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564093 = path.getOrDefault("vaultName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "vaultName", valid_564093
  var valid_564094 = path.getOrDefault("operationId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "operationId", valid_564094
  var valid_564095 = path.getOrDefault("fabricName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "fabricName", valid_564095
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("resourceGroupName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "resourceGroupName", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ProtectionContainerRefreshOperationResultsGet_564090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ProtectionContainerRefreshOperationResultsGet_564090;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(path_564101, "vaultName", newJString(vaultName))
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "operationId", newJString(operationId))
  add(path_564101, "fabricName", newJString(fabricName))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  add(path_564101, "resourceGroupName", newJString(resourceGroupName))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_564090(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_564091,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_564092,
    schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_564103 = ref object of OpenApiRestCall_563549
proc url_ProtectionContainersGet_564105(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersGet_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564106 = path.getOrDefault("vaultName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "vaultName", valid_564106
  var valid_564107 = path.getOrDefault("fabricName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "fabricName", valid_564107
  var valid_564108 = path.getOrDefault("subscriptionId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "subscriptionId", valid_564108
  var valid_564109 = path.getOrDefault("resourceGroupName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "resourceGroupName", valid_564109
  var valid_564110 = path.getOrDefault("containerName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "containerName", valid_564110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564111 = query.getOrDefault("api-version")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "api-version", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_ProtectionContainersGet_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_ProtectionContainersGet_564103; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services vault.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(path_564114, "vaultName", newJString(vaultName))
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "fabricName", newJString(fabricName))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  add(path_564114, "resourceGroupName", newJString(resourceGroupName))
  add(path_564114, "containerName", newJString(containerName))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_564103(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_564104, base: "",
    url: url_ProtectionContainersGet_564105, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_564116 = ref object of OpenApiRestCall_563549
proc url_ProtectionContainerOperationResultsGet_564118(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainerOperationResultsGet_564117(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564119 = path.getOrDefault("vaultName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "vaultName", valid_564119
  var valid_564120 = path.getOrDefault("operationId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "operationId", valid_564120
  var valid_564121 = path.getOrDefault("fabricName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "fabricName", valid_564121
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  var valid_564123 = path.getOrDefault("resourceGroupName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceGroupName", valid_564123
  var valid_564124 = path.getOrDefault("containerName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "containerName", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_ProtectionContainerOperationResultsGet_564116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the container.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_ProtectionContainerOperationResultsGet_564116;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          containerName: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Gets the result of any operation on the container.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(path_564128, "vaultName", newJString(vaultName))
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "operationId", newJString(operationId))
  add(path_564128, "fabricName", newJString(fabricName))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  add(path_564128, "containerName", newJString(containerName))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_564116(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_564117, base: "",
    url: url_ProtectionContainerOperationResultsGet_564118,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_564145 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemsCreateOrUpdate_564147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsCreateOrUpdate_564146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564165 = path.getOrDefault("vaultName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "vaultName", valid_564165
  var valid_564166 = path.getOrDefault("fabricName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "fabricName", valid_564166
  var valid_564167 = path.getOrDefault("protectedItemName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "protectedItemName", valid_564167
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("containerName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "containerName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   resourceProtectedItem: JObject (required)
  ##                        : The resource backup item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_ProtectedItemsCreateOrUpdate_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_ProtectedItemsCreateOrUpdate_564145;
          vaultName: string; apiVersion: string; fabricName: string;
          protectedItemName: string; subscriptionId: string;
          resourceProtectedItem: JsonNode; resourceGroupName: string;
          containerName: string): Recallable =
  ## protectedItemsCreateOrUpdate
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceProtectedItem: JObject (required)
  ##                        : The resource backup item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  var body_564177 = newJObject()
  add(path_564175, "vaultName", newJString(vaultName))
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "fabricName", newJString(fabricName))
  add(path_564175, "protectedItemName", newJString(protectedItemName))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  if resourceProtectedItem != nil:
    body_564177 = resourceProtectedItem
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  add(path_564175, "containerName", newJString(containerName))
  result = call_564174.call(path_564175, query_564176, nil, nil, body_564177)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_564145(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_564146, base: "",
    url: url_ProtectedItemsCreateOrUpdate_564147, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_564130 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemsGet_564132(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsGet_564131(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item name used in this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564133 = path.getOrDefault("vaultName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "vaultName", valid_564133
  var valid_564134 = path.getOrDefault("fabricName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "fabricName", valid_564134
  var valid_564135 = path.getOrDefault("protectedItemName")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "protectedItemName", valid_564135
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  var valid_564138 = path.getOrDefault("containerName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "containerName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  var valid_564140 = query.getOrDefault("$filter")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "$filter", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_ProtectedItemsGet_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_ProtectedItemsGet_564130; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item name used in this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   Filter: string
  ##         : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(path_564143, "vaultName", newJString(vaultName))
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "fabricName", newJString(fabricName))
  add(path_564143, "protectedItemName", newJString(protectedItemName))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  add(path_564143, "resourceGroupName", newJString(resourceGroupName))
  add(path_564143, "containerName", newJString(containerName))
  add(query_564144, "$filter", newJString(Filter))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_564130(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_564131, base: "",
    url: url_ProtectedItemsGet_564132, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_564178 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemsDelete_564180(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsDelete_564179(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be deleted.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564181 = path.getOrDefault("vaultName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "vaultName", valid_564181
  var valid_564182 = path.getOrDefault("fabricName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "fabricName", valid_564182
  var valid_564183 = path.getOrDefault("protectedItemName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "protectedItemName", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  var valid_564186 = path.getOrDefault("containerName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "containerName", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_ProtectedItemsDelete_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_ProtectedItemsDelete_564178; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(path_564190, "vaultName", newJString(vaultName))
  add(query_564191, "api-version", newJString(apiVersion))
  add(path_564190, "fabricName", newJString(fabricName))
  add(path_564190, "protectedItemName", newJString(protectedItemName))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  add(path_564190, "containerName", newJString(containerName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_564178(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_564179, base: "",
    url: url_ProtectedItemsDelete_564180, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_564192 = ref object of OpenApiRestCall_563549
proc url_BackupsTrigger_564194(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsTrigger_564193(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this POST operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564195 = path.getOrDefault("vaultName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "vaultName", valid_564195
  var valid_564196 = path.getOrDefault("fabricName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "fabricName", valid_564196
  var valid_564197 = path.getOrDefault("protectedItemName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "protectedItemName", valid_564197
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("containerName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "containerName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceBackupRequest: JObject (required)
  ##                        : The resource backup request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_BackupsTrigger_564192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_BackupsTrigger_564192; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          resourceBackupRequest: JsonNode): Recallable =
  ## backupsTrigger
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this POST operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   resourceBackupRequest: JObject (required)
  ##                        : The resource backup request.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  var body_564207 = newJObject()
  add(path_564205, "vaultName", newJString(vaultName))
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "fabricName", newJString(fabricName))
  add(path_564205, "protectedItemName", newJString(protectedItemName))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(path_564205, "containerName", newJString(containerName))
  if resourceBackupRequest != nil:
    body_564207 = resourceBackupRequest
  result = call_564204.call(path_564205, query_564206, nil, nil, body_564207)

var backupsTrigger* = Call_BackupsTrigger_564192(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_564193, base: "", url: url_BackupsTrigger_564194,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_564208 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemOperationResultsGet_564210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemOperationResultsGet_564209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564211 = path.getOrDefault("vaultName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "vaultName", valid_564211
  var valid_564212 = path.getOrDefault("operationId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "operationId", valid_564212
  var valid_564213 = path.getOrDefault("fabricName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "fabricName", valid_564213
  var valid_564214 = path.getOrDefault("protectedItemName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "protectedItemName", valid_564214
  var valid_564215 = path.getOrDefault("subscriptionId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "subscriptionId", valid_564215
  var valid_564216 = path.getOrDefault("resourceGroupName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "resourceGroupName", valid_564216
  var valid_564217 = path.getOrDefault("containerName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "containerName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_ProtectedItemOperationResultsGet_564208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the backup item.
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_ProtectedItemOperationResultsGet_564208;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; protectedItemName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Gets the result of any operation on the backup item.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(path_564221, "vaultName", newJString(vaultName))
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "operationId", newJString(operationId))
  add(path_564221, "fabricName", newJString(fabricName))
  add(path_564221, "protectedItemName", newJString(protectedItemName))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "resourceGroupName", newJString(resourceGroupName))
  add(path_564221, "containerName", newJString(containerName))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_564208(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_564209, base: "",
    url: url_ProtectedItemOperationResultsGet_564210, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_564223 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemOperationStatusesGet_564225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/operationsStatus/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemOperationStatusesGet_564224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564226 = path.getOrDefault("vaultName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "vaultName", valid_564226
  var valid_564227 = path.getOrDefault("operationId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "operationId", valid_564227
  var valid_564228 = path.getOrDefault("fabricName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "fabricName", valid_564228
  var valid_564229 = path.getOrDefault("protectedItemName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "protectedItemName", valid_564229
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  var valid_564232 = path.getOrDefault("containerName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "containerName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_ProtectedItemOperationStatusesGet_564223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_ProtectedItemOperationStatusesGet_564223;
          vaultName: string; apiVersion: string; operationId: string;
          fabricName: string; protectedItemName: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(path_564236, "vaultName", newJString(vaultName))
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "operationId", newJString(operationId))
  add(path_564236, "fabricName", newJString(fabricName))
  add(path_564236, "protectedItemName", newJString(protectedItemName))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "containerName", newJString(containerName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_564223(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_564224, base: "",
    url: url_ProtectedItemOperationStatusesGet_564225, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_564238 = ref object of OpenApiRestCall_563549
proc url_RecoveryPointsList_564240(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsList_564239(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564241 = path.getOrDefault("vaultName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "vaultName", valid_564241
  var valid_564242 = path.getOrDefault("fabricName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "fabricName", valid_564242
  var valid_564243 = path.getOrDefault("protectedItemName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "protectedItemName", valid_564243
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  var valid_564246 = path.getOrDefault("containerName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "containerName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "api-version", valid_564247
  var valid_564248 = query.getOrDefault("$filter")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "$filter", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_RecoveryPointsList_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_RecoveryPointsList_564238; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          subscriptionId: string; resourceGroupName: string; containerName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   Filter: string
  ##         : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  add(path_564251, "vaultName", newJString(vaultName))
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "fabricName", newJString(fabricName))
  add(path_564251, "protectedItemName", newJString(protectedItemName))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  add(path_564251, "containerName", newJString(containerName))
  add(query_564252, "$filter", newJString(Filter))
  result = call_564250.call(path_564251, query_564252, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_564238(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_564239, base: "",
    url: url_RecoveryPointsList_564240, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_564253 = ref object of OpenApiRestCall_563549
proc url_RecoveryPointsGet_564255(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsGet_564254(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   recoveryPointId: JString (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with backup item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564256 = path.getOrDefault("vaultName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "vaultName", valid_564256
  var valid_564257 = path.getOrDefault("fabricName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "fabricName", valid_564257
  var valid_564258 = path.getOrDefault("protectedItemName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "protectedItemName", valid_564258
  var valid_564259 = path.getOrDefault("recoveryPointId")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "recoveryPointId", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  var valid_564262 = path.getOrDefault("containerName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "containerName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_RecoveryPointsGet_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_RecoveryPointsGet_564253; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          recoveryPointId: string; subscriptionId: string;
          resourceGroupName: string; containerName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   recoveryPointId: string (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with backup item.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(path_564266, "vaultName", newJString(vaultName))
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "fabricName", newJString(fabricName))
  add(path_564266, "protectedItemName", newJString(protectedItemName))
  add(path_564266, "recoveryPointId", newJString(recoveryPointId))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  add(path_564266, "containerName", newJString(containerName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_564253(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_564254, base: "",
    url: url_RecoveryPointsGet_564255, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_564268 = ref object of OpenApiRestCall_563549
proc url_ItemLevelRecoveryConnectionsProvision_564270(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/provisionInstantItemRecovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ItemLevelRecoveryConnectionsProvision_564269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564271 = path.getOrDefault("vaultName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "vaultName", valid_564271
  var valid_564272 = path.getOrDefault("fabricName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "fabricName", valid_564272
  var valid_564273 = path.getOrDefault("protectedItemName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "protectedItemName", valid_564273
  var valid_564274 = path.getOrDefault("recoveryPointId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "recoveryPointId", valid_564274
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("resourceGroupName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceGroupName", valid_564276
  var valid_564277 = path.getOrDefault("containerName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "containerName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceILRRequest: JObject (required)
  ##                     : The resource Item Level Recovery (ILR) request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_ItemLevelRecoveryConnectionsProvision_564268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_ItemLevelRecoveryConnectionsProvision_564268;
          vaultName: string; resourceILRRequest: JsonNode; apiVersion: string;
          fabricName: string; protectedItemName: string; recoveryPointId: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   resourceILRRequest: JObject (required)
  ##                     : The resource Item Level Recovery (ILR) request.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  var body_564284 = newJObject()
  add(path_564282, "vaultName", newJString(vaultName))
  if resourceILRRequest != nil:
    body_564284 = resourceILRRequest
  add(query_564283, "api-version", newJString(apiVersion))
  add(path_564282, "fabricName", newJString(fabricName))
  add(path_564282, "protectedItemName", newJString(protectedItemName))
  add(path_564282, "recoveryPointId", newJString(recoveryPointId))
  add(path_564282, "subscriptionId", newJString(subscriptionId))
  add(path_564282, "resourceGroupName", newJString(resourceGroupName))
  add(path_564282, "containerName", newJString(containerName))
  result = call_564281.call(path_564282, query_564283, nil, nil, body_564284)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_564268(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_564269, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_564270, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_564285 = ref object of OpenApiRestCall_563549
proc url_RestoresTrigger_564287(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestoresTrigger_564286(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be restored.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564288 = path.getOrDefault("vaultName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "vaultName", valid_564288
  var valid_564289 = path.getOrDefault("fabricName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "fabricName", valid_564289
  var valid_564290 = path.getOrDefault("protectedItemName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "protectedItemName", valid_564290
  var valid_564291 = path.getOrDefault("recoveryPointId")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "recoveryPointId", valid_564291
  var valid_564292 = path.getOrDefault("subscriptionId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "subscriptionId", valid_564292
  var valid_564293 = path.getOrDefault("resourceGroupName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "resourceGroupName", valid_564293
  var valid_564294 = path.getOrDefault("containerName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "containerName", valid_564294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564295 = query.getOrDefault("api-version")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "api-version", valid_564295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceRestoreRequest: JObject (required)
  ##                         : The resource restore request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_RestoresTrigger_564285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_RestoresTrigger_564285; vaultName: string;
          apiVersion: string; fabricName: string; protectedItemName: string;
          recoveryPointId: string; subscriptionId: string;
          resourceGroupName: string; containerName: string;
          resourceRestoreRequest: JsonNode): Recallable =
  ## restoresTrigger
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be restored.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   resourceRestoreRequest: JObject (required)
  ##                         : The resource restore request.
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  var body_564301 = newJObject()
  add(path_564299, "vaultName", newJString(vaultName))
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "fabricName", newJString(fabricName))
  add(path_564299, "protectedItemName", newJString(protectedItemName))
  add(path_564299, "recoveryPointId", newJString(recoveryPointId))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  add(path_564299, "resourceGroupName", newJString(resourceGroupName))
  add(path_564299, "containerName", newJString(containerName))
  if resourceRestoreRequest != nil:
    body_564301 = resourceRestoreRequest
  result = call_564298.call(path_564299, query_564300, nil, nil, body_564301)

var restoresTrigger* = Call_RestoresTrigger_564285(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_564286, base: "", url: url_RestoresTrigger_564287,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_564302 = ref object of OpenApiRestCall_563549
proc url_ItemLevelRecoveryConnectionsRevoke_564304(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "protectedItemName" in path,
        "`protectedItemName` is a required path parameter"
  assert "recoveryPointId" in path, "`recoveryPointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/protectionContainers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/protectedItems/"),
               (kind: VariableSegment, value: "protectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointId"),
               (kind: ConstantSegment, value: "/revokeInstantItemRecovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ItemLevelRecoveryConnectionsRevoke_564303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   recoveryPointId: JString (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564305 = path.getOrDefault("vaultName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "vaultName", valid_564305
  var valid_564306 = path.getOrDefault("fabricName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "fabricName", valid_564306
  var valid_564307 = path.getOrDefault("protectedItemName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "protectedItemName", valid_564307
  var valid_564308 = path.getOrDefault("recoveryPointId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "recoveryPointId", valid_564308
  var valid_564309 = path.getOrDefault("subscriptionId")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "subscriptionId", valid_564309
  var valid_564310 = path.getOrDefault("resourceGroupName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "resourceGroupName", valid_564310
  var valid_564311 = path.getOrDefault("containerName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "containerName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_ItemLevelRecoveryConnectionsRevoke_564302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_ItemLevelRecoveryConnectionsRevoke_564302;
          vaultName: string; apiVersion: string; fabricName: string;
          protectedItemName: string; recoveryPointId: string;
          subscriptionId: string; resourceGroupName: string; containerName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   recoveryPointId: string (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(path_564315, "vaultName", newJString(vaultName))
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "fabricName", newJString(fabricName))
  add(path_564315, "protectedItemName", newJString(protectedItemName))
  add(path_564315, "recoveryPointId", newJString(recoveryPointId))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "containerName", newJString(containerName))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_564302(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_564303, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_564304, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_564317 = ref object of OpenApiRestCall_563549
proc url_ProtectionContainersRefresh_564319(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/refreshContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersRefresh_564318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564320 = path.getOrDefault("vaultName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "vaultName", valid_564320
  var valid_564321 = path.getOrDefault("fabricName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "fabricName", valid_564321
  var valid_564322 = path.getOrDefault("subscriptionId")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "subscriptionId", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_ProtectionContainersRefresh_564317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_ProtectionContainersRefresh_564317; vaultName: string;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## protectionContainersRefresh
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(path_564327, "vaultName", newJString(vaultName))
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "fabricName", newJString(fabricName))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_564317(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_564318, base: "",
    url: url_ProtectionContainersRefresh_564319, schemes: {Scheme.Https})
type
  Call_JobsList_564329 = ref object of OpenApiRestCall_563549
proc url_JobsList_564331(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsList_564330(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564332 = path.getOrDefault("vaultName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "vaultName", valid_564332
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  var valid_564335 = query.getOrDefault("$skipToken")
  valid_564335 = validateParameter(valid_564335, JString, required = false,
                                 default = nil)
  if valid_564335 != nil:
    section.add "$skipToken", valid_564335
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  var valid_564337 = query.getOrDefault("$filter")
  valid_564337 = validateParameter(valid_564337, JString, required = false,
                                 default = nil)
  if valid_564337 != nil:
    section.add "$filter", valid_564337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_JobsList_564329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_JobsList_564329; vaultName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## jobsList
  ## Provides a pageable list of jobs.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "$skipToken", newJString(SkipToken))
  add(path_564340, "vaultName", newJString(vaultName))
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  add(path_564340, "resourceGroupName", newJString(resourceGroupName))
  add(query_564341, "$filter", newJString(Filter))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var jobsList* = Call_JobsList_564329(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
                                  validator: validate_JobsList_564330, base: "",
                                  url: url_JobsList_564331,
                                  schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_564342 = ref object of OpenApiRestCall_563549
proc url_ExportJobsOperationResultsGet_564344(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportJobsOperationResultsGet_564343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with the export job.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564345 = path.getOrDefault("vaultName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "vaultName", valid_564345
  var valid_564346 = path.getOrDefault("operationId")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "operationId", valid_564346
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564349 = query.getOrDefault("api-version")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "api-version", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_ExportJobsOperationResultsGet_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_ExportJobsOperationResultsGet_564342;
          vaultName: string; apiVersion: string; operationId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## exportJobsOperationResultsGet
  ## Gets the result of the operation triggered by the ExportJob API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The ID associated with the export job.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(path_564352, "vaultName", newJString(vaultName))
  add(query_564353, "api-version", newJString(apiVersion))
  add(path_564352, "operationId", newJString(operationId))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var exportJobsOperationResultsGet* = Call_ExportJobsOperationResultsGet_564342(
    name: "exportJobsOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/operationResults/{operationId}",
    validator: validate_ExportJobsOperationResultsGet_564343, base: "",
    url: url_ExportJobsOperationResultsGet_564344, schemes: {Scheme.Https})
type
  Call_JobDetailsGet_564354 = ref object of OpenApiRestCall_563549
proc url_JobDetailsGet_564356(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobDetailsGet_564355(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets extended information associated with the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: JString (required)
  ##          : Name of the job associated with this GET operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564357 = path.getOrDefault("vaultName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "vaultName", valid_564357
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("jobName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "jobName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_JobDetailsGet_564354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets extended information associated with the job.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_JobDetailsGet_564354; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobDetailsGet
  ## Gets extended information associated with the job.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: string (required)
  ##          : Name of the job associated with this GET operation.
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(path_564364, "vaultName", newJString(vaultName))
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "subscriptionId", newJString(subscriptionId))
  add(path_564364, "resourceGroupName", newJString(resourceGroupName))
  add(path_564364, "jobName", newJString(jobName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_564354(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_564355, base: "", url: url_JobDetailsGet_564356,
    schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_564366 = ref object of OpenApiRestCall_563549
proc url_JobCancellationsTrigger_564368(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobCancellationsTrigger_564367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564369 = path.getOrDefault("vaultName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "vaultName", valid_564369
  var valid_564370 = path.getOrDefault("subscriptionId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "subscriptionId", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  var valid_564372 = path.getOrDefault("jobName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "jobName", valid_564372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564373 = query.getOrDefault("api-version")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "api-version", valid_564373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564374: Call_JobCancellationsTrigger_564366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  let valid = call_564374.validator(path, query, header, formData, body)
  let scheme = call_564374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564374.url(scheme.get, call_564374.host, call_564374.base,
                         call_564374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564374, url, valid)

proc call*(call_564375: Call_JobCancellationsTrigger_564366; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  var path_564376 = newJObject()
  var query_564377 = newJObject()
  add(path_564376, "vaultName", newJString(vaultName))
  add(query_564377, "api-version", newJString(apiVersion))
  add(path_564376, "subscriptionId", newJString(subscriptionId))
  add(path_564376, "resourceGroupName", newJString(resourceGroupName))
  add(path_564376, "jobName", newJString(jobName))
  result = call_564375.call(path_564376, query_564377, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_564366(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_564367, base: "",
    url: url_JobCancellationsTrigger_564368, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_564378 = ref object of OpenApiRestCall_563549
proc url_JobOperationResultsGet_564380(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobOperationResultsGet_564379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : OperationID associated with this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: JString (required)
  ##          : Job name associated with this GET operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564381 = path.getOrDefault("vaultName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "vaultName", valid_564381
  var valid_564382 = path.getOrDefault("operationId")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "operationId", valid_564382
  var valid_564383 = path.getOrDefault("subscriptionId")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "subscriptionId", valid_564383
  var valid_564384 = path.getOrDefault("resourceGroupName")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "resourceGroupName", valid_564384
  var valid_564385 = path.getOrDefault("jobName")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "jobName", valid_564385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564386 = query.getOrDefault("api-version")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "api-version", valid_564386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_JobOperationResultsGet_564378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation.
  ## 
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_JobOperationResultsGet_564378; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string; jobName: string): Recallable =
  ## jobOperationResultsGet
  ## Gets the result of the operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : OperationID associated with this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   jobName: string (required)
  ##          : Job name associated with this GET operation.
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  add(path_564389, "vaultName", newJString(vaultName))
  add(query_564390, "api-version", newJString(apiVersion))
  add(path_564389, "operationId", newJString(operationId))
  add(path_564389, "subscriptionId", newJString(subscriptionId))
  add(path_564389, "resourceGroupName", newJString(resourceGroupName))
  add(path_564389, "jobName", newJString(jobName))
  result = call_564388.call(path_564389, query_564390, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_564378(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_564379, base: "",
    url: url_JobOperationResultsGet_564380, schemes: {Scheme.Https})
type
  Call_JobsExport_564391 = ref object of OpenApiRestCall_563549
proc url_JobsExport_564393(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupJobsExport")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsExport_564392(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564394 = path.getOrDefault("vaultName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "vaultName", valid_564394
  var valid_564395 = path.getOrDefault("subscriptionId")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "subscriptionId", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  var valid_564398 = query.getOrDefault("$filter")
  valid_564398 = validateParameter(valid_564398, JString, required = false,
                                 default = nil)
  if valid_564398 != nil:
    section.add "$filter", valid_564398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564399: Call_JobsExport_564391; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  let valid = call_564399.validator(path, query, header, formData, body)
  let scheme = call_564399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564399.url(scheme.get, call_564399.host, call_564399.base,
                         call_564399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564399, url, valid)

proc call*(call_564400: Call_JobsExport_564391; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## jobsExport
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_564401 = newJObject()
  var query_564402 = newJObject()
  add(path_564401, "vaultName", newJString(vaultName))
  add(query_564402, "api-version", newJString(apiVersion))
  add(path_564401, "subscriptionId", newJString(subscriptionId))
  add(path_564401, "resourceGroupName", newJString(resourceGroupName))
  add(query_564402, "$filter", newJString(Filter))
  result = call_564400.call(path_564401, query_564402, nil, nil, nil)

var jobsExport* = Call_JobsExport_564391(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_564392,
                                      base: "", url: url_JobsExport_564393,
                                      schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_564403 = ref object of OpenApiRestCall_563549
proc url_BackupOperationResultsGet_564405(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupOperationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupOperationResultsGet_564404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564406 = path.getOrDefault("vaultName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "vaultName", valid_564406
  var valid_564407 = path.getOrDefault("operationId")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "operationId", valid_564407
  var valid_564408 = path.getOrDefault("subscriptionId")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "subscriptionId", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564410 = query.getOrDefault("api-version")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "api-version", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_BackupOperationResultsGet_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_BackupOperationResultsGet_564403; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(path_564413, "vaultName", newJString(vaultName))
  add(query_564414, "api-version", newJString(apiVersion))
  add(path_564413, "operationId", newJString(operationId))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_564403(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_564404, base: "",
    url: url_BackupOperationResultsGet_564405, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_564415 = ref object of OpenApiRestCall_563549
proc url_BackupOperationStatusesGet_564417(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupOperationStatusesGet_564416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564418 = path.getOrDefault("vaultName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "vaultName", valid_564418
  var valid_564419 = path.getOrDefault("operationId")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "operationId", valid_564419
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
  var valid_564421 = path.getOrDefault("resourceGroupName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "resourceGroupName", valid_564421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564422 = query.getOrDefault("api-version")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "api-version", valid_564422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_BackupOperationStatusesGet_564415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_BackupOperationStatusesGet_564415; vaultName: string;
          apiVersion: string; operationId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## backupOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(path_564425, "vaultName", newJString(vaultName))
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "operationId", newJString(operationId))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  add(path_564425, "resourceGroupName", newJString(resourceGroupName))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_564415(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_564416, base: "",
    url: url_BackupOperationStatusesGet_564417, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesList_564427 = ref object of OpenApiRestCall_563549
proc url_ProtectionPoliciesList_564429(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesList_564428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564430 = path.getOrDefault("vaultName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "vaultName", valid_564430
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  var valid_564432 = path.getOrDefault("resourceGroupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceGroupName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  var valid_564434 = query.getOrDefault("$filter")
  valid_564434 = validateParameter(valid_564434, JString, required = false,
                                 default = nil)
  if valid_564434 != nil:
    section.add "$filter", valid_564434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564435: Call_ProtectionPoliciesList_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  let valid = call_564435.validator(path, query, header, formData, body)
  let scheme = call_564435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564435.url(scheme.get, call_564435.host, call_564435.base,
                         call_564435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564435, url, valid)

proc call*(call_564436: Call_ProtectionPoliciesList_564427; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## protectionPoliciesList
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_564437 = newJObject()
  var query_564438 = newJObject()
  add(path_564437, "vaultName", newJString(vaultName))
  add(query_564438, "api-version", newJString(apiVersion))
  add(path_564437, "subscriptionId", newJString(subscriptionId))
  add(path_564437, "resourceGroupName", newJString(resourceGroupName))
  add(query_564438, "$filter", newJString(Filter))
  result = call_564436.call(path_564437, query_564438, nil, nil, nil)

var protectionPoliciesList* = Call_ProtectionPoliciesList_564427(
    name: "protectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_ProtectionPoliciesList_564428, base: "",
    url: url_ProtectionPoliciesList_564429, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_564451 = ref object of OpenApiRestCall_563549
proc url_ProtectionPoliciesCreateOrUpdate_564453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesCreateOrUpdate_564452(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564454 = path.getOrDefault("policyName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "policyName", valid_564454
  var valid_564455 = path.getOrDefault("vaultName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "vaultName", valid_564455
  var valid_564456 = path.getOrDefault("subscriptionId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "subscriptionId", valid_564456
  var valid_564457 = path.getOrDefault("resourceGroupName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "resourceGroupName", valid_564457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564458 = query.getOrDefault("api-version")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "api-version", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resourceProtectionPolicy: JObject (required)
  ##                           : The resource backup policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564460: Call_ProtectionPoliciesCreateOrUpdate_564451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_564460.validator(path, query, header, formData, body)
  let scheme = call_564460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564460.url(scheme.get, call_564460.host, call_564460.base,
                         call_564460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564460, url, valid)

proc call*(call_564461: Call_ProtectionPoliciesCreateOrUpdate_564451;
          policyName: string; vaultName: string; apiVersion: string;
          subscriptionId: string; resourceProtectionPolicy: JsonNode;
          resourceGroupName: string): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   policyName: string (required)
  ##             : The backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceProtectionPolicy: JObject (required)
  ##                           : The resource backup policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564462 = newJObject()
  var query_564463 = newJObject()
  var body_564464 = newJObject()
  add(path_564462, "policyName", newJString(policyName))
  add(path_564462, "vaultName", newJString(vaultName))
  add(query_564463, "api-version", newJString(apiVersion))
  add(path_564462, "subscriptionId", newJString(subscriptionId))
  if resourceProtectionPolicy != nil:
    body_564464 = resourceProtectionPolicy
  add(path_564462, "resourceGroupName", newJString(resourceGroupName))
  result = call_564461.call(path_564462, query_564463, nil, nil, body_564464)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_564451(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_564452, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_564453, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_564439 = ref object of OpenApiRestCall_563549
proc url_ProtectionPoliciesGet_564441(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesGet_564440(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564442 = path.getOrDefault("policyName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "policyName", valid_564442
  var valid_564443 = path.getOrDefault("vaultName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "vaultName", valid_564443
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564446 = query.getOrDefault("api-version")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "api-version", valid_564446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564447: Call_ProtectionPoliciesGet_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_564447.validator(path, query, header, formData, body)
  let scheme = call_564447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564447.url(scheme.get, call_564447.host, call_564447.base,
                         call_564447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564447, url, valid)

proc call*(call_564448: Call_ProtectionPoliciesGet_564439; policyName: string;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## protectionPoliciesGet
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564449 = newJObject()
  var query_564450 = newJObject()
  add(path_564449, "policyName", newJString(policyName))
  add(path_564449, "vaultName", newJString(vaultName))
  add(query_564450, "api-version", newJString(apiVersion))
  add(path_564449, "subscriptionId", newJString(subscriptionId))
  add(path_564449, "resourceGroupName", newJString(resourceGroupName))
  result = call_564448.call(path_564449, query_564450, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_564439(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_564440, base: "",
    url: url_ProtectionPoliciesGet_564441, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_564465 = ref object of OpenApiRestCall_563549
proc url_ProtectionPoliciesDelete_564467(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPoliciesDelete_564466(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564468 = path.getOrDefault("policyName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "policyName", valid_564468
  var valid_564469 = path.getOrDefault("vaultName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "vaultName", valid_564469
  var valid_564470 = path.getOrDefault("subscriptionId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "subscriptionId", valid_564470
  var valid_564471 = path.getOrDefault("resourceGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "resourceGroupName", valid_564471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564472 = query.getOrDefault("api-version")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "api-version", valid_564472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564473: Call_ProtectionPoliciesDelete_564465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_564473.validator(path, query, header, formData, body)
  let scheme = call_564473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564473.url(scheme.get, call_564473.host, call_564473.base,
                         call_564473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564473, url, valid)

proc call*(call_564474: Call_ProtectionPoliciesDelete_564465; policyName: string;
          vaultName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   policyName: string (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564475 = newJObject()
  var query_564476 = newJObject()
  add(path_564475, "policyName", newJString(policyName))
  add(path_564475, "vaultName", newJString(vaultName))
  add(query_564476, "api-version", newJString(apiVersion))
  add(path_564475, "subscriptionId", newJString(subscriptionId))
  add(path_564475, "resourceGroupName", newJString(resourceGroupName))
  result = call_564474.call(path_564475, query_564476, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_564465(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_564466, base: "",
    url: url_ProtectionPoliciesDelete_564467, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_564477 = ref object of OpenApiRestCall_563549
proc url_ProtectionPolicyOperationResultsGet_564479(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/operationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPolicyOperationResultsGet_564478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564480 = path.getOrDefault("policyName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "policyName", valid_564480
  var valid_564481 = path.getOrDefault("vaultName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "vaultName", valid_564481
  var valid_564482 = path.getOrDefault("operationId")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "operationId", valid_564482
  var valid_564483 = path.getOrDefault("subscriptionId")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "subscriptionId", valid_564483
  var valid_564484 = path.getOrDefault("resourceGroupName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "resourceGroupName", valid_564484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564485 = query.getOrDefault("api-version")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "api-version", valid_564485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564486: Call_ProtectionPolicyOperationResultsGet_564477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_564486.validator(path, query, header, formData, body)
  let scheme = call_564486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564486.url(scheme.get, call_564486.host, call_564486.base,
                         call_564486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564486, url, valid)

proc call*(call_564487: Call_ProtectionPolicyOperationResultsGet_564477;
          policyName: string; vaultName: string; apiVersion: string;
          operationId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564488 = newJObject()
  var query_564489 = newJObject()
  add(path_564488, "policyName", newJString(policyName))
  add(path_564488, "vaultName", newJString(vaultName))
  add(query_564489, "api-version", newJString(apiVersion))
  add(path_564488, "operationId", newJString(operationId))
  add(path_564488, "subscriptionId", newJString(subscriptionId))
  add(path_564488, "resourceGroupName", newJString(resourceGroupName))
  result = call_564487.call(path_564488, query_564489, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_564477(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_564478, base: "",
    url: url_ProtectionPolicyOperationResultsGet_564479, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_564490 = ref object of OpenApiRestCall_563549
proc url_ProtectionPolicyOperationStatusesGet_564492(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupPolicies/"),
               (kind: VariableSegment, value: "policyName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionPolicyOperationStatusesGet_564491(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564493 = path.getOrDefault("policyName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "policyName", valid_564493
  var valid_564494 = path.getOrDefault("vaultName")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "vaultName", valid_564494
  var valid_564495 = path.getOrDefault("operationId")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "operationId", valid_564495
  var valid_564496 = path.getOrDefault("subscriptionId")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "subscriptionId", valid_564496
  var valid_564497 = path.getOrDefault("resourceGroupName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "resourceGroupName", valid_564497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564498 = query.getOrDefault("api-version")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "api-version", valid_564498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564499: Call_ProtectionPolicyOperationStatusesGet_564490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_564499.validator(path, query, header, formData, body)
  let scheme = call_564499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564499.url(scheme.get, call_564499.host, call_564499.base,
                         call_564499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564499, url, valid)

proc call*(call_564500: Call_ProtectionPolicyOperationStatusesGet_564490;
          policyName: string; vaultName: string; apiVersion: string;
          operationId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  var path_564501 = newJObject()
  var query_564502 = newJObject()
  add(path_564501, "policyName", newJString(policyName))
  add(path_564501, "vaultName", newJString(vaultName))
  add(query_564502, "api-version", newJString(apiVersion))
  add(path_564501, "operationId", newJString(operationId))
  add(path_564501, "subscriptionId", newJString(subscriptionId))
  add(path_564501, "resourceGroupName", newJString(resourceGroupName))
  result = call_564500.call(path_564501, query_564502, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_564490(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_564491, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_564492, schemes: {Scheme.Https})
type
  Call_ProtectableItemsList_564503 = ref object of OpenApiRestCall_563549
proc url_ProtectableItemsList_564505(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectableItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectableItemsList_564504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564506 = path.getOrDefault("vaultName")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "vaultName", valid_564506
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  var valid_564508 = path.getOrDefault("resourceGroupName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "resourceGroupName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  var valid_564509 = query.getOrDefault("$skipToken")
  valid_564509 = validateParameter(valid_564509, JString, required = false,
                                 default = nil)
  if valid_564509 != nil:
    section.add "$skipToken", valid_564509
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  var valid_564511 = query.getOrDefault("$filter")
  valid_564511 = validateParameter(valid_564511, JString, required = false,
                                 default = nil)
  if valid_564511 != nil:
    section.add "$filter", valid_564511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564512: Call_ProtectableItemsList_564503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  let valid = call_564512.validator(path, query, header, formData, body)
  let scheme = call_564512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564512.url(scheme.get, call_564512.host, call_564512.base,
                         call_564512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564512, url, valid)

proc call*(call_564513: Call_ProtectableItemsList_564503; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectableItemsList
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_564514 = newJObject()
  var query_564515 = newJObject()
  add(query_564515, "$skipToken", newJString(SkipToken))
  add(path_564514, "vaultName", newJString(vaultName))
  add(query_564515, "api-version", newJString(apiVersion))
  add(path_564514, "subscriptionId", newJString(subscriptionId))
  add(path_564514, "resourceGroupName", newJString(resourceGroupName))
  add(query_564515, "$filter", newJString(Filter))
  result = call_564513.call(path_564514, query_564515, nil, nil, nil)

var protectableItemsList* = Call_ProtectableItemsList_564503(
    name: "protectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_ProtectableItemsList_564504, base: "",
    url: url_ProtectableItemsList_564505, schemes: {Scheme.Https})
type
  Call_ProtectedItemsList_564516 = ref object of OpenApiRestCall_563549
proc url_ProtectedItemsList_564518(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectedItemsList_564517(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564519 = path.getOrDefault("vaultName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "vaultName", valid_564519
  var valid_564520 = path.getOrDefault("subscriptionId")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "subscriptionId", valid_564520
  var valid_564521 = path.getOrDefault("resourceGroupName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "resourceGroupName", valid_564521
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             :  The Skip Token filter.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  var valid_564522 = query.getOrDefault("$skipToken")
  valid_564522 = validateParameter(valid_564522, JString, required = false,
                                 default = nil)
  if valid_564522 != nil:
    section.add "$skipToken", valid_564522
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564523 = query.getOrDefault("api-version")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "api-version", valid_564523
  var valid_564524 = query.getOrDefault("$filter")
  valid_564524 = validateParameter(valid_564524, JString, required = false,
                                 default = nil)
  if valid_564524 != nil:
    section.add "$filter", valid_564524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564525: Call_ProtectedItemsList_564516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  let valid = call_564525.validator(path, query, header, formData, body)
  let scheme = call_564525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564525.url(scheme.get, call_564525.host, call_564525.base,
                         call_564525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564525, url, valid)

proc call*(call_564526: Call_ProtectedItemsList_564516; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectedItemsList
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ##   SkipToken: string
  ##            :  The Skip Token filter.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_564527 = newJObject()
  var query_564528 = newJObject()
  add(query_564528, "$skipToken", newJString(SkipToken))
  add(path_564527, "vaultName", newJString(vaultName))
  add(query_564528, "api-version", newJString(apiVersion))
  add(path_564527, "subscriptionId", newJString(subscriptionId))
  add(path_564527, "resourceGroupName", newJString(resourceGroupName))
  add(query_564528, "$filter", newJString(Filter))
  result = call_564526.call(path_564527, query_564528, nil, nil, nil)

var protectedItemsList* = Call_ProtectedItemsList_564516(
    name: "protectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_ProtectedItemsList_564517, base: "",
    url: url_ProtectedItemsList_564518, schemes: {Scheme.Https})
type
  Call_ProtectionContainersList_564529 = ref object of OpenApiRestCall_563549
proc url_ProtectionContainersList_564531(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersList_564530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `vaultName` field"
  var valid_564532 = path.getOrDefault("vaultName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "vaultName", valid_564532
  var valid_564533 = path.getOrDefault("subscriptionId")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "subscriptionId", valid_564533
  var valid_564534 = path.getOrDefault("resourceGroupName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "resourceGroupName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "api-version", valid_564535
  var valid_564536 = query.getOrDefault("$filter")
  valid_564536 = validateParameter(valid_564536, JString, required = false,
                                 default = nil)
  if valid_564536 != nil:
    section.add "$filter", valid_564536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564537: Call_ProtectionContainersList_564529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  let valid = call_564537.validator(path, query, header, formData, body)
  let scheme = call_564537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564537.url(scheme.get, call_564537.host, call_564537.base,
                         call_564537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564537, url, valid)

proc call*(call_564538: Call_ProtectionContainersList_564529; vaultName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Filter: string = ""): Recallable =
  ## protectionContainersList
  ## Lists the containers registered to the Recovery Services vault.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_564539 = newJObject()
  var query_564540 = newJObject()
  add(path_564539, "vaultName", newJString(vaultName))
  add(query_564540, "api-version", newJString(apiVersion))
  add(path_564539, "subscriptionId", newJString(subscriptionId))
  add(path_564539, "resourceGroupName", newJString(resourceGroupName))
  add(query_564540, "$filter", newJString(Filter))
  result = call_564538.call(path_564539, query_564540, nil, nil, nil)

var protectionContainersList* = Call_ProtectionContainersList_564529(
    name: "protectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_ProtectionContainersList_564530, base: "",
    url: url_ProtectionContainersList_564531, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
