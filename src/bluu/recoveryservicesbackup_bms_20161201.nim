
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup-bms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupEnginesList_593660 = ref object of OpenApiRestCall_593438
proc url_BackupEnginesList_593662(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593836 = path.getOrDefault("resourceGroupName")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "resourceGroupName", valid_593836
  var valid_593837 = path.getOrDefault("subscriptionId")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "subscriptionId", valid_593837
  var valid_593838 = path.getOrDefault("vaultName")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "vaultName", valid_593838
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
  var valid_593839 = query.getOrDefault("api-version")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = nil)
  if valid_593839 != nil:
    section.add "api-version", valid_593839
  var valid_593840 = query.getOrDefault("$skipToken")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "$skipToken", valid_593840
  var valid_593841 = query.getOrDefault("$filter")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "$filter", valid_593841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593864: Call_BackupEnginesList_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Backup management servers registered to Recovery Services Vault. Returns a pageable list of servers.
  ## 
  let valid = call_593864.validator(path, query, header, formData, body)
  let scheme = call_593864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593864.url(scheme.get, call_593864.host, call_593864.base,
                         call_593864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593864, url, valid)

proc call*(call_593935: Call_BackupEnginesList_593660; resourceGroupName: string;
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
  var path_593936 = newJObject()
  var query_593938 = newJObject()
  add(path_593936, "resourceGroupName", newJString(resourceGroupName))
  add(query_593938, "api-version", newJString(apiVersion))
  add(path_593936, "subscriptionId", newJString(subscriptionId))
  add(path_593936, "vaultName", newJString(vaultName))
  add(query_593938, "$skipToken", newJString(SkipToken))
  add(query_593938, "$filter", newJString(Filter))
  result = call_593935.call(path_593936, query_593938, nil, nil, nil)

var backupEnginesList* = Call_BackupEnginesList_593660(name: "backupEnginesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines",
    validator: validate_BackupEnginesList_593661, base: "",
    url: url_BackupEnginesList_593662, schemes: {Scheme.Https})
type
  Call_BackupEnginesGet_593977 = ref object of OpenApiRestCall_593438
proc url_BackupEnginesGet_593979(protocol: Scheme; host: string; base: string;
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

proc validate_BackupEnginesGet_593978(path: JsonNode; query: JsonNode;
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
  var valid_593980 = path.getOrDefault("resourceGroupName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "resourceGroupName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("vaultName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "vaultName", valid_593982
  var valid_593983 = path.getOrDefault("backupEngineName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "backupEngineName", valid_593983
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
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  var valid_593985 = query.getOrDefault("$skipToken")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "$skipToken", valid_593985
  var valid_593986 = query.getOrDefault("$filter")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "$filter", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_BackupEnginesGet_593977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns backup management server registered to Recovery Services Vault.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_BackupEnginesGet_593977; resourceGroupName: string;
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "vaultName", newJString(vaultName))
  add(path_593989, "backupEngineName", newJString(backupEngineName))
  add(query_593990, "$skipToken", newJString(SkipToken))
  add(query_593990, "$filter", newJString(Filter))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var backupEnginesGet* = Call_BackupEnginesGet_593977(name: "backupEnginesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupEngines/{backupEngineName}",
    validator: validate_BackupEnginesGet_593978, base: "",
    url: url_BackupEnginesGet_593979, schemes: {Scheme.Https})
type
  Call_ProtectionContainerRefreshOperationResultsGet_593991 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainerRefreshOperationResultsGet_593993(protocol: Scheme;
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

proc validate_ProtectionContainerRefreshOperationResultsGet_593992(
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
  var valid_593994 = path.getOrDefault("fabricName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "fabricName", valid_593994
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("vaultName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "vaultName", valid_593997
  var valid_593998 = path.getOrDefault("operationId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "operationId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_ProtectionContainerRefreshOperationResultsGet_593991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of the refresh operation triggered by the BeginRefresh operation.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_ProtectionContainerRefreshOperationResultsGet_593991;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "fabricName", newJString(fabricName))
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "vaultName", newJString(vaultName))
  add(path_594002, "operationId", newJString(operationId))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var protectionContainerRefreshOperationResultsGet* = Call_ProtectionContainerRefreshOperationResultsGet_593991(
    name: "protectionContainerRefreshOperationResultsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerRefreshOperationResultsGet_593992,
    base: "", url: url_ProtectionContainerRefreshOperationResultsGet_593993,
    schemes: {Scheme.Https})
type
  Call_ProtectableContainersList_594004 = ref object of OpenApiRestCall_593438
proc url_ProtectableContainersList_594006(protocol: Scheme; host: string;
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

proc validate_ProtectableContainersList_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("fabricName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "fabricName", valid_594007
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("vaultName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "vaultName", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  var valid_594012 = query.getOrDefault("$filter")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$filter", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_ProtectableContainersList_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers that can be registered to Recovery Services Vault.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ProtectableContainersList_594004; fabricName: string;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "fabricName", newJString(fabricName))
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(path_594015, "vaultName", newJString(vaultName))
  add(query_594016, "$filter", newJString(Filter))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var protectableContainersList* = Call_ProtectableContainersList_594004(
    name: "protectableContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectableContainers",
    validator: validate_ProtectableContainersList_594005, base: "",
    url: url_ProtectableContainersList_594006, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRegister_594030 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainersRegister_594032(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRegister_594031(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("fabricName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "fabricName", valid_594050
  var valid_594051 = path.getOrDefault("resourceGroupName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "resourceGroupName", valid_594051
  var valid_594052 = path.getOrDefault("containerName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "containerName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("vaultName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "vaultName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
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

proc call*(call_594057: Call_ProtectionContainersRegister_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers the container with Recovery Services vault.
  ## This is an asynchronous operation. To track the operation status, use location header to call get latest status of
  ## the operation.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_ProtectionContainersRegister_594030;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(path_594059, "fabricName", newJString(fabricName))
  add(path_594059, "resourceGroupName", newJString(resourceGroupName))
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "containerName", newJString(containerName))
  add(path_594059, "subscriptionId", newJString(subscriptionId))
  add(path_594059, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594061 = parameters
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var protectionContainersRegister* = Call_ProtectionContainersRegister_594030(
    name: "protectionContainersRegister", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersRegister_594031, base: "",
    url: url_ProtectionContainersRegister_594032, schemes: {Scheme.Https})
type
  Call_ProtectionContainersGet_594017 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainersGet_594019(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionContainersGet_594018(path: JsonNode; query: JsonNode;
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
  var valid_594020 = path.getOrDefault("fabricName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "fabricName", valid_594020
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("containerName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "containerName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("vaultName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "vaultName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ProtectionContainersGet_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details of the specific container registered to your Recovery Services Vault.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ProtectionContainersGet_594017; fabricName: string;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "fabricName", newJString(fabricName))
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "containerName", newJString(containerName))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "vaultName", newJString(vaultName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var protectionContainersGet* = Call_ProtectionContainersGet_594017(
    name: "protectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersGet_594018, base: "",
    url: url_ProtectionContainersGet_594019, schemes: {Scheme.Https})
type
  Call_ProtectionContainersUnregister_594062 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainersUnregister_594064(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersUnregister_594063(path: JsonNode;
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
  var valid_594065 = path.getOrDefault("fabricName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "fabricName", valid_594065
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("containerName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "containerName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("vaultName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "vaultName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_ProtectionContainersUnregister_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters the given container from your Recovery Services Vault. This is an asynchronous operation. To determine
  ## whether the backend service has finished processing the request, call Get Container Operation Result API.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_ProtectionContainersUnregister_594062;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "fabricName", newJString(fabricName))
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "containerName", newJString(containerName))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "vaultName", newJString(vaultName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var protectionContainersUnregister* = Call_ProtectionContainersUnregister_594062(
    name: "protectionContainersUnregister", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}",
    validator: validate_ProtectionContainersUnregister_594063, base: "",
    url: url_ProtectionContainersUnregister_594064, schemes: {Scheme.Https})
type
  Call_ProtectionContainersInquire_594075 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainersInquire_594077(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersInquire_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("fabricName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fabricName", valid_594078
  var valid_594079 = path.getOrDefault("resourceGroupName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceGroupName", valid_594079
  var valid_594080 = path.getOrDefault("containerName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "containerName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("vaultName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "vaultName", valid_594082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  var valid_594084 = query.getOrDefault("$filter")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "$filter", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_ProtectionContainersInquire_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This is an async operation and the results should be tracked using location header or Azure-async-url.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_ProtectionContainersInquire_594075;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(path_594087, "fabricName", newJString(fabricName))
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "containerName", newJString(containerName))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "vaultName", newJString(vaultName))
  add(query_594088, "$filter", newJString(Filter))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var protectionContainersInquire* = Call_ProtectionContainersInquire_594075(
    name: "protectionContainersInquire", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/inquire",
    validator: validate_ProtectionContainersInquire_594076, base: "",
    url: url_ProtectionContainersInquire_594077, schemes: {Scheme.Https})
type
  Call_BackupWorkloadItemsList_594089 = ref object of OpenApiRestCall_593438
proc url_BackupWorkloadItemsList_594091(protocol: Scheme; host: string; base: string;
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

proc validate_BackupWorkloadItemsList_594090(path: JsonNode; query: JsonNode;
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
  var valid_594092 = path.getOrDefault("fabricName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "fabricName", valid_594092
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("containerName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "containerName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  var valid_594096 = path.getOrDefault("vaultName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "vaultName", valid_594096
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
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  var valid_594098 = query.getOrDefault("$skipToken")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "$skipToken", valid_594098
  var valid_594099 = query.getOrDefault("$filter")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "$filter", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_BackupWorkloadItemsList_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of workload item of a specific container according to the query filter and the pagination
  ## parameters.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_BackupWorkloadItemsList_594089; fabricName: string;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(path_594102, "fabricName", newJString(fabricName))
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "containerName", newJString(containerName))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(path_594102, "vaultName", newJString(vaultName))
  add(query_594103, "$skipToken", newJString(SkipToken))
  add(query_594103, "$filter", newJString(Filter))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var backupWorkloadItemsList* = Call_BackupWorkloadItemsList_594089(
    name: "backupWorkloadItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/items",
    validator: validate_BackupWorkloadItemsList_594090, base: "",
    url: url_BackupWorkloadItemsList_594091, schemes: {Scheme.Https})
type
  Call_ProtectionContainerOperationResultsGet_594104 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainerOperationResultsGet_594106(protocol: Scheme;
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

proc validate_ProtectionContainerOperationResultsGet_594105(path: JsonNode;
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
  var valid_594107 = path.getOrDefault("fabricName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "fabricName", valid_594107
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("containerName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "containerName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("vaultName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "vaultName", valid_594111
  var valid_594112 = path.getOrDefault("operationId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "operationId", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_ProtectionContainerOperationResultsGet_594104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the container.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_ProtectionContainerOperationResultsGet_594104;
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "fabricName", newJString(fabricName))
  add(path_594116, "resourceGroupName", newJString(resourceGroupName))
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "containerName", newJString(containerName))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  add(path_594116, "vaultName", newJString(vaultName))
  add(path_594116, "operationId", newJString(operationId))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var protectionContainerOperationResultsGet* = Call_ProtectionContainerOperationResultsGet_594104(
    name: "protectionContainerOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/operationResults/{operationId}",
    validator: validate_ProtectionContainerOperationResultsGet_594105, base: "",
    url: url_ProtectionContainerOperationResultsGet_594106,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemsCreateOrUpdate_594133 = ref object of OpenApiRestCall_593438
proc url_ProtectedItemsCreateOrUpdate_594135(protocol: Scheme; host: string;
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

proc validate_ProtectedItemsCreateOrUpdate_594134(path: JsonNode; query: JsonNode;
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
  var valid_594136 = path.getOrDefault("fabricName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "fabricName", valid_594136
  var valid_594137 = path.getOrDefault("protectedItemName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "protectedItemName", valid_594137
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("containerName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "containerName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("vaultName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "vaultName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
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

proc call*(call_594144: Call_ProtectedItemsCreateOrUpdate_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables backup of an item or to modifies the backup policy information of an already backed up item. This is an
  ## asynchronous operation. To know the status of the operation, call the GetItemOperationResult API.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_ProtectedItemsCreateOrUpdate_594133;
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
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  var body_594148 = newJObject()
  add(path_594146, "fabricName", newJString(fabricName))
  add(path_594146, "protectedItemName", newJString(protectedItemName))
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "containerName", newJString(containerName))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  add(path_594146, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594148 = parameters
  result = call_594145.call(path_594146, query_594147, nil, nil, body_594148)

var protectedItemsCreateOrUpdate* = Call_ProtectedItemsCreateOrUpdate_594133(
    name: "protectedItemsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsCreateOrUpdate_594134, base: "",
    url: url_ProtectedItemsCreateOrUpdate_594135, schemes: {Scheme.Https})
type
  Call_ProtectedItemsGet_594118 = ref object of OpenApiRestCall_593438
proc url_ProtectedItemsGet_594120(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsGet_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("fabricName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "fabricName", valid_594121
  var valid_594122 = path.getOrDefault("protectedItemName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "protectedItemName", valid_594122
  var valid_594123 = path.getOrDefault("resourceGroupName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "resourceGroupName", valid_594123
  var valid_594124 = path.getOrDefault("containerName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "containerName", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  var valid_594126 = path.getOrDefault("vaultName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "vaultName", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  var valid_594128 = query.getOrDefault("$filter")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "$filter", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_ProtectedItemsGet_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backed up item. This is an asynchronous operation. To know the status of the operation,
  ## call the GetItemOperationResult API.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_ProtectedItemsGet_594118; fabricName: string;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(path_594131, "fabricName", newJString(fabricName))
  add(path_594131, "protectedItemName", newJString(protectedItemName))
  add(path_594131, "resourceGroupName", newJString(resourceGroupName))
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "containerName", newJString(containerName))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "vaultName", newJString(vaultName))
  add(query_594132, "$filter", newJString(Filter))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var protectedItemsGet* = Call_ProtectedItemsGet_594118(name: "protectedItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsGet_594119, base: "",
    url: url_ProtectedItemsGet_594120, schemes: {Scheme.Https})
type
  Call_ProtectedItemsDelete_594149 = ref object of OpenApiRestCall_593438
proc url_ProtectedItemsDelete_594151(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectedItemsDelete_594150(path: JsonNode; query: JsonNode;
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
  var valid_594152 = path.getOrDefault("fabricName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "fabricName", valid_594152
  var valid_594153 = path.getOrDefault("protectedItemName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "protectedItemName", valid_594153
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("containerName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "containerName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("vaultName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "vaultName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_ProtectedItemsDelete_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Used to disable backup of an item within a container. This is an asynchronous operation. To know the status of the
  ## request, call the GetItemOperationResult API.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ProtectedItemsDelete_594149; fabricName: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "fabricName", newJString(fabricName))
  add(path_594161, "protectedItemName", newJString(protectedItemName))
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "containerName", newJString(containerName))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "vaultName", newJString(vaultName))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var protectedItemsDelete* = Call_ProtectedItemsDelete_594149(
    name: "protectedItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}",
    validator: validate_ProtectedItemsDelete_594150, base: "",
    url: url_ProtectedItemsDelete_594151, schemes: {Scheme.Https})
type
  Call_BackupsTrigger_594163 = ref object of OpenApiRestCall_593438
proc url_BackupsTrigger_594165(protocol: Scheme; host: string; base: string;
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

proc validate_BackupsTrigger_594164(path: JsonNode; query: JsonNode;
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
  var valid_594166 = path.getOrDefault("fabricName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "fabricName", valid_594166
  var valid_594167 = path.getOrDefault("protectedItemName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "protectedItemName", valid_594167
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("containerName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "containerName", valid_594169
  var valid_594170 = path.getOrDefault("subscriptionId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "subscriptionId", valid_594170
  var valid_594171 = path.getOrDefault("vaultName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "vaultName", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
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

proc call*(call_594174: Call_BackupsTrigger_594163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Triggers backup for specified backed up item. This is an asynchronous operation. To know the status of the
  ## operation, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_BackupsTrigger_594163; fabricName: string;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(path_594176, "fabricName", newJString(fabricName))
  add(path_594176, "protectedItemName", newJString(protectedItemName))
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "containerName", newJString(containerName))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594178 = parameters
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var backupsTrigger* = Call_BackupsTrigger_594163(name: "backupsTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/backup",
    validator: validate_BackupsTrigger_594164, base: "", url: url_BackupsTrigger_594165,
    schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationResultsGet_594179 = ref object of OpenApiRestCall_593438
proc url_ProtectedItemOperationResultsGet_594181(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationResultsGet_594180(path: JsonNode;
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
  var valid_594182 = path.getOrDefault("fabricName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "fabricName", valid_594182
  var valid_594183 = path.getOrDefault("protectedItemName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "protectedItemName", valid_594183
  var valid_594184 = path.getOrDefault("resourceGroupName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "resourceGroupName", valid_594184
  var valid_594185 = path.getOrDefault("containerName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "containerName", valid_594185
  var valid_594186 = path.getOrDefault("subscriptionId")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "subscriptionId", valid_594186
  var valid_594187 = path.getOrDefault("vaultName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "vaultName", valid_594187
  var valid_594188 = path.getOrDefault("operationId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "operationId", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_ProtectedItemOperationResultsGet_594179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the result of any operation on the backup item.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_ProtectedItemOperationResultsGet_594179;
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
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(path_594192, "fabricName", newJString(fabricName))
  add(path_594192, "protectedItemName", newJString(protectedItemName))
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "containerName", newJString(containerName))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  add(path_594192, "vaultName", newJString(vaultName))
  add(path_594192, "operationId", newJString(operationId))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var protectedItemOperationResultsGet* = Call_ProtectedItemOperationResultsGet_594179(
    name: "protectedItemOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationResults/{operationId}",
    validator: validate_ProtectedItemOperationResultsGet_594180, base: "",
    url: url_ProtectedItemOperationResultsGet_594181, schemes: {Scheme.Https})
type
  Call_ProtectedItemOperationStatusesGet_594194 = ref object of OpenApiRestCall_593438
proc url_ProtectedItemOperationStatusesGet_594196(protocol: Scheme; host: string;
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

proc validate_ProtectedItemOperationStatusesGet_594195(path: JsonNode;
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
  var valid_594197 = path.getOrDefault("fabricName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "fabricName", valid_594197
  var valid_594198 = path.getOrDefault("protectedItemName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "protectedItemName", valid_594198
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("containerName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "containerName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("vaultName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "vaultName", valid_594202
  var valid_594203 = path.getOrDefault("operationId")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "operationId", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_ProtectedItemOperationStatusesGet_594194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of the operation. Some operations
  ## create jobs. This method returns the list of jobs associated with the operation.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_ProtectedItemOperationStatusesGet_594194;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  add(path_594207, "fabricName", newJString(fabricName))
  add(path_594207, "protectedItemName", newJString(protectedItemName))
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "containerName", newJString(containerName))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  add(path_594207, "vaultName", newJString(vaultName))
  add(path_594207, "operationId", newJString(operationId))
  result = call_594206.call(path_594207, query_594208, nil, nil, nil)

var protectedItemOperationStatusesGet* = Call_ProtectedItemOperationStatusesGet_594194(
    name: "protectedItemOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/operationsStatus/{operationId}",
    validator: validate_ProtectedItemOperationStatusesGet_594195, base: "",
    url: url_ProtectedItemOperationStatusesGet_594196, schemes: {Scheme.Https})
type
  Call_RecoveryPointsList_594209 = ref object of OpenApiRestCall_593438
proc url_RecoveryPointsList_594211(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsList_594210(path: JsonNode; query: JsonNode;
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
  var valid_594212 = path.getOrDefault("fabricName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "fabricName", valid_594212
  var valid_594213 = path.getOrDefault("protectedItemName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "protectedItemName", valid_594213
  var valid_594214 = path.getOrDefault("resourceGroupName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceGroupName", valid_594214
  var valid_594215 = path.getOrDefault("containerName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "containerName", valid_594215
  var valid_594216 = path.getOrDefault("subscriptionId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "subscriptionId", valid_594216
  var valid_594217 = path.getOrDefault("vaultName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "vaultName", valid_594217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "api-version", valid_594218
  var valid_594219 = query.getOrDefault("$filter")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "$filter", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_RecoveryPointsList_594209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the backup copies for the backed up item.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_RecoveryPointsList_594209; fabricName: string;
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
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "fabricName", newJString(fabricName))
  add(path_594222, "protectedItemName", newJString(protectedItemName))
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "containerName", newJString(containerName))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  add(path_594222, "vaultName", newJString(vaultName))
  add(query_594223, "$filter", newJString(Filter))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var recoveryPointsList* = Call_RecoveryPointsList_594209(
    name: "recoveryPointsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsList_594210, base: "",
    url: url_RecoveryPointsList_594211, schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_594224 = ref object of OpenApiRestCall_593438
proc url_RecoveryPointsGet_594226(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_594225(path: JsonNode; query: JsonNode;
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
  var valid_594227 = path.getOrDefault("fabricName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "fabricName", valid_594227
  var valid_594228 = path.getOrDefault("protectedItemName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "protectedItemName", valid_594228
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("recoveryPointId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "recoveryPointId", valid_594230
  var valid_594231 = path.getOrDefault("containerName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "containerName", valid_594231
  var valid_594232 = path.getOrDefault("subscriptionId")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "subscriptionId", valid_594232
  var valid_594233 = path.getOrDefault("vaultName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "vaultName", valid_594233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594234 = query.getOrDefault("api-version")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "api-version", valid_594234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594235: Call_RecoveryPointsGet_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the information of the backed up data identified using RecoveryPointID. This is an asynchronous operation.
  ## To know the status of the operation, call the GetProtectedItemOperationResult API.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_RecoveryPointsGet_594224; fabricName: string;
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
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  add(path_594237, "fabricName", newJString(fabricName))
  add(path_594237, "protectedItemName", newJString(protectedItemName))
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "recoveryPointId", newJString(recoveryPointId))
  add(path_594237, "containerName", newJString(containerName))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  add(path_594237, "vaultName", newJString(vaultName))
  result = call_594236.call(path_594237, query_594238, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_594224(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}",
    validator: validate_RecoveryPointsGet_594225, base: "",
    url: url_RecoveryPointsGet_594226, schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsProvision_594239 = ref object of OpenApiRestCall_593438
proc url_ItemLevelRecoveryConnectionsProvision_594241(protocol: Scheme;
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

proc validate_ItemLevelRecoveryConnectionsProvision_594240(path: JsonNode;
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
  var valid_594242 = path.getOrDefault("fabricName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "fabricName", valid_594242
  var valid_594243 = path.getOrDefault("protectedItemName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "protectedItemName", valid_594243
  var valid_594244 = path.getOrDefault("resourceGroupName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "resourceGroupName", valid_594244
  var valid_594245 = path.getOrDefault("recoveryPointId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "recoveryPointId", valid_594245
  var valid_594246 = path.getOrDefault("containerName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "containerName", valid_594246
  var valid_594247 = path.getOrDefault("subscriptionId")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "subscriptionId", valid_594247
  var valid_594248 = path.getOrDefault("vaultName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "vaultName", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
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

proc call*(call_594251: Call_ItemLevelRecoveryConnectionsProvision_594239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a script which invokes an iSCSI connection to the backup data. Executing this script opens a file
  ## explorer displaying all the recoverable files and folders. This is an asynchronous operation. To know the status of
  ## provisioning, call GetProtectedItemOperationResult API.
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_ItemLevelRecoveryConnectionsProvision_594239;
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
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  var body_594255 = newJObject()
  add(path_594253, "fabricName", newJString(fabricName))
  add(path_594253, "protectedItemName", newJString(protectedItemName))
  add(path_594253, "resourceGroupName", newJString(resourceGroupName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "recoveryPointId", newJString(recoveryPointId))
  add(path_594253, "containerName", newJString(containerName))
  add(path_594253, "subscriptionId", newJString(subscriptionId))
  add(path_594253, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594255 = parameters
  result = call_594252.call(path_594253, query_594254, nil, nil, body_594255)

var itemLevelRecoveryConnectionsProvision* = Call_ItemLevelRecoveryConnectionsProvision_594239(
    name: "itemLevelRecoveryConnectionsProvision", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/provisionInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsProvision_594240, base: "",
    url: url_ItemLevelRecoveryConnectionsProvision_594241, schemes: {Scheme.Https})
type
  Call_RestoresTrigger_594256 = ref object of OpenApiRestCall_593438
proc url_RestoresTrigger_594258(protocol: Scheme; host: string; base: string;
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

proc validate_RestoresTrigger_594257(path: JsonNode; query: JsonNode;
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
  var valid_594259 = path.getOrDefault("fabricName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "fabricName", valid_594259
  var valid_594260 = path.getOrDefault("protectedItemName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "protectedItemName", valid_594260
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("recoveryPointId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "recoveryPointId", valid_594262
  var valid_594263 = path.getOrDefault("containerName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "containerName", valid_594263
  var valid_594264 = path.getOrDefault("subscriptionId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "subscriptionId", valid_594264
  var valid_594265 = path.getOrDefault("vaultName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "vaultName", valid_594265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594266 = query.getOrDefault("api-version")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "api-version", valid_594266
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

proc call*(call_594268: Call_RestoresTrigger_594256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified backed up data. This is an asynchronous operation. To know the status of this API call, use
  ## GetProtectedItemOperationResult API.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_RestoresTrigger_594256; fabricName: string;
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
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  var body_594272 = newJObject()
  add(path_594270, "fabricName", newJString(fabricName))
  add(path_594270, "protectedItemName", newJString(protectedItemName))
  add(path_594270, "resourceGroupName", newJString(resourceGroupName))
  add(query_594271, "api-version", newJString(apiVersion))
  add(path_594270, "recoveryPointId", newJString(recoveryPointId))
  add(path_594270, "containerName", newJString(containerName))
  add(path_594270, "subscriptionId", newJString(subscriptionId))
  add(path_594270, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594272 = parameters
  result = call_594269.call(path_594270, query_594271, nil, nil, body_594272)

var restoresTrigger* = Call_RestoresTrigger_594256(name: "restoresTrigger",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/restore",
    validator: validate_RestoresTrigger_594257, base: "", url: url_RestoresTrigger_594258,
    schemes: {Scheme.Https})
type
  Call_ItemLevelRecoveryConnectionsRevoke_594273 = ref object of OpenApiRestCall_593438
proc url_ItemLevelRecoveryConnectionsRevoke_594275(protocol: Scheme; host: string;
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

proc validate_ItemLevelRecoveryConnectionsRevoke_594274(path: JsonNode;
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
  var valid_594276 = path.getOrDefault("fabricName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "fabricName", valid_594276
  var valid_594277 = path.getOrDefault("protectedItemName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "protectedItemName", valid_594277
  var valid_594278 = path.getOrDefault("resourceGroupName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "resourceGroupName", valid_594278
  var valid_594279 = path.getOrDefault("recoveryPointId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "recoveryPointId", valid_594279
  var valid_594280 = path.getOrDefault("containerName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "containerName", valid_594280
  var valid_594281 = path.getOrDefault("subscriptionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "subscriptionId", valid_594281
  var valid_594282 = path.getOrDefault("vaultName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "vaultName", valid_594282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_ItemLevelRecoveryConnectionsRevoke_594273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes an iSCSI connection which can be used to download a script. Executing this script opens a file explorer
  ## displaying all recoverable files and folders. This is an asynchronous operation.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_ItemLevelRecoveryConnectionsRevoke_594273;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  add(path_594286, "fabricName", newJString(fabricName))
  add(path_594286, "protectedItemName", newJString(protectedItemName))
  add(path_594286, "resourceGroupName", newJString(resourceGroupName))
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "recoveryPointId", newJString(recoveryPointId))
  add(path_594286, "containerName", newJString(containerName))
  add(path_594286, "subscriptionId", newJString(subscriptionId))
  add(path_594286, "vaultName", newJString(vaultName))
  result = call_594285.call(path_594286, query_594287, nil, nil, nil)

var itemLevelRecoveryConnectionsRevoke* = Call_ItemLevelRecoveryConnectionsRevoke_594273(
    name: "itemLevelRecoveryConnectionsRevoke", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/protectionContainers/{containerName}/protectedItems/{protectedItemName}/recoveryPoints/{recoveryPointId}/revokeInstantItemRecovery",
    validator: validate_ItemLevelRecoveryConnectionsRevoke_594274, base: "",
    url: url_ItemLevelRecoveryConnectionsRevoke_594275, schemes: {Scheme.Https})
type
  Call_ProtectionContainersRefresh_594288 = ref object of OpenApiRestCall_593438
proc url_ProtectionContainersRefresh_594290(protocol: Scheme; host: string;
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

proc validate_ProtectionContainersRefresh_594289(path: JsonNode; query: JsonNode;
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
  var valid_594291 = path.getOrDefault("fabricName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "fabricName", valid_594291
  var valid_594292 = path.getOrDefault("resourceGroupName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "resourceGroupName", valid_594292
  var valid_594293 = path.getOrDefault("subscriptionId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "subscriptionId", valid_594293
  var valid_594294 = path.getOrDefault("vaultName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "vaultName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  var valid_594296 = query.getOrDefault("$filter")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "$filter", valid_594296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594297: Call_ProtectionContainersRefresh_594288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Discovers all the containers in the subscription that can be backed up to Recovery Services Vault. This is an
  ## asynchronous operation. To know the status of the operation, call GetRefreshOperationResult API.
  ## 
  let valid = call_594297.validator(path, query, header, formData, body)
  let scheme = call_594297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594297.url(scheme.get, call_594297.host, call_594297.base,
                         call_594297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594297, url, valid)

proc call*(call_594298: Call_ProtectionContainersRefresh_594288;
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
  var path_594299 = newJObject()
  var query_594300 = newJObject()
  add(path_594299, "fabricName", newJString(fabricName))
  add(path_594299, "resourceGroupName", newJString(resourceGroupName))
  add(query_594300, "api-version", newJString(apiVersion))
  add(path_594299, "subscriptionId", newJString(subscriptionId))
  add(path_594299, "vaultName", newJString(vaultName))
  add(query_594300, "$filter", newJString(Filter))
  result = call_594298.call(path_594299, query_594300, nil, nil, nil)

var protectionContainersRefresh* = Call_ProtectionContainersRefresh_594288(
    name: "protectionContainersRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupFabrics/{fabricName}/refreshContainers",
    validator: validate_ProtectionContainersRefresh_594289, base: "",
    url: url_ProtectionContainersRefresh_594290, schemes: {Scheme.Https})
type
  Call_JobCancellationsTrigger_594301 = ref object of OpenApiRestCall_593438
proc url_JobCancellationsTrigger_594303(protocol: Scheme; host: string; base: string;
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

proc validate_JobCancellationsTrigger_594302(path: JsonNode; query: JsonNode;
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
  var valid_594304 = path.getOrDefault("resourceGroupName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "resourceGroupName", valid_594304
  var valid_594305 = path.getOrDefault("subscriptionId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "subscriptionId", valid_594305
  var valid_594306 = path.getOrDefault("jobName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "jobName", valid_594306
  var valid_594307 = path.getOrDefault("vaultName")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "vaultName", valid_594307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594308 = query.getOrDefault("api-version")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "api-version", valid_594308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594309: Call_JobCancellationsTrigger_594301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a job. This is an asynchronous operation. To know the status of the cancellation, call
  ## GetCancelOperationResult API.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_JobCancellationsTrigger_594301;
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
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  add(path_594311, "resourceGroupName", newJString(resourceGroupName))
  add(query_594312, "api-version", newJString(apiVersion))
  add(path_594311, "subscriptionId", newJString(subscriptionId))
  add(path_594311, "jobName", newJString(jobName))
  add(path_594311, "vaultName", newJString(vaultName))
  result = call_594310.call(path_594311, query_594312, nil, nil, nil)

var jobCancellationsTrigger* = Call_JobCancellationsTrigger_594301(
    name: "jobCancellationsTrigger", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/cancel",
    validator: validate_JobCancellationsTrigger_594302, base: "",
    url: url_JobCancellationsTrigger_594303, schemes: {Scheme.Https})
type
  Call_JobOperationResultsGet_594313 = ref object of OpenApiRestCall_593438
proc url_JobOperationResultsGet_594315(protocol: Scheme; host: string; base: string;
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

proc validate_JobOperationResultsGet_594314(path: JsonNode; query: JsonNode;
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
  var valid_594316 = path.getOrDefault("resourceGroupName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "resourceGroupName", valid_594316
  var valid_594317 = path.getOrDefault("subscriptionId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "subscriptionId", valid_594317
  var valid_594318 = path.getOrDefault("jobName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "jobName", valid_594318
  var valid_594319 = path.getOrDefault("vaultName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "vaultName", valid_594319
  var valid_594320 = path.getOrDefault("operationId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "operationId", valid_594320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594321 = query.getOrDefault("api-version")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "api-version", valid_594321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_JobOperationResultsGet_594313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the result of any operation.
  ## the operation.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_JobOperationResultsGet_594313;
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
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  add(path_594324, "resourceGroupName", newJString(resourceGroupName))
  add(query_594325, "api-version", newJString(apiVersion))
  add(path_594324, "subscriptionId", newJString(subscriptionId))
  add(path_594324, "jobName", newJString(jobName))
  add(path_594324, "vaultName", newJString(vaultName))
  add(path_594324, "operationId", newJString(operationId))
  result = call_594323.call(path_594324, query_594325, nil, nil, nil)

var jobOperationResultsGet* = Call_JobOperationResultsGet_594313(
    name: "jobOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}/operationResults/{operationId}",
    validator: validate_JobOperationResultsGet_594314, base: "",
    url: url_JobOperationResultsGet_594315, schemes: {Scheme.Https})
type
  Call_BackupOperationResultsGet_594326 = ref object of OpenApiRestCall_593438
proc url_BackupOperationResultsGet_594328(protocol: Scheme; host: string;
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

proc validate_BackupOperationResultsGet_594327(path: JsonNode; query: JsonNode;
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
  var valid_594329 = path.getOrDefault("resourceGroupName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resourceGroupName", valid_594329
  var valid_594330 = path.getOrDefault("subscriptionId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "subscriptionId", valid_594330
  var valid_594331 = path.getOrDefault("vaultName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "vaultName", valid_594331
  var valid_594332 = path.getOrDefault("operationId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "operationId", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594333 = query.getOrDefault("api-version")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "api-version", valid_594333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594334: Call_BackupOperationResultsGet_594326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the status of the delete operations such as deleting backed up item. Once the operation has started, the
  ## status code in the response would be Accepted. It will continue to be in this state till it reaches completion. On
  ## successful completion, the status code will be OK. This method expects OperationID as an argument. OperationID is
  ## part of the Location header of the operation response.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_BackupOperationResultsGet_594326;
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
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  add(path_594336, "resourceGroupName", newJString(resourceGroupName))
  add(query_594337, "api-version", newJString(apiVersion))
  add(path_594336, "subscriptionId", newJString(subscriptionId))
  add(path_594336, "vaultName", newJString(vaultName))
  add(path_594336, "operationId", newJString(operationId))
  result = call_594335.call(path_594336, query_594337, nil, nil, nil)

var backupOperationResultsGet* = Call_BackupOperationResultsGet_594326(
    name: "backupOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperationResults/{operationId}",
    validator: validate_BackupOperationResultsGet_594327, base: "",
    url: url_BackupOperationResultsGet_594328, schemes: {Scheme.Https})
type
  Call_BackupOperationStatusesGet_594338 = ref object of OpenApiRestCall_593438
proc url_BackupOperationStatusesGet_594340(protocol: Scheme; host: string;
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

proc validate_BackupOperationStatusesGet_594339(path: JsonNode; query: JsonNode;
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
  var valid_594341 = path.getOrDefault("resourceGroupName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "resourceGroupName", valid_594341
  var valid_594342 = path.getOrDefault("subscriptionId")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "subscriptionId", valid_594342
  var valid_594343 = path.getOrDefault("vaultName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "vaultName", valid_594343
  var valid_594344 = path.getOrDefault("operationId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "operationId", valid_594344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594345 = query.getOrDefault("api-version")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "api-version", valid_594345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594346: Call_BackupOperationStatusesGet_594338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches the status of an operation such as triggering a backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the OperationStatus enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs when the operation is complete.
  ## 
  let valid = call_594346.validator(path, query, header, formData, body)
  let scheme = call_594346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594346.url(scheme.get, call_594346.host, call_594346.base,
                         call_594346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594346, url, valid)

proc call*(call_594347: Call_BackupOperationStatusesGet_594338;
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
  var path_594348 = newJObject()
  var query_594349 = newJObject()
  add(path_594348, "resourceGroupName", newJString(resourceGroupName))
  add(query_594349, "api-version", newJString(apiVersion))
  add(path_594348, "subscriptionId", newJString(subscriptionId))
  add(path_594348, "vaultName", newJString(vaultName))
  add(path_594348, "operationId", newJString(operationId))
  result = call_594347.call(path_594348, query_594349, nil, nil, nil)

var backupOperationStatusesGet* = Call_BackupOperationStatusesGet_594338(
    name: "backupOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupOperations/{operationId}",
    validator: validate_BackupOperationStatusesGet_594339, base: "",
    url: url_BackupOperationStatusesGet_594340, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesCreateOrUpdate_594362 = ref object of OpenApiRestCall_593438
proc url_ProtectionPoliciesCreateOrUpdate_594364(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesCreateOrUpdate_594363(path: JsonNode;
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
  var valid_594365 = path.getOrDefault("resourceGroupName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "resourceGroupName", valid_594365
  var valid_594366 = path.getOrDefault("subscriptionId")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "subscriptionId", valid_594366
  var valid_594367 = path.getOrDefault("policyName")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "policyName", valid_594367
  var valid_594368 = path.getOrDefault("vaultName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "vaultName", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : resource backup policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594371: Call_ProtectionPoliciesCreateOrUpdate_594362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or modifies a backup policy. This is an asynchronous operation. Status of the operation can be fetched
  ## using GetPolicyOperationResult API.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_ProtectionPoliciesCreateOrUpdate_594362;
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
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  var body_594375 = newJObject()
  add(path_594373, "resourceGroupName", newJString(resourceGroupName))
  add(query_594374, "api-version", newJString(apiVersion))
  add(path_594373, "subscriptionId", newJString(subscriptionId))
  add(path_594373, "policyName", newJString(policyName))
  add(path_594373, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594375 = parameters
  result = call_594372.call(path_594373, query_594374, nil, nil, body_594375)

var protectionPoliciesCreateOrUpdate* = Call_ProtectionPoliciesCreateOrUpdate_594362(
    name: "protectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesCreateOrUpdate_594363, base: "",
    url: url_ProtectionPoliciesCreateOrUpdate_594364, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesGet_594350 = ref object of OpenApiRestCall_593438
proc url_ProtectionPoliciesGet_594352(protocol: Scheme; host: string; base: string;
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

proc validate_ProtectionPoliciesGet_594351(path: JsonNode; query: JsonNode;
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
  var valid_594353 = path.getOrDefault("resourceGroupName")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "resourceGroupName", valid_594353
  var valid_594354 = path.getOrDefault("subscriptionId")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "subscriptionId", valid_594354
  var valid_594355 = path.getOrDefault("policyName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "policyName", valid_594355
  var valid_594356 = path.getOrDefault("vaultName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "vaultName", valid_594356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594357 = query.getOrDefault("api-version")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "api-version", valid_594357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594358: Call_ProtectionPoliciesGet_594350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides the details of the backup policies associated to Recovery Services Vault. This is an asynchronous
  ## operation. Status of the operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_594358.validator(path, query, header, formData, body)
  let scheme = call_594358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594358.url(scheme.get, call_594358.host, call_594358.base,
                         call_594358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594358, url, valid)

proc call*(call_594359: Call_ProtectionPoliciesGet_594350;
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
  var path_594360 = newJObject()
  var query_594361 = newJObject()
  add(path_594360, "resourceGroupName", newJString(resourceGroupName))
  add(query_594361, "api-version", newJString(apiVersion))
  add(path_594360, "subscriptionId", newJString(subscriptionId))
  add(path_594360, "policyName", newJString(policyName))
  add(path_594360, "vaultName", newJString(vaultName))
  result = call_594359.call(path_594360, query_594361, nil, nil, nil)

var protectionPoliciesGet* = Call_ProtectionPoliciesGet_594350(
    name: "protectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesGet_594351, base: "",
    url: url_ProtectionPoliciesGet_594352, schemes: {Scheme.Https})
type
  Call_ProtectionPoliciesDelete_594376 = ref object of OpenApiRestCall_593438
proc url_ProtectionPoliciesDelete_594378(protocol: Scheme; host: string;
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

proc validate_ProtectionPoliciesDelete_594377(path: JsonNode; query: JsonNode;
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
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("subscriptionId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "subscriptionId", valid_594380
  var valid_594381 = path.getOrDefault("policyName")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "policyName", valid_594381
  var valid_594382 = path.getOrDefault("vaultName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "vaultName", valid_594382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594384: Call_ProtectionPoliciesDelete_594376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified backup policy from your Recovery Services Vault. This is an asynchronous operation. Status of the
  ## operation can be fetched using GetPolicyOperationResult API.
  ## 
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_ProtectionPoliciesDelete_594376;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  add(path_594386, "resourceGroupName", newJString(resourceGroupName))
  add(query_594387, "api-version", newJString(apiVersion))
  add(path_594386, "subscriptionId", newJString(subscriptionId))
  add(path_594386, "policyName", newJString(policyName))
  add(path_594386, "vaultName", newJString(vaultName))
  result = call_594385.call(path_594386, query_594387, nil, nil, nil)

var protectionPoliciesDelete* = Call_ProtectionPoliciesDelete_594376(
    name: "protectionPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}",
    validator: validate_ProtectionPoliciesDelete_594377, base: "",
    url: url_ProtectionPoliciesDelete_594378, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationResultsGet_594388 = ref object of OpenApiRestCall_593438
proc url_ProtectionPolicyOperationResultsGet_594390(protocol: Scheme; host: string;
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

proc validate_ProtectionPolicyOperationResultsGet_594389(path: JsonNode;
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
  var valid_594391 = path.getOrDefault("resourceGroupName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "resourceGroupName", valid_594391
  var valid_594392 = path.getOrDefault("subscriptionId")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "subscriptionId", valid_594392
  var valid_594393 = path.getOrDefault("policyName")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "policyName", valid_594393
  var valid_594394 = path.getOrDefault("vaultName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "vaultName", valid_594394
  var valid_594395 = path.getOrDefault("operationId")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "operationId", valid_594395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594396 = query.getOrDefault("api-version")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "api-version", valid_594396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594397: Call_ProtectionPolicyOperationResultsGet_594388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the result of an operation.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_ProtectionPolicyOperationResultsGet_594388;
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
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  add(path_594399, "resourceGroupName", newJString(resourceGroupName))
  add(query_594400, "api-version", newJString(apiVersion))
  add(path_594399, "subscriptionId", newJString(subscriptionId))
  add(path_594399, "policyName", newJString(policyName))
  add(path_594399, "vaultName", newJString(vaultName))
  add(path_594399, "operationId", newJString(operationId))
  result = call_594398.call(path_594399, query_594400, nil, nil, nil)

var protectionPolicyOperationResultsGet* = Call_ProtectionPolicyOperationResultsGet_594388(
    name: "protectionPolicyOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operationResults/{operationId}",
    validator: validate_ProtectionPolicyOperationResultsGet_594389, base: "",
    url: url_ProtectionPolicyOperationResultsGet_594390, schemes: {Scheme.Https})
type
  Call_ProtectionPolicyOperationStatusesGet_594401 = ref object of OpenApiRestCall_593438
proc url_ProtectionPolicyOperationStatusesGet_594403(protocol: Scheme;
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

proc validate_ProtectionPolicyOperationStatusesGet_594402(path: JsonNode;
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
  var valid_594404 = path.getOrDefault("resourceGroupName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "resourceGroupName", valid_594404
  var valid_594405 = path.getOrDefault("subscriptionId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "subscriptionId", valid_594405
  var valid_594406 = path.getOrDefault("policyName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "policyName", valid_594406
  var valid_594407 = path.getOrDefault("vaultName")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "vaultName", valid_594407
  var valid_594408 = path.getOrDefault("operationId")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "operationId", valid_594408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594409 = query.getOrDefault("api-version")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "api-version", valid_594409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594410: Call_ProtectionPolicyOperationStatusesGet_594401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provides the status of the asynchronous operations like backup, restore. The status can be in progress, completed
  ## or failed. You can refer to the Operation Status enum for all the possible states of an operation. Some operations
  ## create jobs. This method returns the list of jobs associated with operation.
  ## 
  let valid = call_594410.validator(path, query, header, formData, body)
  let scheme = call_594410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594410.url(scheme.get, call_594410.host, call_594410.base,
                         call_594410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594410, url, valid)

proc call*(call_594411: Call_ProtectionPolicyOperationStatusesGet_594401;
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
  var path_594412 = newJObject()
  var query_594413 = newJObject()
  add(path_594412, "resourceGroupName", newJString(resourceGroupName))
  add(query_594413, "api-version", newJString(apiVersion))
  add(path_594412, "subscriptionId", newJString(subscriptionId))
  add(path_594412, "policyName", newJString(policyName))
  add(path_594412, "vaultName", newJString(vaultName))
  add(path_594412, "operationId", newJString(operationId))
  result = call_594411.call(path_594412, query_594413, nil, nil, nil)

var protectionPolicyOperationStatusesGet* = Call_ProtectionPolicyOperationStatusesGet_594401(
    name: "protectionPolicyOperationStatusesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}/operations/{operationId}",
    validator: validate_ProtectionPolicyOperationStatusesGet_594402, base: "",
    url: url_ProtectionPolicyOperationStatusesGet_594403, schemes: {Scheme.Https})
type
  Call_BackupProtectableItemsList_594414 = ref object of OpenApiRestCall_593438
proc url_BackupProtectableItemsList_594416(protocol: Scheme; host: string;
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

proc validate_BackupProtectableItemsList_594415(path: JsonNode; query: JsonNode;
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
  var valid_594417 = path.getOrDefault("resourceGroupName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "resourceGroupName", valid_594417
  var valid_594418 = path.getOrDefault("subscriptionId")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "subscriptionId", valid_594418
  var valid_594419 = path.getOrDefault("vaultName")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "vaultName", valid_594419
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
  var valid_594420 = query.getOrDefault("api-version")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "api-version", valid_594420
  var valid_594421 = query.getOrDefault("$skipToken")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "$skipToken", valid_594421
  var valid_594422 = query.getOrDefault("$filter")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "$filter", valid_594422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594423: Call_BackupProtectableItemsList_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of protectable objects within your subscription according to the query filter and the
  ## pagination parameters.
  ## 
  let valid = call_594423.validator(path, query, header, formData, body)
  let scheme = call_594423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594423.url(scheme.get, call_594423.host, call_594423.base,
                         call_594423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594423, url, valid)

proc call*(call_594424: Call_BackupProtectableItemsList_594414;
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
  var path_594425 = newJObject()
  var query_594426 = newJObject()
  add(path_594425, "resourceGroupName", newJString(resourceGroupName))
  add(query_594426, "api-version", newJString(apiVersion))
  add(path_594425, "subscriptionId", newJString(subscriptionId))
  add(path_594425, "vaultName", newJString(vaultName))
  add(query_594426, "$skipToken", newJString(SkipToken))
  add(query_594426, "$filter", newJString(Filter))
  result = call_594424.call(path_594425, query_594426, nil, nil, nil)

var backupProtectableItemsList* = Call_BackupProtectableItemsList_594414(
    name: "backupProtectableItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectableItems",
    validator: validate_BackupProtectableItemsList_594415, base: "",
    url: url_BackupProtectableItemsList_594416, schemes: {Scheme.Https})
type
  Call_BackupProtectionContainersList_594427 = ref object of OpenApiRestCall_593438
proc url_BackupProtectionContainersList_594429(protocol: Scheme; host: string;
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

proc validate_BackupProtectionContainersList_594428(path: JsonNode;
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
  var valid_594430 = path.getOrDefault("resourceGroupName")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "resourceGroupName", valid_594430
  var valid_594431 = path.getOrDefault("subscriptionId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "subscriptionId", valid_594431
  var valid_594432 = path.getOrDefault("vaultName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "vaultName", valid_594432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594433 = query.getOrDefault("api-version")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "api-version", valid_594433
  var valid_594434 = query.getOrDefault("$filter")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "$filter", valid_594434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594435: Call_BackupProtectionContainersList_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the containers registered to Recovery Services Vault.
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_BackupProtectionContainersList_594427;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  add(path_594437, "resourceGroupName", newJString(resourceGroupName))
  add(query_594438, "api-version", newJString(apiVersion))
  add(path_594437, "subscriptionId", newJString(subscriptionId))
  add(path_594437, "vaultName", newJString(vaultName))
  add(query_594438, "$filter", newJString(Filter))
  result = call_594436.call(path_594437, query_594438, nil, nil, nil)

var backupProtectionContainersList* = Call_BackupProtectionContainersList_594427(
    name: "backupProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupProtectionContainers",
    validator: validate_BackupProtectionContainersList_594428, base: "",
    url: url_BackupProtectionContainersList_594429, schemes: {Scheme.Https})
type
  Call_SecurityPINsGet_594439 = ref object of OpenApiRestCall_593438
proc url_SecurityPINsGet_594441(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityPINsGet_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = path.getOrDefault("resourceGroupName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "resourceGroupName", valid_594442
  var valid_594443 = path.getOrDefault("subscriptionId")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "subscriptionId", valid_594443
  var valid_594444 = path.getOrDefault("vaultName")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "vaultName", valid_594444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594445 = query.getOrDefault("api-version")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "api-version", valid_594445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_SecurityPINsGet_594439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the security PIN.
  ## 
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_SecurityPINsGet_594439; resourceGroupName: string;
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
  var path_594448 = newJObject()
  var query_594449 = newJObject()
  add(path_594448, "resourceGroupName", newJString(resourceGroupName))
  add(query_594449, "api-version", newJString(apiVersion))
  add(path_594448, "subscriptionId", newJString(subscriptionId))
  add(path_594448, "vaultName", newJString(vaultName))
  result = call_594447.call(path_594448, query_594449, nil, nil, nil)

var securityPINsGet* = Call_SecurityPINsGet_594439(name: "securityPINsGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupSecurityPIN",
    validator: validate_SecurityPINsGet_594440, base: "", url: url_SecurityPINsGet_594441,
    schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsGet_594450 = ref object of OpenApiRestCall_593438
proc url_BackupResourceVaultConfigsGet_594452(protocol: Scheme; host: string;
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

proc validate_BackupResourceVaultConfigsGet_594451(path: JsonNode; query: JsonNode;
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
  var valid_594453 = path.getOrDefault("resourceGroupName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "resourceGroupName", valid_594453
  var valid_594454 = path.getOrDefault("subscriptionId")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "subscriptionId", valid_594454
  var valid_594455 = path.getOrDefault("vaultName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "vaultName", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_BackupResourceVaultConfigsGet_594450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetches resource vault config.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_BackupResourceVaultConfigsGet_594450;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "resourceGroupName", newJString(resourceGroupName))
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "subscriptionId", newJString(subscriptionId))
  add(path_594459, "vaultName", newJString(vaultName))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var backupResourceVaultConfigsGet* = Call_BackupResourceVaultConfigsGet_594450(
    name: "backupResourceVaultConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsGet_594451, base: "",
    url: url_BackupResourceVaultConfigsGet_594452, schemes: {Scheme.Https})
type
  Call_BackupResourceVaultConfigsUpdate_594461 = ref object of OpenApiRestCall_593438
proc url_BackupResourceVaultConfigsUpdate_594463(protocol: Scheme; host: string;
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

proc validate_BackupResourceVaultConfigsUpdate_594462(path: JsonNode;
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("subscriptionId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "subscriptionId", valid_594465
  var valid_594466 = path.getOrDefault("vaultName")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "vaultName", valid_594466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594467 = query.getOrDefault("api-version")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "api-version", valid_594467
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

proc call*(call_594469: Call_BackupResourceVaultConfigsUpdate_594461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault security config.
  ## 
  let valid = call_594469.validator(path, query, header, formData, body)
  let scheme = call_594469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594469.url(scheme.get, call_594469.host, call_594469.base,
                         call_594469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594469, url, valid)

proc call*(call_594470: Call_BackupResourceVaultConfigsUpdate_594461;
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
  var path_594471 = newJObject()
  var query_594472 = newJObject()
  var body_594473 = newJObject()
  add(path_594471, "resourceGroupName", newJString(resourceGroupName))
  add(query_594472, "api-version", newJString(apiVersion))
  add(path_594471, "subscriptionId", newJString(subscriptionId))
  add(path_594471, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594473 = parameters
  result = call_594470.call(path_594471, query_594472, nil, nil, body_594473)

var backupResourceVaultConfigsUpdate* = Call_BackupResourceVaultConfigsUpdate_594461(
    name: "backupResourceVaultConfigsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupconfig/vaultconfig",
    validator: validate_BackupResourceVaultConfigsUpdate_594462, base: "",
    url: url_BackupResourceVaultConfigsUpdate_594463, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsUpdate_594485 = ref object of OpenApiRestCall_593438
proc url_BackupResourceStorageConfigsUpdate_594487(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsUpdate_594486(path: JsonNode;
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
  var valid_594488 = path.getOrDefault("resourceGroupName")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "resourceGroupName", valid_594488
  var valid_594489 = path.getOrDefault("subscriptionId")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "subscriptionId", valid_594489
  var valid_594490 = path.getOrDefault("vaultName")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "vaultName", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594491 = query.getOrDefault("api-version")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "api-version", valid_594491
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

proc call*(call_594493: Call_BackupResourceStorageConfigsUpdate_594485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_594493.validator(path, query, header, formData, body)
  let scheme = call_594493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594493.url(scheme.get, call_594493.host, call_594493.base,
                         call_594493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594493, url, valid)

proc call*(call_594494: Call_BackupResourceStorageConfigsUpdate_594485;
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
  var path_594495 = newJObject()
  var query_594496 = newJObject()
  var body_594497 = newJObject()
  add(path_594495, "resourceGroupName", newJString(resourceGroupName))
  add(query_594496, "api-version", newJString(apiVersion))
  add(path_594495, "subscriptionId", newJString(subscriptionId))
  add(path_594495, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594497 = parameters
  result = call_594494.call(path_594495, query_594496, nil, nil, body_594497)

var backupResourceStorageConfigsUpdate* = Call_BackupResourceStorageConfigsUpdate_594485(
    name: "backupResourceStorageConfigsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsUpdate_594486, base: "",
    url: url_BackupResourceStorageConfigsUpdate_594487, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsGet_594474 = ref object of OpenApiRestCall_593438
proc url_BackupResourceStorageConfigsGet_594476(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsGet_594475(path: JsonNode;
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
  var valid_594477 = path.getOrDefault("resourceGroupName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "resourceGroupName", valid_594477
  var valid_594478 = path.getOrDefault("subscriptionId")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "subscriptionId", valid_594478
  var valid_594479 = path.getOrDefault("vaultName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "vaultName", valid_594479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594480 = query.getOrDefault("api-version")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "api-version", valid_594480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594481: Call_BackupResourceStorageConfigsGet_594474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches resource storage config.
  ## 
  let valid = call_594481.validator(path, query, header, formData, body)
  let scheme = call_594481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594481.url(scheme.get, call_594481.host, call_594481.base,
                         call_594481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594481, url, valid)

proc call*(call_594482: Call_BackupResourceStorageConfigsGet_594474;
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
  var path_594483 = newJObject()
  var query_594484 = newJObject()
  add(path_594483, "resourceGroupName", newJString(resourceGroupName))
  add(query_594484, "api-version", newJString(apiVersion))
  add(path_594483, "subscriptionId", newJString(subscriptionId))
  add(path_594483, "vaultName", newJString(vaultName))
  result = call_594482.call(path_594483, query_594484, nil, nil, nil)

var backupResourceStorageConfigsGet* = Call_BackupResourceStorageConfigsGet_594474(
    name: "backupResourceStorageConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsGet_594475, base: "",
    url: url_BackupResourceStorageConfigsGet_594476, schemes: {Scheme.Https})
type
  Call_BackupResourceStorageConfigsPatch_594498 = ref object of OpenApiRestCall_593438
proc url_BackupResourceStorageConfigsPatch_594500(protocol: Scheme; host: string;
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

proc validate_BackupResourceStorageConfigsPatch_594499(path: JsonNode;
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
  var valid_594501 = path.getOrDefault("resourceGroupName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "resourceGroupName", valid_594501
  var valid_594502 = path.getOrDefault("subscriptionId")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "subscriptionId", valid_594502
  var valid_594503 = path.getOrDefault("vaultName")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "vaultName", valid_594503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "api-version", valid_594504
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

proc call*(call_594506: Call_BackupResourceStorageConfigsPatch_594498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates vault storage model type.
  ## 
  let valid = call_594506.validator(path, query, header, formData, body)
  let scheme = call_594506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594506.url(scheme.get, call_594506.host, call_594506.base,
                         call_594506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594506, url, valid)

proc call*(call_594507: Call_BackupResourceStorageConfigsPatch_594498;
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
  var path_594508 = newJObject()
  var query_594509 = newJObject()
  var body_594510 = newJObject()
  add(path_594508, "resourceGroupName", newJString(resourceGroupName))
  add(query_594509, "api-version", newJString(apiVersion))
  add(path_594508, "subscriptionId", newJString(subscriptionId))
  add(path_594508, "vaultName", newJString(vaultName))
  if parameters != nil:
    body_594510 = parameters
  result = call_594507.call(path_594508, query_594509, nil, nil, body_594510)

var backupResourceStorageConfigsPatch* = Call_BackupResourceStorageConfigsPatch_594498(
    name: "backupResourceStorageConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupstorageconfig/vaultstorageconfig",
    validator: validate_BackupResourceStorageConfigsPatch_594499, base: "",
    url: url_BackupResourceStorageConfigsPatch_594500, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
