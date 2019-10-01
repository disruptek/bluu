
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2016-12-01
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup-bms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesList_567889 = ref object of OpenApiRestCall_567667
proc url_BackupEnginesList_567891(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesList_567890(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568065 = path.getOrDefault("resourceGroupName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "resourceGroupName", valid_568065
  var valid_568066 = path.getOrDefault("subscriptionId")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "subscriptionId", valid_568066
  var valid_568067 = path.getOrDefault("vaultName")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "vaultName", valid_568067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568068 = query.getOrDefault("api-version")
  valid_568068 = validateParameter(valid_568068, JString, required = true,
                                 default = nil)
  if valid_568068 != nil:
    section.add "api-version", valid_568068
  var valid_568069 = query.getOrDefault("$skipToken")
  valid_568069 = validateParameter(valid_568069, JString, required = false,
                                 default = nil)
  if valid_568069 != nil:
    section.add "$skipToken", valid_568069
  var valid_568070 = query.getOrDefault("$filter")
  valid_568070 = validateParameter(valid_568070, JString, required = false,
                                 default = nil)
  if valid_568070 != nil:
    section.add "$filter", valid_568070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568093: Call_BackupEnginesList_567889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  let valid = call_568093.validator(path, query, header, formData, body)
  let scheme = call_568093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568093.url(scheme.get, call_568093.host, call_568093.base,
                         call_568093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568093, url, valid)

proc call*(call_568164: Call_BackupEnginesList_567889; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesList
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568165 = newJObject()
  var query_568167 = newJObject()
  add(path_568165, "resourceGroupName", newJString(resourceGroupName))
  add(query_568167, "api-version", newJString(apiVersion))
  add(path_568165, "subscriptionId", newJString(subscriptionId))
  add(path_568165, "vaultName", newJString(vaultName))
  add(query_568167, "$skipToken", newJString(SkipToken))
  add(query_568167, "$filter", newJString(Filter))
  result = call_568164.call(path_568165, query_568167, nil, nil, nil)

var backupEnginesList* = Call_BackupEnginesList_567889(name: "backupEnginesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesList_567890, base: "",
    url: url_BackupEnginesList_567891, schemes: {Scheme.Https})
type
  Call_BackupEnginesGet_568206 = ref object of OpenApiRestCall_567667
proc url_BackupEnginesGet_568208(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vaultName" in path, "`vaultName` is a required path parameter"
  assert "backupEngineName" in path,
        "`backupEngineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "vaultName"),
               (kind: ConstantSegment, value: "/backupEngines/"),
               (kind: VariableSegment, value: "backupEngineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupEnginesGet_568207(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: JString (required)
  ##                   : Name of the backup management server.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568209 = path.getOrDefault("resourceGroupName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "resourceGroupName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  var valid_568211 = path.getOrDefault("vaultName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "vaultName", valid_568211
  var valid_568212 = path.getOrDefault("backupEngineName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "backupEngineName", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("$skipToken")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$skipToken", valid_568214
  var valid_568215 = query.getOrDefault("$filter")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$filter", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_BackupEnginesGet_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_BackupEnginesGet_568206; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          backupEngineName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupEnginesGet
  ## Returns backup management server registered to Recovery Services Vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   backupEngineName: string (required)
  ##                   : Name of the backup management server.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(path_568218, "vaultName", newJString(vaultName))
  add(path_568218, "backupEngineName", newJString(backupEngineName))
  add(query_568219, "$skipToken", newJString(SkipToken))
  add(query_568219, "$filter", newJString(Filter))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_568206(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines/{backupEngineName}",
    validator: validate_BackupEnginesGet_568207, base: "",
    url: url_BackupEnginesGet_568208, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_568220 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainerRefreshOperationResultsGet_568222(protocol: Scheme;
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

proc validate_ProtectionContainerRefreshOperationResultsGet_568221(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568223 = path.getOrDefault("fabricName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "fabricName", valid_568223
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("vaultName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "vaultName", valid_568226
  var valid_568227 = path.getOrDefault("operationId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "operationId", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_ProtectionContainerRefreshOperationResultsGet_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_ProtectionContainerRefreshOperationResultsGet_568220;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string; operationId: string): Recallable =
  ## protectionContainerRefreshOperationResultsGet
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID associated with the operation whose result needs to be fetched.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(path_568231, "fabricName", newJString(fabricName))
  add(path_568231, "resourceGroupName", newJString(resourceGroupName))
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(path_568231, "vaultName", newJString(vaultName))
  add(path_568231, "operationId", newJString(operationId))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_568220(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_568221,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_568222,
    schemes: {Scheme.Https})
type
  Call_ProtectableContainersList_568233 = ref object of OpenApiRestCall_567667
proc url_ProtectableContainersList_568235(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/protectableContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectableContainersList_568234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers that can be registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568236 = path.getOrDefault("fabricName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "fabricName", valid_568236
  var valid_568237 = path.getOrDefault("resourceGroupName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "resourceGroupName", valid_568237
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  var valid_568239 = path.getOrDefault("vaultName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "vaultName", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  var valid_568241 = query.getOrDefault("$filter")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$filter", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_ProtectableContainersList_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers that can be registered to Recovery Services Vault.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_ProtectableContainersList_568233; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## protectableContainersList
  ## Lists the containers that can be registered to Recovery Services Vault.
  ##   fabricName: string (required)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "fabricName", newJString(fabricName))
  add(path_568244, "resourceGroupName", newJString(resourceGroupName))
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "vaultName", newJString(vaultName))
  add(query_568245, "$filter", newJString(Filter))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var protectableContainersList* = Call_ProtectableContainersList_568233(
    name: "protectableContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectableContainers",
    validator: validate_ProtectableContainersList_568234, base: "",
    url: url_ProtectableContainersList_568235, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRegister_568259 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainersRegister_568261(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRegister_568260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container to be registered.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568279 = path.getOrDefault("fabricName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "fabricName", valid_568279
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("containerName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "containerName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("vaultName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "vaultName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request body for operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_ProtectionContainersRegister_568259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_ProtectionContainersRegister_568259;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## protectionContainersRegister
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container to be registered.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : Request body for operation
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  var body_568290 = newJObject()
  add(path_568288, "fabricName", newJString(fabricName))
  add(path_568288, "resourceGroupName", newJString(resourceGroupName))
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "containerName", newJString(containerName))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  add(path_568288, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568290 = parameters
  result = call_568287.call(path_568288, query_568289, nil, nil, body_568290)

var protectionContainersRegister* = Call_ProtectionContainersRegister_568259(
    name: "protectionContainersRegister", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersRegister_568260, base: "",
    url: url_ProtectionContainersRegister_568261, schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_568246 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainersGet_568248(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionContainersGet_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container whose details need to be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568249 = path.getOrDefault("fabricName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "fabricName", valid_568249
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("containerName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "containerName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("vaultName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "vaultName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_ProtectionContainersGet_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_ProtectionContainersGet_568246; fabricName: string;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersGet
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ##   fabricName: string (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container whose details need to be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "fabricName", newJString(fabricName))
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "containerName", newJString(containerName))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "vaultName", newJString(vaultName))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_568246(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_568247, base: "",
    url: url_ProtectionContainersGet_568248, schemes: {Scheme.Https})
type
  Call_ProtectionContainersUnregister_568291 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainersUnregister_568293(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersUnregister_568292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container which needs to be unregistered from the Recovery Services Vault.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568294 = path.getOrDefault("fabricName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "fabricName", valid_568294
  var valid_568295 = path.getOrDefault("resourceGroupName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "resourceGroupName", valid_568295
  var valid_568296 = path.getOrDefault("containerName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "containerName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("vaultName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "vaultName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_ProtectionContainersUnregister_568291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_ProtectionContainersUnregister_568291;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string): Recallable =
  ## protectionContainersUnregister
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ##   fabricName: string (required)
  ##             : Name of the fabric where the container belongs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container which needs to be unregistered from the Recovery Services Vault.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "fabricName", newJString(fabricName))
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "containerName", newJString(containerName))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "vaultName", newJString(vaultName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var protectionContainersUnregister* = Call_ProtectionContainersUnregister_568291(
    name: "protectionContainersUnregister", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersUnregister_568292, base: "",
    url: url_ProtectionContainersUnregister_568293, schemes: {Scheme.Https})
type
  Call_ProtectionContainersInquire_568304 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainersInquire_568306(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/inquire")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProtectionContainersInquire_568305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric Name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container in which inquiry needs to be triggered.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568307 = path.getOrDefault("fabricName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "fabricName", valid_568307
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("containerName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "containerName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("vaultName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "vaultName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  var valid_568313 = query.getOrDefault("$filter")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "$filter", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_ProtectionContainersInquire_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_ProtectionContainersInquire_568304;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## protectionContainersInquire
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ##   fabricName: string (required)
  ##             : Fabric Name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container in which inquiry needs to be triggered.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "fabricName", newJString(fabricName))
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "containerName", newJString(containerName))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "vaultName", newJString(vaultName))
  add(query_568317, "$filter", newJString(Filter))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var protectionContainersInquire* = Call_ProtectionContainersInquire_568304(
    name: "protectionContainersInquire", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/inquire",
    validator: validate_ProtectionContainersInquire_568305, base: "",
    url: url_ProtectionContainersInquire_568306, schemes: {Scheme.Https})
type
  Call_BackupWorkloadItemsList_568318 = ref object of OpenApiRestCall_567667
proc url_BackupWorkloadItemsList_568320(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/items")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupWorkloadItemsList_568319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Name of the container.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568321 = path.getOrDefault("fabricName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "fabricName", valid_568321
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("containerName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "containerName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  var valid_568325 = path.getOrDefault("vaultName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "vaultName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  var valid_568327 = query.getOrDefault("$skipToken")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "$skipToken", valid_568327
  var valid_568328 = query.getOrDefault("$filter")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "$filter", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_BackupWorkloadItemsList_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_BackupWorkloadItemsList_568318; fabricName: string;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; vaultName: string; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## backupWorkloadItemsList
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Name of the container.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "fabricName", newJString(fabricName))
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "containerName", newJString(containerName))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(path_568331, "vaultName", newJString(vaultName))
  add(query_568332, "$skipToken", newJString(SkipToken))
  add(query_568332, "$filter", newJString(Filter))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var backupWorkloadItemsList* = Call_BackupWorkloadItemsList_568318(
    name: "backupWorkloadItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/items",
    validator: validate_BackupWorkloadItemsList_568319, base: "",
    url: url_BackupWorkloadItemsList_568320, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_568333 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainerOperationResultsGet_568335(protocol: Scheme;
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

proc validate_ProtectionContainerOperationResultsGet_568334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name whose information should be fetched.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568336 = path.getOrDefault("fabricName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "fabricName", valid_568336
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("containerName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "containerName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("vaultName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "vaultName", valid_568340
  var valid_568341 = path.getOrDefault("operationId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "operationId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_ProtectionContainerOperationResultsGet_568333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the container.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_ProtectionContainerOperationResultsGet_568333;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          operationId: string): Recallable =
  ## protectionContainerOperationResultsGet
  ## Fetches the result of any operation on the container.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name whose information should be fetched.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "fabricName", newJString(fabricName))
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "containerName", newJString(containerName))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  add(path_568345, "vaultName", newJString(vaultName))
  add(path_568345, "operationId", newJString(operationId))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_568333(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_568334, base: "",
    url: url_ProtectionContainerOperationResultsGet_568335,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_568362 = ref object of OpenApiRestCall_567667
proc url_ProtectedItemsCreateOrUpdate_568364(protocol: Scheme; host: string;
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

proc validate_ProtectedItemsCreateOrUpdate_568363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Item name to be backed up.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568365 = path.getOrDefault("fabricName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "fabricName", valid_568365
  var valid_568366 = path.getOrDefault("protectedItemName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "protectedItemName", valid_568366
  var valid_568367 = path.getOrDefault("resourceGroupName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "resourceGroupName", valid_568367
  var valid_568368 = path.getOrDefault("containerName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "containerName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  var valid_568370 = path.getOrDefault("vaultName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "vaultName", valid_568370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "api-version", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backed up item
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568373: Call_ProtectedItemsCreateOrUpdate_568362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_ProtectedItemsCreateOrUpdate_568362;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## protectedItemsCreateOrUpdate
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Item name to be backed up.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backed up item
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  var body_568377 = newJObject()
  add(path_568375, "fabricName", newJString(fabricName))
  add(path_568375, "protectedItemName", newJString(protectedItemName))
  add(path_568375, "resourceGroupName", newJString(resourceGroupName))
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "containerName", newJString(containerName))
  add(path_568375, "subscriptionId", newJString(subscriptionId))
  add(path_568375, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568377 = parameters
  result = call_568374.call(path_568375, query_568376, nil, nil, body_568377)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_568362(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_568363, base: "",
    url: url_ProtectedItemsCreateOrUpdate_568364, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_568347 = ref object of OpenApiRestCall_567667
proc url_ProtectedItemsGet_568349(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsGet_568348(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568350 = path.getOrDefault("fabricName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "fabricName", valid_568350
  var valid_568351 = path.getOrDefault("protectedItemName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "protectedItemName", valid_568351
  var valid_568352 = path.getOrDefault("resourceGroupName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "resourceGroupName", valid_568352
  var valid_568353 = path.getOrDefault("containerName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "containerName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("vaultName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "vaultName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  var valid_568357 = query.getOrDefault("$filter")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "$filter", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ProtectedItemsGet_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ProtectedItemsGet_568347; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## protectedItemsGet
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "fabricName", newJString(fabricName))
  add(path_568360, "protectedItemName", newJString(protectedItemName))
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "containerName", newJString(containerName))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "vaultName", newJString(vaultName))
  add(query_568361, "$filter", newJString(Filter))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_568347(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_568348, base: "",
    url: url_ProtectedItemsGet_568349, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_568378 = ref object of OpenApiRestCall_567667
proc url_ProtectedItemsDelete_568380(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsDelete_568379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568381 = path.getOrDefault("fabricName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "fabricName", valid_568381
  var valid_568382 = path.getOrDefault("protectedItemName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "protectedItemName", valid_568382
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("containerName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "containerName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("vaultName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "vaultName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_ProtectedItemsDelete_568378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_ProtectedItemsDelete_568378; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string): Recallable =
  ## protectedItemsDelete
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "fabricName", newJString(fabricName))
  add(path_568390, "protectedItemName", newJString(protectedItemName))
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "containerName", newJString(containerName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "vaultName", newJString(vaultName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_568378(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_568379, base: "",
    url: url_ProtectedItemsDelete_568380, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_568392 = ref object of OpenApiRestCall_567667
proc url_BackupsTrigger_568394(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsTrigger_568393(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568395 = path.getOrDefault("fabricName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "fabricName", valid_568395
  var valid_568396 = path.getOrDefault("protectedItemName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "protectedItemName", valid_568396
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("containerName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "containerName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("vaultName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "vaultName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backup request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_BackupsTrigger_568392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_BackupsTrigger_568392; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          parameters: JsonNode): Recallable =
  ## backupsTrigger
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item for which backup needs to be triggered.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backup request
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "fabricName", newJString(fabricName))
  add(path_568405, "protectedItemName", newJString(protectedItemName))
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "containerName", newJString(containerName))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(path_568405, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568407 = parameters
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var backupsTrigger* = Call_BackupsTrigger_568392(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_568393, base: "", url: url_BackupsTrigger_568394,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_568408 = ref object of OpenApiRestCall_567667
proc url_ProtectedItemOperationResultsGet_568410(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationResultsGet_568409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation on the backup item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568411 = path.getOrDefault("fabricName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "fabricName", valid_568411
  var valid_568412 = path.getOrDefault("protectedItemName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "protectedItemName", valid_568412
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("containerName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "containerName", valid_568414
  var valid_568415 = path.getOrDefault("subscriptionId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "subscriptionId", valid_568415
  var valid_568416 = path.getOrDefault("vaultName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "vaultName", valid_568416
  var valid_568417 = path.getOrDefault("operationId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "operationId", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_ProtectedItemOperationResultsGet_568408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the backup item.
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_ProtectedItemOperationResultsGet_568408;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationResultsGet
  ## Fetches the result of any operation on the backup item.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result needs to be fetched.
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  add(path_568421, "fabricName", newJString(fabricName))
  add(path_568421, "protectedItemName", newJString(protectedItemName))
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "containerName", newJString(containerName))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  add(path_568421, "vaultName", newJString(vaultName))
  add(path_568421, "operationId", newJString(operationId))
  result = call_568420.call(path_568421, query_568422, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_568408(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_568409, base: "",
    url: url_ProtectedItemOperationResultsGet_568410, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_568423 = ref object of OpenApiRestCall_567667
proc url_ProtectedItemOperationStatusesGet_568425(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationStatusesGet_568424(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: JString (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568426 = path.getOrDefault("fabricName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "fabricName", valid_568426
  var valid_568427 = path.getOrDefault("protectedItemName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "protectedItemName", valid_568427
  var valid_568428 = path.getOrDefault("resourceGroupName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "resourceGroupName", valid_568428
  var valid_568429 = path.getOrDefault("containerName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "containerName", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  var valid_568431 = path.getOrDefault("vaultName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "vaultName", valid_568431
  var valid_568432 = path.getOrDefault("operationId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "operationId", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_ProtectedItemOperationStatusesGet_568423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_ProtectedItemOperationStatusesGet_568423;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## protectedItemOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backup item.
  ##   protectedItemName: string (required)
  ##                    : Backup item name whose details are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backup item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID represents the operation whose status needs to be fetched.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(path_568436, "fabricName", newJString(fabricName))
  add(path_568436, "protectedItemName", newJString(protectedItemName))
  add(path_568436, "resourceGroupName", newJString(resourceGroupName))
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "containerName", newJString(containerName))
  add(path_568436, "subscriptionId", newJString(subscriptionId))
  add(path_568436, "vaultName", newJString(vaultName))
  add(path_568436, "operationId", newJString(operationId))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_568423(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_568424, base: "",
    url: url_ProtectedItemOperationStatusesGet_568425, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_568438 = ref object of OpenApiRestCall_567667
proc url_RecoveryPointsList_568440(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsList_568439(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the backup copies for the backed up item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568441 = path.getOrDefault("fabricName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "fabricName", valid_568441
  var valid_568442 = path.getOrDefault("protectedItemName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "protectedItemName", valid_568442
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("containerName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "containerName", valid_568444
  var valid_568445 = path.getOrDefault("subscriptionId")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "subscriptionId", valid_568445
  var valid_568446 = path.getOrDefault("vaultName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "vaultName", valid_568446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568447 = query.getOrDefault("api-version")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "api-version", valid_568447
  var valid_568448 = query.getOrDefault("$filter")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "$filter", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_RecoveryPointsList_568438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup copies for the backed up item.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_RecoveryPointsList_568438; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          containerName: string; subscriptionId: string; vaultName: string;
          Filter: string = ""): Recallable =
  ## recoveryPointsList
  ## Lists the backup copies for the backed up item.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item whose backup copies are to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "fabricName", newJString(fabricName))
  add(path_568451, "protectedItemName", newJString(protectedItemName))
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "containerName", newJString(containerName))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  add(path_568451, "vaultName", newJString(vaultName))
  add(query_568452, "$filter", newJString(Filter))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_568438(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_568439, base: "",
    url: url_RecoveryPointsList_568440, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568453 = ref object of OpenApiRestCall_567667
proc url_RecoveryPointsGet_568455(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_568454(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   containerName: JString (required)
  ##                : Container name associated with backed up item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568456 = path.getOrDefault("fabricName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "fabricName", valid_568456
  var valid_568457 = path.getOrDefault("protectedItemName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "protectedItemName", valid_568457
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("recoveryPointId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "recoveryPointId", valid_568459
  var valid_568460 = path.getOrDefault("containerName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "containerName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("vaultName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "vaultName", valid_568462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568463 = query.getOrDefault("api-version")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "api-version", valid_568463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_RecoveryPointsGet_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_RecoveryPointsGet_568453; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## recoveryPointsGet
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with backed up item.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose backup data needs to be fetched.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : RecoveryPointID represents the backed up data to be fetched.
  ##   containerName: string (required)
  ##                : Container name associated with backed up item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  add(path_568466, "fabricName", newJString(fabricName))
  add(path_568466, "protectedItemName", newJString(protectedItemName))
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "recoveryPointId", newJString(recoveryPointId))
  add(path_568466, "containerName", newJString(containerName))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  add(path_568466, "vaultName", newJString(vaultName))
  result = call_568465.call(path_568466, query_568467, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568453(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_568454, base: "",
    url: url_RecoveryPointsGet_568455, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_568468 = ref object of OpenApiRestCall_567667
proc url_ItemLevelRecoveryConnectionsProvision_568470(protocol: Scheme;
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

proc validate_ItemLevelRecoveryConnectionsProvision_568469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned
  ## for this backed up data.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568471 = path.getOrDefault("fabricName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "fabricName", valid_568471
  var valid_568472 = path.getOrDefault("protectedItemName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "protectedItemName", valid_568472
  var valid_568473 = path.getOrDefault("resourceGroupName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceGroupName", valid_568473
  var valid_568474 = path.getOrDefault("recoveryPointId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "recoveryPointId", valid_568474
  var valid_568475 = path.getOrDefault("containerName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "containerName", valid_568475
  var valid_568476 = path.getOrDefault("subscriptionId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "subscriptionId", valid_568476
  var valid_568477 = path.getOrDefault("vaultName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "vaultName", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource ILR request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_ItemLevelRecoveryConnectionsProvision_568468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_ItemLevelRecoveryConnectionsProvision_568468;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string; parameters: JsonNode): Recallable =
  ## itemLevelRecoveryConnectionsProvision
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be provisioned
  ## for this backed up data.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource ILR request
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  var body_568484 = newJObject()
  add(path_568482, "fabricName", newJString(fabricName))
  add(path_568482, "protectedItemName", newJString(protectedItemName))
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "recoveryPointId", newJString(recoveryPointId))
  add(path_568482, "containerName", newJString(containerName))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(path_568482, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568484 = parameters
  result = call_568481.call(path_568482, query_568483, nil, nil, body_568484)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_568468(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_568469, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_568470, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_568485 = ref object of OpenApiRestCall_567667
proc url_RestoresTrigger_568487(protocol: Scheme; host: string; base: string;
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

proc validate_RestoresTrigger_568486(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568488 = path.getOrDefault("fabricName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "fabricName", valid_568488
  var valid_568489 = path.getOrDefault("protectedItemName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "protectedItemName", valid_568489
  var valid_568490 = path.getOrDefault("resourceGroupName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "resourceGroupName", valid_568490
  var valid_568491 = path.getOrDefault("recoveryPointId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "recoveryPointId", valid_568491
  var valid_568492 = path.getOrDefault("containerName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "containerName", valid_568492
  var valid_568493 = path.getOrDefault("subscriptionId")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "subscriptionId", valid_568493
  var valid_568494 = path.getOrDefault("vaultName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "vaultName", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568495 = query.getOrDefault("api-version")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "api-version", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource restore request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_RestoresTrigger_568485; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_RestoresTrigger_568485; fabricName: string;
          protectedItemName: string; resourceGroupName: string; apiVersion: string;
          recoveryPointId: string; containerName: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## restoresTrigger
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents the backed up data to be restored.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource restore request
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  var body_568501 = newJObject()
  add(path_568499, "fabricName", newJString(fabricName))
  add(path_568499, "protectedItemName", newJString(protectedItemName))
  add(path_568499, "resourceGroupName", newJString(resourceGroupName))
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "recoveryPointId", newJString(recoveryPointId))
  add(path_568499, "containerName", newJString(containerName))
  add(path_568499, "subscriptionId", newJString(subscriptionId))
  add(path_568499, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568501 = parameters
  result = call_568498.call(path_568499, query_568500, nil, nil, body_568501)

var restoresTrigger* = Call_RestoresTrigger_568485(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_568486, base: "", url: url_RestoresTrigger_568487,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_568502 = ref object of OpenApiRestCall_567667
proc url_ItemLevelRecoveryConnectionsRevoke_568504(protocol: Scheme; host: string;
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

proc validate_ItemLevelRecoveryConnectionsRevoke_568503(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: JString (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   recoveryPointId: JString (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for
  ## this backed up data.
  ##   containerName: JString (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568505 = path.getOrDefault("fabricName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "fabricName", valid_568505
  var valid_568506 = path.getOrDefault("protectedItemName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "protectedItemName", valid_568506
  var valid_568507 = path.getOrDefault("resourceGroupName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "resourceGroupName", valid_568507
  var valid_568508 = path.getOrDefault("recoveryPointId")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "recoveryPointId", valid_568508
  var valid_568509 = path.getOrDefault("containerName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "containerName", valid_568509
  var valid_568510 = path.getOrDefault("subscriptionId")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "subscriptionId", valid_568510
  var valid_568511 = path.getOrDefault("vaultName")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "vaultName", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568513: Call_ItemLevelRecoveryConnectionsRevoke_568502;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_568513.validator(path, query, header, formData, body)
  let scheme = call_568513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568513.url(scheme.get, call_568513.host, call_568513.base,
                         call_568513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568513, url, valid)

proc call*(call_568514: Call_ItemLevelRecoveryConnectionsRevoke_568502;
          fabricName: string; protectedItemName: string; resourceGroupName: string;
          apiVersion: string; recoveryPointId: string; containerName: string;
          subscriptionId: string; vaultName: string): Recallable =
  ## itemLevelRecoveryConnectionsRevoke
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ##   fabricName: string (required)
  ##             : Fabric name associated with the backed up items.
  ##   protectedItemName: string (required)
  ##                    : Backed up item name whose files/folders are to be restored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   recoveryPointId: string (required)
  ##                  : Recovery point ID which represents backed up data. iSCSI connection will be revoked for
  ## this backed up data.
  ##   containerName: string (required)
  ##                : Container name associated with the backed up items.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568515 = newJObject()
  var query_568516 = newJObject()
  add(path_568515, "fabricName", newJString(fabricName))
  add(path_568515, "protectedItemName", newJString(protectedItemName))
  add(path_568515, "resourceGroupName", newJString(resourceGroupName))
  add(query_568516, "api-version", newJString(apiVersion))
  add(path_568515, "recoveryPointId", newJString(recoveryPointId))
  add(path_568515, "containerName", newJString(containerName))
  add(path_568515, "subscriptionId", newJString(subscriptionId))
  add(path_568515, "vaultName", newJString(vaultName))
  result = call_568514.call(path_568515, query_568516, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_568502(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_568503, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_568504, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_568517 = ref object of OpenApiRestCall_567667
proc url_ProtectionContainersRefresh_568519(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRefresh_568518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name associated the container.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568520 = path.getOrDefault("fabricName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "fabricName", valid_568520
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  var valid_568523 = path.getOrDefault("vaultName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "vaultName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  var valid_568525 = query.getOrDefault("$filter")
  valid_568525 = validateParameter(valid_568525, JString, required = false,
                                 default = nil)
  if valid_568525 != nil:
    section.add "$filter", valid_568525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_ProtectionContainersRefresh_568517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_ProtectionContainersRefresh_568517;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vaultName: string; Filter: string = ""): Recallable =
  ## protectionContainersRefresh
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ##   fabricName: string (required)
  ##             : Fabric name associated the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(path_568528, "fabricName", newJString(fabricName))
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  add(path_568528, "vaultName", newJString(vaultName))
  add(query_568529, "$filter", newJString(Filter))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_568517(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_568518, base: "",
    url: url_ProtectionContainersRefresh_568519, schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_568530 = ref object of OpenApiRestCall_567667
proc url_JobCancellationsTrigger_568532(protocol: Scheme; host: string; base: string;
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

proc validate_JobCancellationsTrigger_568531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Name of the job to cancel.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568533 = path.getOrDefault("resourceGroupName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "resourceGroupName", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("jobName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "jobName", valid_568535
  var valid_568536 = path.getOrDefault("vaultName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "vaultName", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_JobCancellationsTrigger_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_JobCancellationsTrigger_568530;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string): Recallable =
  ## jobCancellationsTrigger
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Name of the job to cancel.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  add(path_568540, "jobName", newJString(jobName))
  add(path_568540, "vaultName", newJString(vaultName))
  result = call_568539.call(path_568540, query_568541, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_568530(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_568531, base: "",
    url: url_JobCancellationsTrigger_568532, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_568542 = ref object of OpenApiRestCall_567667
proc url_JobOperationResultsGet_568544(protocol: Scheme; host: string; base: string;
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

proc validate_JobOperationResultsGet_568543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the result of any operation.
  ## the operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job name whose operation result has to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568545 = path.getOrDefault("resourceGroupName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceGroupName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("jobName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "jobName", valid_568547
  var valid_568548 = path.getOrDefault("vaultName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "vaultName", valid_568548
  var valid_568549 = path.getOrDefault("operationId")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "operationId", valid_568549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568550 = query.getOrDefault("api-version")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "api-version", valid_568550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568551: Call_JobOperationResultsGet_568542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the result of any operation.
  ## the operation.
  ## 
  let valid = call_568551.validator(path, query, header, formData, body)
  let scheme = call_568551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568551.url(scheme.get, call_568551.host, call_568551.base,
                         call_568551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568551, url, valid)

proc call*(call_568552: Call_JobOperationResultsGet_568542;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; vaultName: string; operationId: string): Recallable =
  ## jobOperationResultsGet
  ## Fetches the result of any operation.
  ## the operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job name whose operation result has to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation whose result has to be fetched.
  var path_568553 = newJObject()
  var query_568554 = newJObject()
  add(path_568553, "resourceGroupName", newJString(resourceGroupName))
  add(query_568554, "api-version", newJString(apiVersion))
  add(path_568553, "subscriptionId", newJString(subscriptionId))
  add(path_568553, "jobName", newJString(jobName))
  add(path_568553, "vaultName", newJString(vaultName))
  add(path_568553, "operationId", newJString(operationId))
  result = call_568552.call(path_568553, query_568554, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_568542(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_568543, base: "",
    url: url_JobOperationResultsGet_568544, schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_568555 = ref object of OpenApiRestCall_567667
proc url_BackupOperationResultsGet_568557(protocol: Scheme; host: string;
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

proc validate_BackupOperationResultsGet_568556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("subscriptionId")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "subscriptionId", valid_568559
  var valid_568560 = path.getOrDefault("vaultName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "vaultName", valid_568560
  var valid_568561 = path.getOrDefault("operationId")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "operationId", valid_568561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "api-version", valid_568562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_BackupOperationResultsGet_568555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_BackupOperationResultsGet_568555;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationResultsGet
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  add(path_568565, "vaultName", newJString(vaultName))
  add(path_568565, "operationId", newJString(operationId))
  result = call_568564.call(path_568565, query_568566, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_568555(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_568556, base: "",
    url: url_BackupOperationResultsGet_568557, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_568567 = ref object of OpenApiRestCall_567667
proc url_BackupOperationStatusesGet_568569(protocol: Scheme; host: string;
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

proc validate_BackupOperationStatusesGet_568568(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : OperationID which represents the operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568570 = path.getOrDefault("resourceGroupName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "resourceGroupName", valid_568570
  var valid_568571 = path.getOrDefault("subscriptionId")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "subscriptionId", valid_568571
  var valid_568572 = path.getOrDefault("vaultName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "vaultName", valid_568572
  var valid_568573 = path.getOrDefault("operationId")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "operationId", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568575: Call_BackupOperationStatusesGet_568567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_568575.validator(path, query, header, formData, body)
  let scheme = call_568575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568575.url(scheme.get, call_568575.host, call_568575.base,
                         call_568575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568575, url, valid)

proc call*(call_568576: Call_BackupOperationStatusesGet_568567;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; operationId: string): Recallable =
  ## backupOperationStatusesGet
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : OperationID which represents the operation.
  var path_568577 = newJObject()
  var query_568578 = newJObject()
  add(path_568577, "resourceGroupName", newJString(resourceGroupName))
  add(query_568578, "api-version", newJString(apiVersion))
  add(path_568577, "subscriptionId", newJString(subscriptionId))
  add(path_568577, "vaultName", newJString(vaultName))
  add(path_568577, "operationId", newJString(operationId))
  result = call_568576.call(path_568577, query_568578, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_568567(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_568568, base: "",
    url: url_BackupOperationStatusesGet_568569, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_568591 = ref object of OpenApiRestCall_567667
proc url_ProtectionPoliciesCreateOrUpdate_568593(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesCreateOrUpdate_568592(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy to be created.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568594 = path.getOrDefault("resourceGroupName")
  valid_568594 = validateParameter(valid_568594, JString, required = true,
                                 default = nil)
  if valid_568594 != nil:
    section.add "resourceGroupName", valid_568594
  var valid_568595 = path.getOrDefault("subscriptionId")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "subscriptionId", valid_568595
  var valid_568596 = path.getOrDefault("policyName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "policyName", valid_568596
  var valid_568597 = path.getOrDefault("vaultName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "vaultName", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backup policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568600: Call_ProtectionPoliciesCreateOrUpdate_568591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_ProtectionPoliciesCreateOrUpdate_568591;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; parameters: JsonNode): Recallable =
  ## protectionPoliciesCreateOrUpdate
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy to be created.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource backup policy
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  var body_568604 = newJObject()
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  add(path_568602, "policyName", newJString(policyName))
  add(path_568602, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568604 = parameters
  result = call_568601.call(path_568602, query_568603, nil, nil, body_568604)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_568591(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_568592, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_568593, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_568579 = ref object of OpenApiRestCall_567667
proc url_ProtectionPoliciesGet_568581(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesGet_568580(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568582 = path.getOrDefault("resourceGroupName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "resourceGroupName", valid_568582
  var valid_568583 = path.getOrDefault("subscriptionId")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "subscriptionId", valid_568583
  var valid_568584 = path.getOrDefault("policyName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "policyName", valid_568584
  var valid_568585 = path.getOrDefault("vaultName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "vaultName", valid_568585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568586 = query.getOrDefault("api-version")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "api-version", valid_568586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568587: Call_ProtectionPoliciesGet_568579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_568587.validator(path, query, header, formData, body)
  let scheme = call_568587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568587.url(scheme.get, call_568587.host, call_568587.base,
                         call_568587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568587, url, valid)

proc call*(call_568588: Call_ProtectionPoliciesGet_568579;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesGet
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy information to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568589 = newJObject()
  var query_568590 = newJObject()
  add(path_568589, "resourceGroupName", newJString(resourceGroupName))
  add(query_568590, "api-version", newJString(apiVersion))
  add(path_568589, "subscriptionId", newJString(subscriptionId))
  add(path_568589, "policyName", newJString(policyName))
  add(path_568589, "vaultName", newJString(vaultName))
  result = call_568588.call(path_568589, query_568590, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_568579(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_568580, base: "",
    url: url_ProtectionPoliciesGet_568581, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_568605 = ref object of OpenApiRestCall_567667
proc url_ProtectionPoliciesDelete_568607(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesDelete_568606(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568608 = path.getOrDefault("resourceGroupName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "resourceGroupName", valid_568608
  var valid_568609 = path.getOrDefault("subscriptionId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "subscriptionId", valid_568609
  var valid_568610 = path.getOrDefault("policyName")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "policyName", valid_568610
  var valid_568611 = path.getOrDefault("vaultName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "vaultName", valid_568611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568612 = query.getOrDefault("api-version")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "api-version", valid_568612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568613: Call_ProtectionPoliciesDelete_568605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_568613.validator(path, query, header, formData, body)
  let scheme = call_568613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568613.url(scheme.get, call_568613.host, call_568613.base,
                         call_568613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568613, url, valid)

proc call*(call_568614: Call_ProtectionPoliciesDelete_568605;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string): Recallable =
  ## protectionPoliciesDelete
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy to be deleted.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568615 = newJObject()
  var query_568616 = newJObject()
  add(path_568615, "resourceGroupName", newJString(resourceGroupName))
  add(query_568616, "api-version", newJString(apiVersion))
  add(path_568615, "subscriptionId", newJString(subscriptionId))
  add(path_568615, "policyName", newJString(policyName))
  add(path_568615, "vaultName", newJString(vaultName))
  result = call_568614.call(path_568615, query_568616, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_568605(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_568606, base: "",
    url: url_ProtectionPoliciesDelete_568607, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_568617 = ref object of OpenApiRestCall_567667
proc url_ProtectionPolicyOperationResultsGet_568619(protocol: Scheme; host: string;
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

proc validate_ProtectionPolicyOperationResultsGet_568618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the result of an operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568620 = path.getOrDefault("resourceGroupName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "resourceGroupName", valid_568620
  var valid_568621 = path.getOrDefault("subscriptionId")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "subscriptionId", valid_568621
  var valid_568622 = path.getOrDefault("policyName")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "policyName", valid_568622
  var valid_568623 = path.getOrDefault("vaultName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "vaultName", valid_568623
  var valid_568624 = path.getOrDefault("operationId")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "operationId", valid_568624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568625 = query.getOrDefault("api-version")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "api-version", valid_568625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568626: Call_ProtectionPolicyOperationResultsGet_568617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_568626.validator(path, query, header, formData, body)
  let scheme = call_568626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568626.url(scheme.get, call_568626.host, call_568626.base,
                         call_568626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568626, url, valid)

proc call*(call_568627: Call_ProtectionPolicyOperationResultsGet_568617;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationResultsGet
  ## Provides the result of an operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's result needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents the operation whose result needs to be fetched.
  var path_568628 = newJObject()
  var query_568629 = newJObject()
  add(path_568628, "resourceGroupName", newJString(resourceGroupName))
  add(query_568629, "api-version", newJString(apiVersion))
  add(path_568628, "subscriptionId", newJString(subscriptionId))
  add(path_568628, "policyName", newJString(policyName))
  add(path_568628, "vaultName", newJString(vaultName))
  add(path_568628, "operationId", newJString(operationId))
  result = call_568627.call(path_568628, query_568629, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_568617(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_568618, base: "",
    url: url_ProtectionPolicyOperationResultsGet_568619, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_568630 = ref object of OpenApiRestCall_567667
proc url_ProtectionPolicyOperationStatusesGet_568632(protocol: Scheme;
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

proc validate_ProtectionPolicyOperationStatusesGet_568631(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   policyName: JString (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  ##   operationId: JString (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568633 = path.getOrDefault("resourceGroupName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "resourceGroupName", valid_568633
  var valid_568634 = path.getOrDefault("subscriptionId")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "subscriptionId", valid_568634
  var valid_568635 = path.getOrDefault("policyName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "policyName", valid_568635
  var valid_568636 = path.getOrDefault("vaultName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "vaultName", valid_568636
  var valid_568637 = path.getOrDefault("operationId")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "operationId", valid_568637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568638 = query.getOrDefault("api-version")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "api-version", valid_568638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568639: Call_ProtectionPolicyOperationStatusesGet_568630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ## 
  let valid = call_568639.validator(path, query, header, formData, body)
  let scheme = call_568639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568639.url(scheme.get, call_568639.host, call_568639.base,
                         call_568639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568639, url, valid)

proc call*(call_568640: Call_ProtectionPolicyOperationStatusesGet_568630;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyName: string; vaultName: string; operationId: string): Recallable =
  ## protectionPolicyOperationStatusesGet
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   policyName: string (required)
  ##             : Backup policy name whose operation's status needs to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   operationId: string (required)
  ##              : Operation ID which represents an operation whose status needs to be fetched.
  var path_568641 = newJObject()
  var query_568642 = newJObject()
  add(path_568641, "resourceGroupName", newJString(resourceGroupName))
  add(query_568642, "api-version", newJString(apiVersion))
  add(path_568641, "subscriptionId", newJString(subscriptionId))
  add(path_568641, "policyName", newJString(policyName))
  add(path_568641, "vaultName", newJString(vaultName))
  add(path_568641, "operationId", newJString(operationId))
  result = call_568640.call(path_568641, query_568642, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_568630(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_568631, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_568632, schemes: {Scheme.Https})
type
  Call_BackupProtectableItemsList_568643 = ref object of OpenApiRestCall_567667
proc url_BackupProtectableItemsList_568645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_BackupProtectableItemsList_568644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568646 = path.getOrDefault("resourceGroupName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "resourceGroupName", valid_568646
  var valid_568647 = path.getOrDefault("subscriptionId")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "subscriptionId", valid_568647
  var valid_568648 = path.getOrDefault("vaultName")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "vaultName", valid_568648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $skipToken: JString
  ##             : skipToken Filter.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  var valid_568650 = query.getOrDefault("$skipToken")
  valid_568650 = validateParameter(valid_568650, JString, required = false,
                                 default = nil)
  if valid_568650 != nil:
    section.add "$skipToken", valid_568650
  var valid_568651 = query.getOrDefault("$filter")
  valid_568651 = validateParameter(valid_568651, JString, required = false,
                                 default = nil)
  if valid_568651 != nil:
    section.add "$filter", valid_568651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568652: Call_BackupProtectableItemsList_568643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ## 
  let valid = call_568652.validator(path, query, header, formData, body)
  let scheme = call_568652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568652.url(scheme.get, call_568652.host, call_568652.base,
                         call_568652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568652, url, valid)

proc call*(call_568653: Call_BackupProtectableItemsList_568643;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupProtectableItemsList
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   SkipToken: string
  ##            : skipToken Filter.
  ##   Filter: string
  ##         : OData filter options.
  var path_568654 = newJObject()
  var query_568655 = newJObject()
  add(path_568654, "resourceGroupName", newJString(resourceGroupName))
  add(query_568655, "api-version", newJString(apiVersion))
  add(path_568654, "subscriptionId", newJString(subscriptionId))
  add(path_568654, "vaultName", newJString(vaultName))
  add(query_568655, "$skipToken", newJString(SkipToken))
  add(query_568655, "$filter", newJString(Filter))
  result = call_568653.call(path_568654, query_568655, nil, nil, nil)

var backupProtectableItemsList* = Call_BackupProtectableItemsList_568643(
    name: "backupProtectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_BackupProtectableItemsList_568644, base: "",
    url: url_BackupProtectableItemsList_568645, schemes: {Scheme.Https})
type
  Call_BackupProtectionContainersList_568656 = ref object of OpenApiRestCall_567667
proc url_BackupProtectionContainersList_568658(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_BackupProtectionContainersList_568657(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568659 = path.getOrDefault("resourceGroupName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "resourceGroupName", valid_568659
  var valid_568660 = path.getOrDefault("subscriptionId")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "subscriptionId", valid_568660
  var valid_568661 = path.getOrDefault("vaultName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "vaultName", valid_568661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568662 = query.getOrDefault("api-version")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "api-version", valid_568662
  var valid_568663 = query.getOrDefault("$filter")
  valid_568663 = validateParameter(valid_568663, JString, required = false,
                                 default = nil)
  if valid_568663 != nil:
    section.add "$filter", valid_568663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568664: Call_BackupProtectionContainersList_568656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  let valid = call_568664.validator(path, query, header, formData, body)
  let scheme = call_568664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568664.url(scheme.get, call_568664.host, call_568664.base,
                         call_568664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568664, url, valid)

proc call*(call_568665: Call_BackupProtectionContainersList_568656;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; Filter: string = ""): Recallable =
  ## backupProtectionContainersList
  ## Lists the containers registered to Recovery Services Vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568666 = newJObject()
  var query_568667 = newJObject()
  add(path_568666, "resourceGroupName", newJString(resourceGroupName))
  add(query_568667, "api-version", newJString(apiVersion))
  add(path_568666, "subscriptionId", newJString(subscriptionId))
  add(path_568666, "vaultName", newJString(vaultName))
  add(query_568667, "$filter", newJString(Filter))
  result = call_568665.call(path_568666, query_568667, nil, nil, nil)

var backupProtectionContainersList* = Call_BackupProtectionContainersList_568656(
    name: "backupProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_BackupProtectionContainersList_568657, base: "",
    url: url_BackupProtectionContainersList_568658, schemes: {Scheme.Https})
type
  Call_SecurityPINsGet_568668 = ref object of OpenApiRestCall_567667
proc url_SecurityPINsGet_568670(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backupSecurityPIN")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityPINsGet_568669(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the security PIN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("subscriptionId")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "subscriptionId", valid_568672
  var valid_568673 = path.getOrDefault("vaultName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "vaultName", valid_568673
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568674 = query.getOrDefault("api-version")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "api-version", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568675: Call_SecurityPINsGet_568668; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security PIN.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_SecurityPINsGet_568668; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string): Recallable =
  ## securityPINsGet
  ## Get the security PIN.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  add(path_568677, "resourceGroupName", newJString(resourceGroupName))
  add(query_568678, "api-version", newJString(apiVersion))
  add(path_568677, "subscriptionId", newJString(subscriptionId))
  add(path_568677, "vaultName", newJString(vaultName))
  result = call_568676.call(path_568677, query_568678, nil, nil, nil)

var securityPINsGet* = Call_SecurityPINsGet_568668(name: "securityPINsGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupSecurityPIN",
    validator: validate_SecurityPINsGet_568669, base: "", url: url_SecurityPINsGet_568670,
    schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsGet_568679 = ref object of OpenApiRestCall_567667
proc url_BackupResourceVaultConfigsGet_568681(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/backupconfig/vaultconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceVaultConfigsGet_568680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource vault config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568682 = path.getOrDefault("resourceGroupName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "resourceGroupName", valid_568682
  var valid_568683 = path.getOrDefault("subscriptionId")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "subscriptionId", valid_568683
  var valid_568684 = path.getOrDefault("vaultName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "vaultName", valid_568684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568685 = query.getOrDefault("api-version")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "api-version", valid_568685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568686: Call_BackupResourceVaultConfigsGet_568679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches resource vault config.
  ## 
  let valid = call_568686.validator(path, query, header, formData, body)
  let scheme = call_568686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568686.url(scheme.get, call_568686.host, call_568686.base,
                         call_568686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568686, url, valid)

proc call*(call_568687: Call_BackupResourceVaultConfigsGet_568679;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## backupResourceVaultConfigsGet
  ## Fetches resource vault config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568688 = newJObject()
  var query_568689 = newJObject()
  add(path_568688, "resourceGroupName", newJString(resourceGroupName))
  add(query_568689, "api-version", newJString(apiVersion))
  add(path_568688, "subscriptionId", newJString(subscriptionId))
  add(path_568688, "vaultName", newJString(vaultName))
  result = call_568687.call(path_568688, query_568689, nil, nil, nil)

var backupResourceVaultConfigsGet* = Call_BackupResourceVaultConfigsGet_568679(
    name: "backupResourceVaultConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsGet_568680, base: "",
    url: url_BackupResourceVaultConfigsGet_568681, schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsUpdate_568690 = ref object of OpenApiRestCall_567667
proc url_BackupResourceVaultConfigsUpdate_568692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/backupconfig/vaultconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceVaultConfigsUpdate_568691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault security config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568693 = path.getOrDefault("resourceGroupName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "resourceGroupName", valid_568693
  var valid_568694 = path.getOrDefault("subscriptionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "subscriptionId", valid_568694
  var valid_568695 = path.getOrDefault("vaultName")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "vaultName", valid_568695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568696 = query.getOrDefault("api-version")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "api-version", valid_568696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568698: Call_BackupResourceVaultConfigsUpdate_568690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault security config.
  ## 
  let valid = call_568698.validator(path, query, header, formData, body)
  let scheme = call_568698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568698.url(scheme.get, call_568698.host, call_568698.base,
                         call_568698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568698, url, valid)

proc call*(call_568699: Call_BackupResourceVaultConfigsUpdate_568690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## backupResourceVaultConfigsUpdate
  ## Updates vault security config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : resource config request
  var path_568700 = newJObject()
  var query_568701 = newJObject()
  var body_568702 = newJObject()
  add(path_568700, "resourceGroupName", newJString(resourceGroupName))
  add(query_568701, "api-version", newJString(apiVersion))
  add(path_568700, "subscriptionId", newJString(subscriptionId))
  add(path_568700, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568702 = parameters
  result = call_568699.call(path_568700, query_568701, nil, nil, body_568702)

var backupResourceVaultConfigsUpdate* = Call_BackupResourceVaultConfigsUpdate_568690(
    name: "backupResourceVaultConfigsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsUpdate_568691, base: "",
    url: url_BackupResourceVaultConfigsUpdate_568692, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsUpdate_568714 = ref object of OpenApiRestCall_567667
proc url_BackupResourceStorageConfigsUpdate_568716(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/backupstorageconfig/vaultstorageconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceStorageConfigsUpdate_568715(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault storage model type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568717 = path.getOrDefault("resourceGroupName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "resourceGroupName", valid_568717
  var valid_568718 = path.getOrDefault("subscriptionId")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "subscriptionId", valid_568718
  var valid_568719 = path.getOrDefault("vaultName")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "vaultName", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568720 = query.getOrDefault("api-version")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "api-version", valid_568720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568722: Call_BackupResourceStorageConfigsUpdate_568714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_568722.validator(path, query, header, formData, body)
  let scheme = call_568722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568722.url(scheme.get, call_568722.host, call_568722.base,
                         call_568722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568722, url, valid)

proc call*(call_568723: Call_BackupResourceStorageConfigsUpdate_568714;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## backupResourceStorageConfigsUpdate
  ## Updates vault storage model type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  var path_568724 = newJObject()
  var query_568725 = newJObject()
  var body_568726 = newJObject()
  add(path_568724, "resourceGroupName", newJString(resourceGroupName))
  add(query_568725, "api-version", newJString(apiVersion))
  add(path_568724, "subscriptionId", newJString(subscriptionId))
  add(path_568724, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568726 = parameters
  result = call_568723.call(path_568724, query_568725, nil, nil, body_568726)

var backupResourceStorageConfigsUpdate* = Call_BackupResourceStorageConfigsUpdate_568714(
    name: "backupResourceStorageConfigsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsUpdate_568715, base: "",
    url: url_BackupResourceStorageConfigsUpdate_568716, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsGet_568703 = ref object of OpenApiRestCall_567667
proc url_BackupResourceStorageConfigsGet_568705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/backupstorageconfig/vaultstorageconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceStorageConfigsGet_568704(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches resource storage config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568706 = path.getOrDefault("resourceGroupName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "resourceGroupName", valid_568706
  var valid_568707 = path.getOrDefault("subscriptionId")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "subscriptionId", valid_568707
  var valid_568708 = path.getOrDefault("vaultName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "vaultName", valid_568708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568710: Call_BackupResourceStorageConfigsGet_568703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches resource storage config.
  ## 
  let valid = call_568710.validator(path, query, header, formData, body)
  let scheme = call_568710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568710.url(scheme.get, call_568710.host, call_568710.base,
                         call_568710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568710, url, valid)

proc call*(call_568711: Call_BackupResourceStorageConfigsGet_568703;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string): Recallable =
  ## backupResourceStorageConfigsGet
  ## Fetches resource storage config.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568712 = newJObject()
  var query_568713 = newJObject()
  add(path_568712, "resourceGroupName", newJString(resourceGroupName))
  add(query_568713, "api-version", newJString(apiVersion))
  add(path_568712, "subscriptionId", newJString(subscriptionId))
  add(path_568712, "vaultName", newJString(vaultName))
  result = call_568711.call(path_568712, query_568713, nil, nil, nil)

var backupResourceStorageConfigsGet* = Call_BackupResourceStorageConfigsGet_568703(
    name: "backupResourceStorageConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsGet_568704, base: "",
    url: url_BackupResourceStorageConfigsGet_568705, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsPatch_568727 = ref object of OpenApiRestCall_567667
proc url_BackupResourceStorageConfigsPatch_568729(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "vaultName"), (kind: ConstantSegment,
        value: "/backupstorageconfig/vaultstorageconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupResourceStorageConfigsPatch_568728(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates vault storage model type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568730 = path.getOrDefault("resourceGroupName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "resourceGroupName", valid_568730
  var valid_568731 = path.getOrDefault("subscriptionId")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "subscriptionId", valid_568731
  var valid_568732 = path.getOrDefault("vaultName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "vaultName", valid_568732
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568733 = query.getOrDefault("api-version")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "api-version", valid_568733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568735: Call_BackupResourceStorageConfigsPatch_568727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_568735.validator(path, query, header, formData, body)
  let scheme = call_568735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568735.url(scheme.get, call_568735.host, call_568735.base,
                         call_568735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568735, url, valid)

proc call*(call_568736: Call_BackupResourceStorageConfigsPatch_568727;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vaultName: string; parameters: JsonNode): Recallable =
  ## backupResourceStorageConfigsPatch
  ## Updates vault storage model type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  ##   parameters: JObject (required)
  ##             : Vault storage config request
  var path_568737 = newJObject()
  var query_568738 = newJObject()
  var body_568739 = newJObject()
  add(path_568737, "resourceGroupName", newJString(resourceGroupName))
  add(query_568738, "api-version", newJString(apiVersion))
  add(path_568737, "subscriptionId", newJString(subscriptionId))
  add(path_568737, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_568739 = parameters
  result = call_568736.call(path_568737, query_568738, nil, nil, body_568739)

var backupResourceStorageConfigsPatch* = Call_BackupResourceStorageConfigsPatch_568727(
    name: "backupResourceStorageConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsPatch_568728, base: "",
    url: url_BackupResourceStorageConfigsPatch_568729, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
