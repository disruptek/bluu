
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593422 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593422](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593422): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesGet_593644 = ref object of OpenApiRestCall_593422
proc url_BackupEnginesGet_593646(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesGet_593645(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593820 = path.getOrDefault("resourceGroupName")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "resourceGroupName", valid_593820
  var valid_593821 = path.getOrDefault("subscriptionId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "subscriptionId", valid_593821
  var valid_593822 = path.getOrDefault("vaultName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "vaultName", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  var valid_593824 = query.getOrDefault("$skipToken")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "$skipToken", valid_593824
  var valid_593825 = query.getOrDefault("$filter")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "$filter", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_BackupEnginesGet_593644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_BackupEnginesGet_593644; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## The backup management servers registered to a Recovery Services vault. This returns a pageable list of servers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : Use this filter to choose the specific backup management server. backupManagementType { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(path_593920, "resourceGroupName", newJString(resourceGroupName))
  add(query_593922, "api-version", newJString(apiVersion))
  add(path_593920, "subscriptionId", newJString(subscriptionId))
  add(path_593920, "vaultName", newJString(vaultName))
  add(query_593922, "$skipToken", newJString(SkipToken))
  add(query_593922, "$filter", newJString(Filter))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_593644(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesGet_593645, base: "",
    url: url_BackupEnginesGet_593646, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_593961 = ref object of OpenApiRestCall_593422
proc url_ProtectionContainerRefreshOperationResultsGet_593963(protocol: Scheme;
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

proc validate_ProtectionContainerRefreshOperationResultsGet_593962(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_593964 = path.getOrDefault("fabricName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "fabricName", valid_593964
  var valid_593965 = path.getOrDefault("resourceGroupName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceGroupName", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  var valid_593967 = path.getOrDefault("vaultName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "vaultName", valid_593967
  var valid_593968 = path.getOrDefault("operationId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "operationId", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_593970: Call_ProtectionContainerRefreshOperationResultsGet_593961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_ProtectionContainerRefreshOperationResultsGet_593961;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string; operationId: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(path_593972, "fabricName", newJString(fabricName))
  add(path_593972, "resourceGroupName", newJString(resourceGroupName))
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "subscriptionId", newJString(subscriptionId))
  add(path_593972, "vaultName", newJString(vaultName))
  add(path_593972, "operationId", newJString(operationId))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_593961(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_593962,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_593963,
    schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_593974 = ref object of OpenApiRestCall_593422
proc url_ProtectionContainersGet_593976(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionContainersGet_593975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_593977 = path.getOrDefault("fabricName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "fabricName", valid_593977
  var valid_593978 = path.getOrDefault("resourceGroupName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceGroupName", valid_593978
  var valid_593979 = path.getOrDefault("containerName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "containerName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  var valid_593981 = path.getOrDefault("vaultName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "vaultName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ProtectionContainersGet_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services vault.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ProtectionContainersGet_593974; fabricName: string;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services vault.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "fabricName", newJString(fabricName))
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "containerName", newJString(containerName))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  add(path_593985, "vaultName", newJString(vaultName))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_593974(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_593975, base: "",
    url: url_ProtectionContainersGet_593976, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_593987 = ref object of OpenApiRestCall_593422
proc url_ProtectionContainerOperationResultsGet_593989(protocol: Scheme;
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

proc validate_ProtectionContainerOperationResultsGet_593988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The operation ID used for this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_593990 = path.getOrDefault("fabricName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "fabricName", valid_593990
  var valid_593991 = path.getOrDefault("resourceGroupName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "resourceGroupName", valid_593991
  var valid_593992 = path.getOrDefault("containerName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "containerName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("vaultName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "vaultName", valid_593994
  var valid_593995 = path.getOrDefault("operationId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "operationId", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_ProtectionContainerOperationResultsGet_593987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the container.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_ProtectionContainerOperationResultsGet_593987;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          operationId: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Gets the result of any operation on the container.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name used for this GET operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The operation ID used for this GET operation.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "fabricName", newJString(fabricName))
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "containerName", newJString(containerName))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "vaultName", newJString(vaultName))
  add(path_593999, "operationId", newJString(operationId))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_593987(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_593988, base: "",
    url: url_ProtectionContainerOperationResultsGet_593989,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_594016 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemsCreateOrUpdate_594018(protocol: Scheme; host: string;
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

proc validate_ProtectedItemsCreateOrUpdate_594017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594036 = path.getOrDefault("fabricName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "fabricName", valid_594036
  var valid_594037 = path.getOrDefault("protectedItemName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "protectedItemName", valid_594037
  var valid_594038 = path.getOrDefault("resourceGroupName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "resourceGroupName", valid_594038
  var valid_594039 = path.getOrDefault("containerName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "containerName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("vaultName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "vaultName", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
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

proc call*(call_594044: Call_ProtectedItemsCreateOrUpdate_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_ProtectedItemsCreateOrUpdate_594016;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          resourceProtectedItem: JsonNode; vaultName: string): Recallable =
  ## protectedItemsCreateOrUpdate
  ## This operation enables an item to be backed up, or modifies the existing backup policy information for an item that has been backed up. This is an asynchronous operation. To learn the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceProtectedItem: JObject (required)
  ##                        : The resource backup item.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  var body_594048 = newJObject()
  add(path_594046, "fabricName", newJString(fabricName))
  add(path_594046, "protectedItemName", newJString(protectedItemName))
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "containerName", newJString(containerName))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  if resourceProtectedItem != nil:
    body_594048 = resourceProtectedItem
  add(path_594046, "vaultName", newJString(vaultName))
  result = call_594045.call(path_594046, query_594047, nil, nil, body_594048)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_594016(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_594017, base: "",
    url: url_ProtectedItemsCreateOrUpdate_594018, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_594001 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemsGet_594003(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsGet_594002(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item name used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594004 = path.getOrDefault("fabricName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "fabricName", valid_594004
  var valid_594005 = path.getOrDefault("protectedItemName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "protectedItemName", valid_594005
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("containerName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "containerName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("vaultName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "vaultName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  var valid_594011 = query.getOrDefault("$filter")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "$filter", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_ProtectedItemsGet_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_ProtectedItemsGet_594001; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backup item. This is an asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item name used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : expand eq {extendedInfo}. This filter enables you to choose (or filter) specific items in the list of backup items.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(path_594014, "fabricName", newJString(fabricName))
  add(path_594014, "protectedItemName", newJString(protectedItemName))
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "containerName", newJString(containerName))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  add(path_594014, "vaultName", newJString(vaultName))
  add(query_594015, "$filter", newJString(Filter))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_594001(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_594002, base: "",
    url: url_ProtectedItemsGet_594003, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_594049 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemsDelete_594051(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsDelete_594050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594052 = path.getOrDefault("fabricName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "fabricName", valid_594052
  var valid_594053 = path.getOrDefault("protectedItemName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "protectedItemName", valid_594053
  var valid_594054 = path.getOrDefault("resourceGroupName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceGroupName", valid_594054
  var valid_594055 = path.getOrDefault("containerName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "containerName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("vaultName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "vaultName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ProtectedItemsDelete_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ProtectedItemsDelete_594049; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable the backup job for an item within a container. This is an asynchronous operation. To learn the status of the request, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             :  The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "fabricName", newJString(fabricName))
  add(path_594061, "protectedItemName", newJString(protectedItemName))
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "containerName", newJString(containerName))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "vaultName", newJString(vaultName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_594049(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_594050, base: "",
    url: url_ProtectedItemsDelete_594051, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_594063 = ref object of OpenApiRestCall_593422
proc url_BackupsTrigger_594065(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsTrigger_594064(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this POST operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594066 = path.getOrDefault("fabricName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fabricName", valid_594066
  var valid_594067 = path.getOrDefault("protectedItemName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "protectedItemName", valid_594067
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("containerName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "containerName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("vaultName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "vaultName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
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

proc call*(call_594074: Call_BackupsTrigger_594063; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_BackupsTrigger_594063; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; resourceBackupRequest: JsonNode;
          subscriptionId: string; vaultName: string): Recallable =
  ## backupsTrigger
  ## Triggers the backup job for the specified backup item. This is an asynchronous operation. To know the status of the operation, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this POST operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   resourceBackupRequest: JObject (required)
  ##                        : The resource backup request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  var body_594078 = newJObject()
  add(path_594076, "fabricName", newJString(fabricName))
  add(path_594076, "protectedItemName", newJString(protectedItemName))
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "containerName", newJString(containerName))
  if resourceBackupRequest != nil:
    body_594078 = resourceBackupRequest
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  add(path_594076, "vaultName", newJString(vaultName))
  result = call_594075.call(path_594076, query_594077, nil, nil, body_594078)

var backupsTrigger* = Call_BackupsTrigger_594063(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_594064, base: "", url: url_BackupsTrigger_594065,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_594079 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemOperationResultsGet_594081(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationResultsGet_594080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594082 = path.getOrDefault("fabricName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "fabricName", valid_594082
  var valid_594083 = path.getOrDefault("protectedItemName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "protectedItemName", valid_594083
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("containerName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "containerName", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("vaultName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "vaultName", valid_594087
  var valid_594088 = path.getOrDefault("operationId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "operationId", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_ProtectedItemOperationResultsGet_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the result of any operation on the backup item.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_ProtectedItemOperationResultsGet_594079;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Gets the result of any operation on the backup item.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "fabricName", newJString(fabricName))
  add(path_594092, "protectedItemName", newJString(protectedItemName))
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "containerName", newJString(containerName))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(path_594092, "vaultName", newJString(vaultName))
  add(path_594092, "operationId", newJString(operationId))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_594079(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_594080, base: "",
    url: url_ProtectedItemOperationResultsGet_594081, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_594094 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemOperationStatusesGet_594096(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationStatusesGet_594095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The OperationID used in this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594097 = path.getOrDefault("fabricName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "fabricName", valid_594097
  var valid_594098 = path.getOrDefault("protectedItemName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "protectedItemName", valid_594098
  var valid_594099 = path.getOrDefault("resourceGroupName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "resourceGroupName", valid_594099
  var valid_594100 = path.getOrDefault("containerName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "containerName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("vaultName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "vaultName", valid_594102
  var valid_594103 = path.getOrDefault("operationId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "operationId", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_ProtectedItemOperationStatusesGet_594094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ProtectedItemOperationStatusesGet_594094;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be: In progress, Completed, or Failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The OperationID used in this GET operation.
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "fabricName", newJString(fabricName))
  add(path_594107, "protectedItemName", newJString(protectedItemName))
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "containerName", newJString(containerName))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "vaultName", newJString(vaultName))
  add(path_594107, "operationId", newJString(operationId))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_594094(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_594095, base: "",
    url: url_ProtectedItemOperationStatusesGet_594096, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_594109 = ref object of OpenApiRestCall_593422
proc url_RecoveryPointsList_594111(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsList_594110(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594112 = path.getOrDefault("fabricName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fabricName", valid_594112
  var valid_594113 = path.getOrDefault("protectedItemName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "protectedItemName", valid_594113
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("containerName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "containerName", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  var valid_594117 = path.getOrDefault("vaultName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "vaultName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  var valid_594119 = query.getOrDefault("$filter")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "$filter", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_RecoveryPointsList_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_RecoveryPointsList_594109; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the recovery points, or backup copies, for the specified backup item.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerName: string (required)
  ##                : The container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : startDate eq {yyyy-mm-dd hh:mm:ss PM} and endDate { yyyy-mm-dd hh:mm:ss PM}.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(path_594122, "fabricName", newJString(fabricName))
  add(path_594122, "protectedItemName", newJString(protectedItemName))
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "containerName", newJString(containerName))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "vaultName", newJString(vaultName))
  add(query_594123, "$filter", newJString(Filter))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_594109(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_594110, base: "",
    url: url_RecoveryPointsList_594111, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_594124 = ref object of OpenApiRestCall_593422
proc url_RecoveryPointsGet_594126(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_594125(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   containerName: JString (required)
  ##                : The container name associated with backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594127 = path.getOrDefault("fabricName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "fabricName", valid_594127
  var valid_594128 = path.getOrDefault("protectedItemName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "protectedItemName", valid_594128
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("recoveryPointId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "recoveryPointId", valid_594130
  var valid_594131 = path.getOrDefault("containerName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "containerName", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  var valid_594133 = path.getOrDefault("vaultName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "vaultName", valid_594133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_RecoveryPointsGet_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_RecoveryPointsGet_594124; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the backup data for the RecoveryPointID. This is an asynchronous operation. To learn the status of the operation, call the GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with backup item.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item used in this GET operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The RecoveryPointID associated with this GET operation.
  ##   containerName: string (required)
  ##                : The container name associated with backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "fabricName", newJString(fabricName))
  add(path_594137, "protectedItemName", newJString(protectedItemName))
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "recoveryPointId", newJString(recoveryPointId))
  add(path_594137, "containerName", newJString(containerName))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "vaultName", newJString(vaultName))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_594124(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_594125, base: "",
    url: url_RecoveryPointsGet_594126, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_594139 = ref object of OpenApiRestCall_593422
proc url_ItemLevelRecoveryConnectionsProvision_594141(protocol: Scheme;
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

proc validate_ItemLevelRecoveryConnectionsProvision_594140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594142 = path.getOrDefault("fabricName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "fabricName", valid_594142
  var valid_594143 = path.getOrDefault("protectedItemName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "protectedItemName", valid_594143
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("recoveryPointId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "recoveryPointId", valid_594145
  var valid_594146 = path.getOrDefault("containerName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "containerName", valid_594146
  var valid_594147 = path.getOrDefault("subscriptionId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "subscriptionId", valid_594147
  var valid_594148 = path.getOrDefault("vaultName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "vaultName", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "api-version", valid_594149
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

proc call*(call_594151: Call_ItemLevelRecoveryConnectionsProvision_594139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_ItemLevelRecoveryConnectionsProvision_594139;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; resourceILRRequest: JsonNode; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens File Explorer which displays the recoverable files and folders. This is an asynchronous operation. To get the provisioning status, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup item whose files or folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for backup data. The iSCSI connection will be provisioned for this backup data.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceILRRequest: JObject (required)
  ##                     : The resource Item Level Recovery (ILR) request.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  var body_594155 = newJObject()
  add(path_594153, "fabricName", newJString(fabricName))
  add(path_594153, "protectedItemName", newJString(protectedItemName))
  add(path_594153, "resourceGroupName", newJString(resourceGroupName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "recoveryPointId", newJString(recoveryPointId))
  add(path_594153, "containerName", newJString(containerName))
  add(path_594153, "subscriptionId", newJString(subscriptionId))
  if resourceILRRequest != nil:
    body_594155 = resourceILRRequest
  add(path_594153, "vaultName", newJString(vaultName))
  result = call_594152.call(path_594153, query_594154, nil, nil, body_594155)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_594139(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_594140, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_594141, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_594156 = ref object of OpenApiRestCall_593422
proc url_RestoresTrigger_594158(protocol: Scheme; host: string; base: string;
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

proc validate_RestoresTrigger_594157(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: JString (required)
  ##                    : The backup item to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594159 = path.getOrDefault("fabricName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "fabricName", valid_594159
  var valid_594160 = path.getOrDefault("protectedItemName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "protectedItemName", valid_594160
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("recoveryPointId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "recoveryPointId", valid_594162
  var valid_594163 = path.getOrDefault("containerName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "containerName", valid_594163
  var valid_594164 = path.getOrDefault("subscriptionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "subscriptionId", valid_594164
  var valid_594165 = path.getOrDefault("vaultName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "vaultName", valid_594165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594166 = query.getOrDefault("api-version")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "api-version", valid_594166
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

proc call*(call_594168: Call_RestoresTrigger_594156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_RestoresTrigger_594156; fabricName: string;
          protectedItemName: string; resourceGroupName: string;
          resourceRestoreRequest: JsonNode; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## restoresTrigger
  ## Restores the specified backup data. This is an asynchronous operation. To know the status of this API call, use GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items.
  ##   protectedItemName: string (required)
  ##                    : The backup item to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   resourceRestoreRequest: JObject (required)
  ##                         : The resource restore request.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The recovery point ID for the backup data to be restored.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(path_594170, "fabricName", newJString(fabricName))
  add(path_594170, "protectedItemName", newJString(protectedItemName))
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  if resourceRestoreRequest != nil:
    body_594172 = resourceRestoreRequest
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "recoveryPointId", newJString(recoveryPointId))
  add(path_594170, "containerName", newJString(containerName))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  add(path_594170, "vaultName", newJString(vaultName))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var restoresTrigger* = Call_RestoresTrigger_594156(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_594157, base: "", url: url_RestoresTrigger_594158,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_594173 = ref object of OpenApiRestCall_593422
proc url_ItemLevelRecoveryConnectionsRevoke_594175(protocol: Scheme; host: string;
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

proc validate_ItemLevelRecoveryConnectionsRevoke_594174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: JString (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   recoveryPointId: JString (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   containerName: JString (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594176 = path.getOrDefault("fabricName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "fabricName", valid_594176
  var valid_594177 = path.getOrDefault("protectedItemName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "protectedItemName", valid_594177
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("recoveryPointId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "recoveryPointId", valid_594179
  var valid_594180 = path.getOrDefault("containerName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "containerName", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  var valid_594182 = path.getOrDefault("vaultName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "vaultName", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594183 = query.getOrDefault("api-version")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "api-version", valid_594183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594184: Call_ItemLevelRecoveryConnectionsRevoke_594173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_594184.validator(path, query, header, formData, body)
  let scheme = call_594184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594184.url(scheme.get, call_594184.host, call_594184.base,
                         call_594184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594184, url, valid)

proc call*(call_594185: Call_ItemLevelRecoveryConnectionsRevoke_594173;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer displaying all recoverable files and folders. This is an asynchronous operation.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the backup items. The value allowed is Azure.
  ##   protectedItemName: string (required)
  ##                    : The name of the backup items whose files or folders will be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   recoveryPointId: string (required)
  ##                  : The string that identifies the recovery point. The iSCSI connection will be revoked for this protected data.
  ##   containerName: string (required)
  ##                : The container name associated with the backup items.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594186 = newJObject()
  var query_594187 = newJObject()
  add(path_594186, "fabricName", newJString(fabricName))
  add(path_594186, "protectedItemName", newJString(protectedItemName))
  add(path_594186, "resourceGroupName", newJString(resourceGroupName))
  add(query_594187, "api-version", newJString(apiVersion))
  add(path_594186, "recoveryPointId", newJString(recoveryPointId))
  add(path_594186, "containerName", newJString(containerName))
  add(path_594186, "subscriptionId", newJString(subscriptionId))
  add(path_594186, "vaultName", newJString(vaultName))
  result = call_594185.call(path_594186, query_594187, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_594173(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_594174, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_594175, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_594188 = ref object of OpenApiRestCall_593422
proc url_ProtectionContainersRefresh_594190(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRefresh_594189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594191 = path.getOrDefault("fabricName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "fabricName", valid_594191
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("vaultName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "vaultName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_ProtectionContainersRefresh_594188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_ProtectionContainersRefresh_594188;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersRefresh
  ## Discovers the containers in the subscription that can be protected in a Recovery Services vault. This is an asynchronous operation. To learn the status of the operation, use the GetRefreshOperationResult API.
  ##   fabricName: string (required)
  ##             : The fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "fabricName", newJString(fabricName))
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "vaultName", newJString(vaultName))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_594188(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_594189, base: "",
    url: url_ProtectionContainersRefresh_594190, schemes: {Scheme.Https})
type
  Call_JobsList_594200 = ref object of OpenApiRestCall_593422
proc url_JobsList_594202(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsList_594201(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("subscriptionId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "subscriptionId", valid_594204
  var valid_594205 = path.getOrDefault("vaultName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "vaultName", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "api-version", valid_594206
  var valid_594207 = query.getOrDefault("$skipToken")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "$skipToken", valid_594207
  var valid_594208 = query.getOrDefault("$filter")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "$filter", valid_594208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594209: Call_JobsList_594200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_JobsList_594200; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## jobsList
  ## Provides a pageable list of jobs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of jobs based on status, type, start date, and end date. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  add(path_594211, "vaultName", newJString(vaultName))
  add(query_594212, "$skipToken", newJString(SkipToken))
  add(query_594212, "$filter", newJString(Filter))
  result = call_594210.call(path_594211, query_594212, nil, nil, nil)

var jobsList* = Call_JobsList_594200(name: "jobsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
                                  validator: validate_JobsList_594201, base: "",
                                  url: url_JobsList_594202,
                                  schemes: {Scheme.Https})
type
  Call_ExportJobsOperationResultsGet_594213 = ref object of OpenApiRestCall_593422
proc url_ExportJobsOperationResultsGet_594215(protocol: Scheme; host: string;
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

proc validate_ExportJobsOperationResultsGet_594214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with the export job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594216 = path.getOrDefault("resourceGroupName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "resourceGroupName", valid_594216
  var valid_594217 = path.getOrDefault("subscriptionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "subscriptionId", valid_594217
  var valid_594218 = path.getOrDefault("vaultName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "vaultName", valid_594218
  var valid_594219 = path.getOrDefault("operationId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "operationId", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_ExportJobsOperationResultsGet_594213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation triggered by the ExportJob API.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_ExportJobsOperationResultsGet_594213;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## exportJobsOperationResultsGet
  ## Gets the result of the operation triggered by the ExportJob API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with the export job.
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  add(path_594223, "vaultName", newJString(vaultName))
  add(path_594223, "operationId", newJString(operationId))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var exportJobsOperationResultsGet* = Call_ExportJobsOperationResultsGet_594213(
    name: "exportJobsOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/operationResults/{operationId}",
    validator: validate_ExportJobsOperationResultsGet_594214, base: "",
    url: url_ExportJobsOperationResultsGet_594215, schemes: {Scheme.Https})
type
  Call_JobDetailsGet_594225 = ref object of OpenApiRestCall_593422
proc url_JobDetailsGet_594227(protocol: Scheme; host: string; base: string;
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

proc validate_JobDetailsGet_594226(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets extended information associated with the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Name of the job associated with this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594228 = path.getOrDefault("resourceGroupName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "resourceGroupName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  var valid_594230 = path.getOrDefault("jobName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "jobName", valid_594230
  var valid_594231 = path.getOrDefault("vaultName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "vaultName", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_JobDetailsGet_594225; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets extended information associated with the job.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_JobDetailsGet_594225; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          vaultName: string): Recallable =
  ## jobDetailsGet
  ## Gets extended information associated with the job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Name of the job associated with this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(path_594235, "resourceGroupName", newJString(resourceGroupName))
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "subscriptionId", newJString(subscriptionId))
  add(path_594235, "jobName", newJString(jobName))
  add(path_594235, "vaultName", newJString(vaultName))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_594225(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_594226, base: "", url: url_JobDetailsGet_594227,
    schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_594237 = ref object of OpenApiRestCall_593422
proc url_JobCancellationsTrigger_594239(protocol: Scheme; host: string; base: string;
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

proc validate_JobCancellationsTrigger_594238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("jobName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "jobName", valid_594242
  var valid_594243 = path.getOrDefault("vaultName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "vaultName", valid_594243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594245: Call_JobCancellationsTrigger_594237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ## 
  let valid = call_594245.validator(path, query, header, formData, body)
  let scheme = call_594245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594245.url(scheme.get, call_594245.host, call_594245.base,
                         call_594245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594245, url, valid)

proc call*(call_594246: Call_JobCancellationsTrigger_594237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels the job. This is an asynchronous operation. To know the status of the cancellation, call the GetCancelOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594247 = newJObject()
  var query_594248 = newJObject()
  add(path_594247, "resourceGroupName", newJString(resourceGroupName))
  add(query_594248, "api-version", newJString(apiVersion))
  add(path_594247, "subscriptionId", newJString(subscriptionId))
  add(path_594247, "jobName", newJString(jobName))
  add(path_594247, "vaultName", newJString(vaultName))
  result = call_594246.call(path_594247, query_594248, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_594237(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_594238, base: "",
    url: url_JobCancellationsTrigger_594239, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_594249 = ref object of OpenApiRestCall_593422
proc url_JobOperationResultsGet_594251(protocol: Scheme; host: string; base: string;
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

proc validate_JobOperationResultsGet_594250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the result of the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   jobName: JString (required)
  ##          : Job name associated with this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : OperationID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594252 = path.getOrDefault("resourceGroupName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "resourceGroupName", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("jobName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "jobName", valid_594254
  var valid_594255 = path.getOrDefault("vaultName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "vaultName", valid_594255
  var valid_594256 = path.getOrDefault("operationId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "operationId", valid_594256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594257 = query.getOrDefault("api-version")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "api-version", valid_594257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594258: Call_JobOperationResultsGet_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the result of the operation.
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_JobOperationResultsGet_594249;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string; operationId: string): Recallable =
  ## jobOperationResultsGet
  ## Gets the result of the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   jobName: string (required)
  ##          : Job name associated with this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : OperationID associated with this GET operation.
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  add(path_594260, "resourceGroupName", newJString(resourceGroupName))
  add(query_594261, "api-version", newJString(apiVersion))
  add(path_594260, "subscriptionId", newJString(subscriptionId))
  add(path_594260, "jobName", newJString(jobName))
  add(path_594260, "vaultName", newJString(vaultName))
  add(path_594260, "operationId", newJString(operationId))
  result = call_594259.call(path_594260, query_594261, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_594249(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_594250, base: "",
    url: url_JobOperationResultsGet_594251, schemes: {Scheme.Https})
type
  Call_JobsExport_594262 = ref object of OpenApiRestCall_593422
proc url_JobsExport_594264(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_JobsExport_594263(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("subscriptionId")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "subscriptionId", valid_594266
  var valid_594267 = path.getOrDefault("vaultName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "vaultName", valid_594267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594268 = query.getOrDefault("api-version")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "api-version", valid_594268
  var valid_594269 = query.getOrDefault("$filter")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "$filter", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_JobsExport_594262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_JobsExport_594262; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## jobsExport
  ## Exports all jobs for a given Shared Access Signatures (SAS) URL. The SAS URL expires within 15 minutes of its creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The OData filter options. status eq { InProgress , Completed , Failed , CompletedWithWarnings , Cancelled , Cancelling } and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and operation eq { ConfigureBackup , Backup , Restore , DisableBackup , DeleteBackupData } and jobId eq {guid} and startTime eq { yyyy-mm-dd hh:mm:ss PM } and endTime eq { yyyy-mm-dd hh:mm:ss PM }.
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "vaultName", newJString(vaultName))
  add(query_594273, "$filter", newJString(Filter))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var jobsExport* = Call_JobsExport_594262(name: "jobsExport",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobsExport",
                                      validator: validate_JobsExport_594263,
                                      base: "", url: url_JobsExport_594264,
                                      schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_594274 = ref object of OpenApiRestCall_593422
proc url_BackupOperationResultsGet_594276(protocol: Scheme; host: string;
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

proc validate_BackupOperationResultsGet_594275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("subscriptionId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "subscriptionId", valid_594278
  var valid_594279 = path.getOrDefault("vaultName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "vaultName", valid_594279
  var valid_594280 = path.getOrDefault("operationId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "operationId", valid_594280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594281 = query.getOrDefault("api-version")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "api-version", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_BackupOperationResultsGet_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_BackupOperationResultsGet_594274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations, for example, deleting a backup item. Once the operation starts, the response status code is Accepted. The response status code remains in this state until the operation reaches completion. On successful completion, the status code changes to OK. This method expects OperationID as an argument. OperationID is part of the Location header of the operation response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(path_594284, "resourceGroupName", newJString(resourceGroupName))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "subscriptionId", newJString(subscriptionId))
  add(path_594284, "vaultName", newJString(vaultName))
  add(path_594284, "operationId", newJString(operationId))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_594274(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_594275, base: "",
    url: url_BackupOperationResultsGet_594276, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_594286 = ref object of OpenApiRestCall_593422
proc url_BackupOperationStatusesGet_594288(protocol: Scheme; host: string;
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

proc validate_BackupOperationStatusesGet_594287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID of the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594289 = path.getOrDefault("resourceGroupName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "resourceGroupName", valid_594289
  var valid_594290 = path.getOrDefault("subscriptionId")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "subscriptionId", valid_594290
  var valid_594291 = path.getOrDefault("vaultName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "vaultName", valid_594291
  var valid_594292 = path.getOrDefault("operationId")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "operationId", valid_594292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594293 = query.getOrDefault("api-version")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "api-version", valid_594293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_BackupOperationStatusesGet_594286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_BackupOperationStatusesGet_594286;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationStatusesGet
  ## Gets the status of an operation such as triggering a backup or restore. The status can be In progress, Completed or Failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations create jobs. This method returns the list of jobs when the operation is complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID of the operation.
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  add(path_594296, "resourceGroupName", newJString(resourceGroupName))
  add(query_594297, "api-version", newJString(apiVersion))
  add(path_594296, "subscriptionId", newJString(subscriptionId))
  add(path_594296, "vaultName", newJString(vaultName))
  add(path_594296, "operationId", newJString(operationId))
  result = call_594295.call(path_594296, query_594297, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_594286(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_594287, base: "",
    url: url_BackupOperationStatusesGet_594288, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesList_594298 = ref object of OpenApiRestCall_593422
proc url_ProtectionPoliciesList_594300(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesList_594299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594301 = path.getOrDefault("resourceGroupName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "resourceGroupName", valid_594301
  var valid_594302 = path.getOrDefault("subscriptionId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "subscriptionId", valid_594302
  var valid_594303 = path.getOrDefault("vaultName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "vaultName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  var valid_594305 = query.getOrDefault("$filter")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "$filter", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_ProtectionPoliciesList_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_ProtectionPoliciesList_594298;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## protectionPoliciesList
  ## Lists the backup policies associated with the Recovery Services vault. The API provides parameters to Get scoped results.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation can be used to filter the list of backup policies. backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  add(path_594308, "resourceGroupName", newJString(resourceGroupName))
  add(query_594309, "api-version", newJString(apiVersion))
  add(path_594308, "subscriptionId", newJString(subscriptionId))
  add(path_594308, "vaultName", newJString(vaultName))
  add(query_594309, "$filter", newJString(Filter))
  result = call_594307.call(path_594308, query_594309, nil, nil, nil)

var protectionPoliciesList* = Call_ProtectionPoliciesList_594298(
    name: "protectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies",
    validator: validate_ProtectionPoliciesList_594299, base: "",
    url: url_ProtectionPoliciesList_594300, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_594322 = ref object of OpenApiRestCall_593422
proc url_ProtectionPoliciesCreateOrUpdate_594324(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesCreateOrUpdate_594323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594325 = path.getOrDefault("resourceGroupName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "resourceGroupName", valid_594325
  var valid_594326 = path.getOrDefault("subscriptionId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "subscriptionId", valid_594326
  var valid_594327 = path.getOrDefault("policyName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "policyName", valid_594327
  var valid_594328 = path.getOrDefault("vaultName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "vaultName", valid_594328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594329 = query.getOrDefault("api-version")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "api-version", valid_594329
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

proc call*(call_594331: Call_ProtectionPoliciesCreateOrUpdate_594322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_ProtectionPoliciesCreateOrUpdate_594322;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; resourceProtectionPolicy: JsonNode): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   resourceProtectionPolicy: JObject (required)
  ##                           : The resource backup policy.
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  var body_594335 = newJObject()
  add(path_594333, "resourceGroupName", newJString(resourceGroupName))
  add(query_594334, "api-version", newJString(apiVersion))
  add(path_594333, "subscriptionId", newJString(subscriptionId))
  add(path_594333, "policyName", newJString(policyName))
  add(path_594333, "vaultName", newJString(vaultName))
  if resourceProtectionPolicy != nil:
    body_594335 = resourceProtectionPolicy
  result = call_594332.call(path_594333, query_594334, nil, nil, body_594335)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_594322(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_594323, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_594324, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_594310 = ref object of OpenApiRestCall_593422
proc url_ProtectionPoliciesGet_594312(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesGet_594311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("subscriptionId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "subscriptionId", valid_594314
  var valid_594315 = path.getOrDefault("policyName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "policyName", valid_594315
  var valid_594316 = path.getOrDefault("vaultName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "vaultName", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594318: Call_ProtectionPoliciesGet_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_ProtectionPoliciesGet_594310;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesGet
  ## Gets the details of the backup policy associated with the Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594320 = newJObject()
  var query_594321 = newJObject()
  add(path_594320, "resourceGroupName", newJString(resourceGroupName))
  add(query_594321, "api-version", newJString(apiVersion))
  add(path_594320, "subscriptionId", newJString(subscriptionId))
  add(path_594320, "policyName", newJString(policyName))
  add(path_594320, "vaultName", newJString(vaultName))
  result = call_594319.call(path_594320, query_594321, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_594310(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_594311, base: "",
    url: url_ProtectionPoliciesGet_594312, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_594336 = ref object of OpenApiRestCall_593422
proc url_ProtectionPoliciesDelete_594338(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesDelete_594337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594339 = path.getOrDefault("resourceGroupName")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "resourceGroupName", valid_594339
  var valid_594340 = path.getOrDefault("subscriptionId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "subscriptionId", valid_594340
  var valid_594341 = path.getOrDefault("policyName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "policyName", valid_594341
  var valid_594342 = path.getOrDefault("vaultName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "vaultName", valid_594342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594343 = query.getOrDefault("api-version")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "api-version", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594344: Call_ProtectionPoliciesDelete_594336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_ProtectionPoliciesDelete_594336;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes the specified backup policy from your Recovery Services vault. This is an asynchronous operation. Use the GetPolicyOperationResult API to Get the operation status.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The name of the backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  add(path_594346, "resourceGroupName", newJString(resourceGroupName))
  add(query_594347, "api-version", newJString(apiVersion))
  add(path_594346, "subscriptionId", newJString(subscriptionId))
  add(path_594346, "policyName", newJString(policyName))
  add(path_594346, "vaultName", newJString(vaultName))
  result = call_594345.call(path_594346, query_594347, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_594336(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_594337, base: "",
    url: url_ProtectionPoliciesDelete_594338, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_594348 = ref object of OpenApiRestCall_593422
proc url_ProtectionPolicyOperationResultsGet_594350(protocol: Scheme; host: string;
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

proc validate_ProtectionPolicyOperationResultsGet_594349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594351 = path.getOrDefault("resourceGroupName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "resourceGroupName", valid_594351
  var valid_594352 = path.getOrDefault("subscriptionId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "subscriptionId", valid_594352
  var valid_594353 = path.getOrDefault("policyName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "policyName", valid_594353
  var valid_594354 = path.getOrDefault("vaultName")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "vaultName", valid_594354
  var valid_594355 = path.getOrDefault("operationId")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "operationId", valid_594355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594356 = query.getOrDefault("api-version")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "api-version", valid_594356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594357: Call_ProtectionPolicyOperationResultsGet_594348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_594357.validator(path, query, header, formData, body)
  let scheme = call_594357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594357.url(scheme.get, call_594357.host, call_594357.base,
                         call_594357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594357, url, valid)

proc call*(call_594358: Call_ProtectionPolicyOperationResultsGet_594348;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  var path_594359 = newJObject()
  var query_594360 = newJObject()
  add(path_594359, "resourceGroupName", newJString(resourceGroupName))
  add(query_594360, "api-version", newJString(apiVersion))
  add(path_594359, "subscriptionId", newJString(subscriptionId))
  add(path_594359, "policyName", newJString(policyName))
  add(path_594359, "vaultName", newJString(vaultName))
  add(path_594359, "operationId", newJString(operationId))
  result = call_594358.call(path_594359, query_594360, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_594348(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_594349, base: "",
    url: url_ProtectionPolicyOperationResultsGet_594350, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_594361 = ref object of OpenApiRestCall_593422
proc url_ProtectionPolicyOperationStatusesGet_594363(protocol: Scheme;
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

proc validate_ProtectionPolicyOperationStatusesGet_594362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policyName: JString (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: JString (required)
  ##              : The ID associated with this GET operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594364 = path.getOrDefault("resourceGroupName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "resourceGroupName", valid_594364
  var valid_594365 = path.getOrDefault("subscriptionId")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "subscriptionId", valid_594365
  var valid_594366 = path.getOrDefault("policyName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "policyName", valid_594366
  var valid_594367 = path.getOrDefault("vaultName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "vaultName", valid_594367
  var valid_594368 = path.getOrDefault("operationId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "operationId", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594369 = query.getOrDefault("api-version")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "api-version", valid_594369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594370: Call_ProtectionPolicyOperationStatusesGet_594361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_ProtectionPolicyOperationStatusesGet_594361;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup or restore. The status can be: in progress, completed, or failed. You can refer to the Operation Status enumeration for the possible states of an operation. Some operations create jobs. This method returns the list of jobs associated with the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policyName: string (required)
  ##             : The backup policy name used in this GET operation.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   operationId: string (required)
  ##              : The ID associated with this GET operation.
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  add(path_594372, "resourceGroupName", newJString(resourceGroupName))
  add(query_594373, "api-version", newJString(apiVersion))
  add(path_594372, "subscriptionId", newJString(subscriptionId))
  add(path_594372, "policyName", newJString(policyName))
  add(path_594372, "vaultName", newJString(vaultName))
  add(path_594372, "operationId", newJString(operationId))
  result = call_594371.call(path_594372, query_594373, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_594361(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_594362, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_594363, schemes: {Scheme.Https})
type
  Call_ProtectableItemsList_594374 = ref object of OpenApiRestCall_593422
proc url_ProtectableItemsList_594376(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectableItemsList_594375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594377 = path.getOrDefault("resourceGroupName")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "resourceGroupName", valid_594377
  var valid_594378 = path.getOrDefault("subscriptionId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "subscriptionId", valid_594378
  var valid_594379 = path.getOrDefault("vaultName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "vaultName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             : The Skip Token filter.
  ##   $filter: JString
  ##          : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  var valid_594381 = query.getOrDefault("$skipToken")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "$skipToken", valid_594381
  var valid_594382 = query.getOrDefault("$filter")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "$filter", valid_594382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594383: Call_ProtectableItemsList_594374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ## 
  let valid = call_594383.validator(path, query, header, formData, body)
  let scheme = call_594383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594383.url(scheme.get, call_594383.host, call_594383.base,
                         call_594383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594383, url, valid)

proc call*(call_594384: Call_ProtectableItemsList_594374;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectableItemsList
  ## Based on the query filter and the pagination parameters, this operation provides a pageable list of objects within the subscription that can be protected.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            : The Skip Token filter.
  ##   Filter: string
  ##         : Using the following query filters, you can sort a specific backup item based on: type of backup item, status, name of the item, and more.  providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and status eq { NotProtected , Protecting , Protected } and friendlyName {name} and skipToken eq {string which provides the next set of list} and topToken eq {int} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_594385 = newJObject()
  var query_594386 = newJObject()
  add(path_594385, "resourceGroupName", newJString(resourceGroupName))
  add(query_594386, "api-version", newJString(apiVersion))
  add(path_594385, "subscriptionId", newJString(subscriptionId))
  add(path_594385, "vaultName", newJString(vaultName))
  add(query_594386, "$skipToken", newJString(SkipToken))
  add(query_594386, "$filter", newJString(Filter))
  result = call_594384.call(path_594385, query_594386, nil, nil, nil)

var protectableItemsList* = Call_ProtectableItemsList_594374(
    name: "protectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_ProtectableItemsList_594375, base: "",
    url: url_ProtectableItemsList_594376, schemes: {Scheme.Https})
type
  Call_ProtectedItemsList_594387 = ref object of OpenApiRestCall_593422
proc url_ProtectedItemsList_594389(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsList_594388(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594390 = path.getOrDefault("resourceGroupName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "resourceGroupName", valid_594390
  var valid_594391 = path.getOrDefault("subscriptionId")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "subscriptionId", valid_594391
  var valid_594392 = path.getOrDefault("vaultName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "vaultName", valid_594392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $skipToken: JString
  ##             :  The Skip Token filter.
  ##   $filter: JString
  ##          :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  var valid_594394 = query.getOrDefault("$skipToken")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "$skipToken", valid_594394
  var valid_594395 = query.getOrDefault("$filter")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "$filter", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_ProtectedItemsList_594387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ## 
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_ProtectedItemsList_594387; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## protectedItemsList
  ## Provides a pageable list of all items in a subscription, that can be protected.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   SkipToken: string
  ##            :  The Skip Token filter.
  ##   Filter: string
  ##         :  itemType eq { VM , FileFolder , AzureSqlDb , SQLDB , Exchange , Sharepoint , DPMUnknown } and providerType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql } and policyName eq {policyName} and containerName eq {containername} and backupManagementType eq { AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql }.
  var path_594398 = newJObject()
  var query_594399 = newJObject()
  add(path_594398, "resourceGroupName", newJString(resourceGroupName))
  add(query_594399, "api-version", newJString(apiVersion))
  add(path_594398, "subscriptionId", newJString(subscriptionId))
  add(path_594398, "vaultName", newJString(vaultName))
  add(query_594399, "$skipToken", newJString(SkipToken))
  add(query_594399, "$filter", newJString(Filter))
  result = call_594397.call(path_594398, query_594399, nil, nil, nil)

var protectedItemsList* = Call_ProtectedItemsList_594387(
    name: "protectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectedItems",
    validator: validate_ProtectedItemsList_594388, base: "",
    url: url_ProtectedItemsList_594389, schemes: {Scheme.Https})
type
  Call_ProtectionContainersList_594400 = ref object of OpenApiRestCall_593422
proc url_ProtectionContainersList_594402(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersList_594401(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   vaultName: JString (required)
  ##            : The name of the Recovery Services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594403 = path.getOrDefault("resourceGroupName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "resourceGroupName", valid_594403
  var valid_594404 = path.getOrDefault("subscriptionId")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "subscriptionId", valid_594404
  var valid_594405 = path.getOrDefault("vaultName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "vaultName", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $filter: JString
  ##          : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  var valid_594407 = query.getOrDefault("$filter")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "$filter", valid_594407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_ProtectionContainersList_594400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to the Recovery Services vault.
  ## 
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_ProtectionContainersList_594400;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## protectionContainersList
  ## Lists the containers registered to the Recovery Services vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group associated with the Recovery Services vault.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   vaultName: string (required)
  ##            : The name of the Recovery Services vault.
  ##   Filter: string
  ##         : The following equation is used to sort or filter the containers registered to the vault. providerType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql} and status eq {Unknown, NotRegistered, Registered, Registering} and friendlyName eq {containername} and backupManagementType eq {AzureIaasVM, MAB, DPM, AzureBackupServer, AzureSql}.
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  add(path_594410, "resourceGroupName", newJString(resourceGroupName))
  add(query_594411, "api-version", newJString(apiVersion))
  add(path_594410, "subscriptionId", newJString(subscriptionId))
  add(path_594410, "vaultName", newJString(vaultName))
  add(query_594411, "$filter", newJString(Filter))
  result = call_594409.call(path_594410, query_594411, nil, nil, nil)

var protectionContainersList* = Call_ProtectionContainersList_594400(
    name: "protectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_ProtectionContainersList_594401, base: "",
    url: url_ProtectionContainersList_594402, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
