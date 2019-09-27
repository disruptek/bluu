
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SiteRecoveryManagementClient
## version: 2018-01-10
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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicessiterecovery-service"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593663(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsList_593662(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Operation to return the list of available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593838 = query.getOrDefault("api-version")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "api-version", valid_593838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593861: Call_OperationsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_OperationsList_593661; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  var path_593933 = newJObject()
  var query_593935 = newJObject()
  add(path_593933, "resourceGroupName", newJString(resourceGroupName))
  add(query_593935, "api-version", newJString(apiVersion))
  add(path_593933, "subscriptionId", newJString(subscriptionId))
  result = call_593932.call(path_593933, query_593935, nil, nil, nil)

var operationsList* = Call_OperationsList_593661(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_593662, base: "", url: url_OperationsList_593663,
    schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsList_593974 = ref object of OpenApiRestCall_593439
proc url_ReplicationAlertSettingsList_593976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsList_593975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
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
  var valid_593979 = path.getOrDefault("resourceName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceName", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_ReplicationAlertSettingsList_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_ReplicationAlertSettingsList_593974;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationAlertSettingsList
  ## Gets the list of email notification(alert) configurations for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(path_593983, "resourceGroupName", newJString(resourceGroupName))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(path_593983, "resourceName", newJString(resourceName))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var replicationAlertSettingsList* = Call_ReplicationAlertSettingsList_593974(
    name: "replicationAlertSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings",
    validator: validate_ReplicationAlertSettingsList_593975, base: "",
    url: url_ReplicationAlertSettingsList_593976, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsCreate_593997 = ref object of OpenApiRestCall_593439
proc url_ReplicationAlertSettingsCreate_593999(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "alertSettingName" in path,
        "`alertSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings/"),
               (kind: VariableSegment, value: "alertSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsCreate_593998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("alertSettingName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "alertSettingName", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("resourceName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceName", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The input to configure the email notification(alert).
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_ReplicationAlertSettingsCreate_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an email notification(alert) configuration.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ReplicationAlertSettingsCreate_593997;
          resourceGroupName: string; apiVersion: string; alertSettingName: string;
          subscriptionId: string; resourceName: string; request: JsonNode): Recallable =
  ## replicationAlertSettingsCreate
  ## Create or update an email notification(alert) configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   request: JObject (required)
  ##          : The input to configure the email notification(alert).
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "alertSettingName", newJString(alertSettingName))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "resourceName", newJString(resourceName))
  if request != nil:
    body_594010 = request
  result = call_594007.call(path_594008, query_594009, nil, nil, body_594010)

var replicationAlertSettingsCreate* = Call_ReplicationAlertSettingsCreate_593997(
    name: "replicationAlertSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsCreate_593998, base: "",
    url: url_ReplicationAlertSettingsCreate_593999, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsGet_593985 = ref object of OpenApiRestCall_593439
proc url_ReplicationAlertSettingsGet_593987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "alertSettingName" in path,
        "`alertSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings/"),
               (kind: VariableSegment, value: "alertSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsGet_593986(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593988 = path.getOrDefault("resourceGroupName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "resourceGroupName", valid_593988
  var valid_593989 = path.getOrDefault("alertSettingName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "alertSettingName", valid_593989
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  var valid_593991 = path.getOrDefault("resourceName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "resourceName", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ReplicationAlertSettingsGet_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ReplicationAlertSettingsGet_593985;
          resourceGroupName: string; apiVersion: string; alertSettingName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationAlertSettingsGet
  ## Gets the details of the specified email notification(alert) configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(path_593995, "resourceGroupName", newJString(resourceGroupName))
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "alertSettingName", newJString(alertSettingName))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(path_593995, "resourceName", newJString(resourceName))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var replicationAlertSettingsGet* = Call_ReplicationAlertSettingsGet_593985(
    name: "replicationAlertSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsGet_593986, base: "",
    url: url_ReplicationAlertSettingsGet_593987, schemes: {Scheme.Https})
type
  Call_ReplicationEventsList_594011 = ref object of OpenApiRestCall_593439
proc url_ReplicationEventsList_594013(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationEventsList_594012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  var valid_594017 = path.getOrDefault("resourceName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "resourceName", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  var valid_594019 = query.getOrDefault("$filter")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "$filter", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_ReplicationEventsList_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ReplicationEventsList_594011;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; Filter: string = ""): Recallable =
  ## replicationEventsList
  ## Gets the list of Azure Site Recovery events for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(path_594022, "resourceName", newJString(resourceName))
  add(query_594023, "$filter", newJString(Filter))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var replicationEventsList* = Call_ReplicationEventsList_594011(
    name: "replicationEventsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents",
    validator: validate_ReplicationEventsList_594012, base: "",
    url: url_ReplicationEventsList_594013, schemes: {Scheme.Https})
type
  Call_ReplicationEventsGet_594024 = ref object of OpenApiRestCall_593439
proc url_ReplicationEventsGet_594026(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationEventsGet_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   eventName: JString (required)
  ##            : The name of the Azure Site Recovery event.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  var valid_594029 = path.getOrDefault("resourceName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceName", valid_594029
  var valid_594030 = path.getOrDefault("eventName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "eventName", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_ReplicationEventsGet_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_ReplicationEventsGet_594024;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; eventName: string): Recallable =
  ## replicationEventsGet
  ## The operation to get the details of an Azure Site recovery event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   eventName: string (required)
  ##            : The name of the Azure Site Recovery event.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(path_594034, "resourceName", newJString(resourceName))
  add(path_594034, "eventName", newJString(eventName))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var replicationEventsGet* = Call_ReplicationEventsGet_594024(
    name: "replicationEventsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents/{eventName}",
    validator: validate_ReplicationEventsGet_594025, base: "",
    url: url_ReplicationEventsGet_594026, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsList_594036 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsList_594038(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsList_594037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  var valid_594041 = path.getOrDefault("resourceName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceName", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_ReplicationFabricsList_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_ReplicationFabricsList_594036;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsList
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(path_594045, "resourceName", newJString(resourceName))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var replicationFabricsList* = Call_ReplicationFabricsList_594036(
    name: "replicationFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics",
    validator: validate_ReplicationFabricsList_594037, base: "",
    url: url_ReplicationFabricsList_594038, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCreate_594059 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsCreate_594061(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsCreate_594060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the ASR fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594062 = path.getOrDefault("fabricName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "fabricName", valid_594062
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("resourceName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Fabric creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594068: Call_ReplicationFabricsCreate_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_ReplicationFabricsCreate_594059; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationFabricsCreate
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ##   fabricName: string (required)
  ##             : Name of the ASR fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Fabric creation input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  var body_594072 = newJObject()
  add(path_594070, "fabricName", newJString(fabricName))
  add(path_594070, "resourceGroupName", newJString(resourceGroupName))
  add(query_594071, "api-version", newJString(apiVersion))
  add(path_594070, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594072 = input
  add(path_594070, "resourceName", newJString(resourceName))
  result = call_594069.call(path_594070, query_594071, nil, nil, body_594072)

var replicationFabricsCreate* = Call_ReplicationFabricsCreate_594059(
    name: "replicationFabricsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsCreate_594060, base: "",
    url: url_ReplicationFabricsCreate_594061, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsGet_594047 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsGet_594049(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsGet_594048(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
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
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  var valid_594053 = path.getOrDefault("resourceName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceName", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_ReplicationFabricsGet_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ReplicationFabricsGet_594047; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsGet
  ## Gets the details of an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(path_594057, "fabricName", newJString(fabricName))
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "resourceName", newJString(resourceName))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var replicationFabricsGet* = Call_ReplicationFabricsGet_594047(
    name: "replicationFabricsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsGet_594048, base: "",
    url: url_ReplicationFabricsGet_594049, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsPurge_594073 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsPurge_594075(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsPurge_594074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to purge.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594076 = path.getOrDefault("fabricName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fabricName", valid_594076
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("resourceName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_ReplicationFabricsPurge_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_ReplicationFabricsPurge_594073; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsPurge
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : ASR fabric to purge.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "fabricName", newJString(fabricName))
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "resourceName", newJString(resourceName))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var replicationFabricsPurge* = Call_ReplicationFabricsPurge_594073(
    name: "replicationFabricsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsPurge_594074, base: "",
    url: url_ReplicationFabricsPurge_594075, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCheckConsistency_594085 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsCheckConsistency_594087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/checkConsistency")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsCheckConsistency_594086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform a consistency check on the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594088 = path.getOrDefault("fabricName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "fabricName", valid_594088
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("resourceName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "resourceName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_ReplicationFabricsCheckConsistency_594085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform a consistency check on the fabric.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_ReplicationFabricsCheckConsistency_594085;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationFabricsCheckConsistency
  ## The operation to perform a consistency check on the fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "fabricName", newJString(fabricName))
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "resourceName", newJString(resourceName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var replicationFabricsCheckConsistency* = Call_ReplicationFabricsCheckConsistency_594085(
    name: "replicationFabricsCheckConsistency", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/checkConsistency",
    validator: validate_ReplicationFabricsCheckConsistency_594086, base: "",
    url: url_ReplicationFabricsCheckConsistency_594087, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsMigrateToAad_594097 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsMigrateToAad_594099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/migratetoaad")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsMigrateToAad_594098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to migrate.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594100 = path.getOrDefault("fabricName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "fabricName", valid_594100
  var valid_594101 = path.getOrDefault("resourceGroupName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "resourceGroupName", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  var valid_594103 = path.getOrDefault("resourceName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594105: Call_ReplicationFabricsMigrateToAad_594097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ReplicationFabricsMigrateToAad_594097;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationFabricsMigrateToAad
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ##   fabricName: string (required)
  ##             : ASR fabric to migrate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "fabricName", newJString(fabricName))
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "resourceName", newJString(resourceName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var replicationFabricsMigrateToAad* = Call_ReplicationFabricsMigrateToAad_594097(
    name: "replicationFabricsMigrateToAad", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/migratetoaad",
    validator: validate_ReplicationFabricsMigrateToAad_594098, base: "",
    url: url_ReplicationFabricsMigrateToAad_594099, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsReassociateGateway_594109 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsReassociateGateway_594111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/reassociateGateway")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsReassociateGateway_594110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to move replications from a process server to another process server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the process server.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594112 = path.getOrDefault("fabricName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fabricName", valid_594112
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("resourceName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "resourceName", valid_594115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverProcessServerRequest: JObject (required)
  ##                               : The input to the failover process server operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_ReplicationFabricsReassociateGateway_594109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to move replications from a process server to another process server.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ReplicationFabricsReassociateGateway_594109;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          failoverProcessServerRequest: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsReassociateGateway
  ## The operation to move replications from a process server to another process server.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the process server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   failoverProcessServerRequest: JObject (required)
  ##                               : The input to the failover process server operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(path_594120, "fabricName", newJString(fabricName))
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  if failoverProcessServerRequest != nil:
    body_594122 = failoverProcessServerRequest
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "resourceName", newJString(resourceName))
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var replicationFabricsReassociateGateway* = Call_ReplicationFabricsReassociateGateway_594109(
    name: "replicationFabricsReassociateGateway", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/reassociateGateway",
    validator: validate_ReplicationFabricsReassociateGateway_594110, base: "",
    url: url_ReplicationFabricsReassociateGateway_594111, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsDelete_594123 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsDelete_594125(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsDelete_594124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to delete
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594126 = path.getOrDefault("fabricName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "fabricName", valid_594126
  var valid_594127 = path.getOrDefault("resourceGroupName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "resourceGroupName", valid_594127
  var valid_594128 = path.getOrDefault("subscriptionId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "subscriptionId", valid_594128
  var valid_594129 = path.getOrDefault("resourceName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceName", valid_594129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_ReplicationFabricsDelete_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_ReplicationFabricsDelete_594123; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsDelete
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : ASR fabric to delete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "fabricName", newJString(fabricName))
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "resourceName", newJString(resourceName))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var replicationFabricsDelete* = Call_ReplicationFabricsDelete_594123(
    name: "replicationFabricsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/remove",
    validator: validate_ReplicationFabricsDelete_594124, base: "",
    url: url_ReplicationFabricsDelete_594125, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsRenewCertificate_594135 = ref object of OpenApiRestCall_593439
proc url_ReplicationFabricsRenewCertificate_594137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/renewCertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsRenewCertificate_594136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : fabric name to renew certs for.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594138 = path.getOrDefault("fabricName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "fabricName", valid_594138
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("resourceName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceName", valid_594141
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
  ##   renewCertificate: JObject (required)
  ##                   : Renew certificate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_ReplicationFabricsRenewCertificate_594135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_ReplicationFabricsRenewCertificate_594135;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; renewCertificate: JsonNode; resourceName: string): Recallable =
  ## replicationFabricsRenewCertificate
  ## Renews the connection certificate for the ASR replication fabric.
  ##   fabricName: string (required)
  ##             : fabric name to renew certs for.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   renewCertificate: JObject (required)
  ##                   : Renew certificate input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  var body_594148 = newJObject()
  add(path_594146, "fabricName", newJString(fabricName))
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  if renewCertificate != nil:
    body_594148 = renewCertificate
  add(path_594146, "resourceName", newJString(resourceName))
  result = call_594145.call(path_594146, query_594147, nil, nil, body_594148)

var replicationFabricsRenewCertificate* = Call_ReplicationFabricsRenewCertificate_594135(
    name: "replicationFabricsRenewCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/renewCertificate",
    validator: validate_ReplicationFabricsRenewCertificate_594136, base: "",
    url: url_ReplicationFabricsRenewCertificate_594137, schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksListByReplicationFabrics_594149 = ref object of OpenApiRestCall_593439
proc url_ReplicationLogicalNetworksListByReplicationFabrics_594151(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationLogicalNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLogicalNetworksListByReplicationFabrics_594150(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594152 = path.getOrDefault("fabricName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "fabricName", valid_594152
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594155 = path.getOrDefault("resourceName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594157: Call_ReplicationLogicalNetworksListByReplicationFabrics_594149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_ReplicationLogicalNetworksListByReplicationFabrics_594149;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksListByReplicationFabrics
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  add(path_594159, "fabricName", newJString(fabricName))
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  add(path_594159, "resourceName", newJString(resourceName))
  result = call_594158.call(path_594159, query_594160, nil, nil, nil)

var replicationLogicalNetworksListByReplicationFabrics* = Call_ReplicationLogicalNetworksListByReplicationFabrics_594149(
    name: "replicationLogicalNetworksListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks",
    validator: validate_ReplicationLogicalNetworksListByReplicationFabrics_594150,
    base: "", url: url_ReplicationLogicalNetworksListByReplicationFabrics_594151,
    schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksGet_594161 = ref object of OpenApiRestCall_593439
proc url_ReplicationLogicalNetworksGet_594163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "logicalNetworkName" in path,
        "`logicalNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationLogicalNetworks/"),
               (kind: VariableSegment, value: "logicalNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLogicalNetworksGet_594162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a logical network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   logicalNetworkName: JString (required)
  ##                     : Logical network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594164 = path.getOrDefault("fabricName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "fabricName", valid_594164
  var valid_594165 = path.getOrDefault("resourceGroupName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "resourceGroupName", valid_594165
  var valid_594166 = path.getOrDefault("logicalNetworkName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "logicalNetworkName", valid_594166
  var valid_594167 = path.getOrDefault("subscriptionId")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "subscriptionId", valid_594167
  var valid_594168 = path.getOrDefault("resourceName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceName", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594169 = query.getOrDefault("api-version")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "api-version", valid_594169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594170: Call_ReplicationLogicalNetworksGet_594161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a logical network.
  ## 
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_ReplicationLogicalNetworksGet_594161;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          logicalNetworkName: string; subscriptionId: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksGet
  ## Gets the details of a logical network.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   logicalNetworkName: string (required)
  ##                     : Logical network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  add(path_594172, "fabricName", newJString(fabricName))
  add(path_594172, "resourceGroupName", newJString(resourceGroupName))
  add(query_594173, "api-version", newJString(apiVersion))
  add(path_594172, "logicalNetworkName", newJString(logicalNetworkName))
  add(path_594172, "subscriptionId", newJString(subscriptionId))
  add(path_594172, "resourceName", newJString(resourceName))
  result = call_594171.call(path_594172, query_594173, nil, nil, nil)

var replicationLogicalNetworksGet* = Call_ReplicationLogicalNetworksGet_594161(
    name: "replicationLogicalNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks/{logicalNetworkName}",
    validator: validate_ReplicationLogicalNetworksGet_594162, base: "",
    url: url_ReplicationLogicalNetworksGet_594163, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksListByReplicationFabrics_594174 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworksListByReplicationFabrics_594176(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksListByReplicationFabrics_594175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available for a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594177 = path.getOrDefault("fabricName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "fabricName", valid_594177
  var valid_594178 = path.getOrDefault("resourceGroupName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "resourceGroupName", valid_594178
  var valid_594179 = path.getOrDefault("subscriptionId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "subscriptionId", valid_594179
  var valid_594180 = path.getOrDefault("resourceName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceName", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594181 = query.getOrDefault("api-version")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "api-version", valid_594181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_ReplicationNetworksListByReplicationFabrics_594174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the networks available for a fabric.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_ReplicationNetworksListByReplicationFabrics_594174;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworksListByReplicationFabrics
  ## Lists the networks available for a fabric.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  add(path_594184, "fabricName", newJString(fabricName))
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  add(path_594184, "resourceName", newJString(resourceName))
  result = call_594183.call(path_594184, query_594185, nil, nil, nil)

var replicationNetworksListByReplicationFabrics* = Call_ReplicationNetworksListByReplicationFabrics_594174(
    name: "replicationNetworksListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks",
    validator: validate_ReplicationNetworksListByReplicationFabrics_594175,
    base: "", url: url_ReplicationNetworksListByReplicationFabrics_594176,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworksGet_594186 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworksGet_594188(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksGet_594187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594189 = path.getOrDefault("fabricName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "fabricName", valid_594189
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("networkName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "networkName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("resourceName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_ReplicationNetworksGet_594186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a network.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_ReplicationNetworksGet_594186; fabricName: string;
          resourceGroupName: string; apiVersion: string; networkName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworksGet
  ## Gets the details of a network.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(path_594197, "fabricName", newJString(fabricName))
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "networkName", newJString(networkName))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  add(path_594197, "resourceName", newJString(resourceName))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var replicationNetworksGet* = Call_ReplicationNetworksGet_594186(
    name: "replicationNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}",
    validator: validate_ReplicationNetworksGet_594187, base: "",
    url: url_ReplicationNetworksGet_594188, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsListByReplicationNetworks_594199 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsListByReplicationNetworks_594201(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsListByReplicationNetworks_594200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all ASR network mappings for the specified network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594202 = path.getOrDefault("fabricName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "fabricName", valid_594202
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("networkName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "networkName", valid_594204
  var valid_594205 = path.getOrDefault("subscriptionId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subscriptionId", valid_594205
  var valid_594206 = path.getOrDefault("resourceName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "resourceName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_ReplicationNetworkMappingsListByReplicationNetworks_594199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all ASR network mappings for the specified network.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_ReplicationNetworkMappingsListByReplicationNetworks_594199;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          networkName: string; subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworkMappingsListByReplicationNetworks
  ## Lists all ASR network mappings for the specified network.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(path_594210, "fabricName", newJString(fabricName))
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "networkName", newJString(networkName))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  add(path_594210, "resourceName", newJString(resourceName))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var replicationNetworkMappingsListByReplicationNetworks* = Call_ReplicationNetworkMappingsListByReplicationNetworks_594199(
    name: "replicationNetworkMappingsListByReplicationNetworks",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsListByReplicationNetworks_594200,
    base: "", url: url_ReplicationNetworkMappingsListByReplicationNetworks_594201,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsCreate_594226 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsCreate_594228(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsCreate_594227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_594229 = path.getOrDefault("networkMappingName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "networkMappingName", valid_594229
  var valid_594230 = path.getOrDefault("fabricName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "fabricName", valid_594230
  var valid_594231 = path.getOrDefault("resourceGroupName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "resourceGroupName", valid_594231
  var valid_594232 = path.getOrDefault("networkName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "networkName", valid_594232
  var valid_594233 = path.getOrDefault("subscriptionId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "subscriptionId", valid_594233
  var valid_594234 = path.getOrDefault("resourceName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "resourceName", valid_594234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594235 = query.getOrDefault("api-version")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "api-version", valid_594235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Create network mapping input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594237: Call_ReplicationNetworkMappingsCreate_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR network mapping.
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_ReplicationNetworkMappingsCreate_594226;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationNetworkMappingsCreate
  ## The operation to create an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Create network mapping input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  var body_594241 = newJObject()
  add(path_594239, "networkMappingName", newJString(networkMappingName))
  add(path_594239, "fabricName", newJString(fabricName))
  add(path_594239, "resourceGroupName", newJString(resourceGroupName))
  add(query_594240, "api-version", newJString(apiVersion))
  add(path_594239, "networkName", newJString(networkName))
  add(path_594239, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594241 = input
  add(path_594239, "resourceName", newJString(resourceName))
  result = call_594238.call(path_594239, query_594240, nil, nil, body_594241)

var replicationNetworkMappingsCreate* = Call_ReplicationNetworkMappingsCreate_594226(
    name: "replicationNetworkMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsCreate_594227, base: "",
    url: url_ReplicationNetworkMappingsCreate_594228, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsGet_594212 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsGet_594214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsGet_594213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR network mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_594215 = path.getOrDefault("networkMappingName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "networkMappingName", valid_594215
  var valid_594216 = path.getOrDefault("fabricName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "fabricName", valid_594216
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("networkName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "networkName", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  var valid_594220 = path.getOrDefault("resourceName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_ReplicationNetworkMappingsGet_594212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR network mapping
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_ReplicationNetworkMappingsGet_594212;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsGet
  ## Gets the details of an ASR network mapping
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "networkMappingName", newJString(networkMappingName))
  add(path_594224, "fabricName", newJString(fabricName))
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "networkName", newJString(networkName))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  add(path_594224, "resourceName", newJString(resourceName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var replicationNetworkMappingsGet* = Call_ReplicationNetworkMappingsGet_594212(
    name: "replicationNetworkMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsGet_594213, base: "",
    url: url_ReplicationNetworkMappingsGet_594214, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsUpdate_594256 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsUpdate_594258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsUpdate_594257(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_594259 = path.getOrDefault("networkMappingName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "networkMappingName", valid_594259
  var valid_594260 = path.getOrDefault("fabricName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "fabricName", valid_594260
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("networkName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "networkName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  var valid_594264 = path.getOrDefault("resourceName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "resourceName", valid_594264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "api-version", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update network mapping input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_ReplicationNetworkMappingsUpdate_594256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update an ASR network mapping.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_ReplicationNetworkMappingsUpdate_594256;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationNetworkMappingsUpdate
  ## The operation to update an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update network mapping input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  var body_594271 = newJObject()
  add(path_594269, "networkMappingName", newJString(networkMappingName))
  add(path_594269, "fabricName", newJString(fabricName))
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "networkName", newJString(networkName))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594271 = input
  add(path_594269, "resourceName", newJString(resourceName))
  result = call_594268.call(path_594269, query_594270, nil, nil, body_594271)

var replicationNetworkMappingsUpdate* = Call_ReplicationNetworkMappingsUpdate_594256(
    name: "replicationNetworkMappingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsUpdate_594257, base: "",
    url: url_ReplicationNetworkMappingsUpdate_594258, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsDelete_594242 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsDelete_594244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsDelete_594243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : ARM Resource Name for network mapping.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_594245 = path.getOrDefault("networkMappingName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "networkMappingName", valid_594245
  var valid_594246 = path.getOrDefault("fabricName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "fabricName", valid_594246
  var valid_594247 = path.getOrDefault("resourceGroupName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "resourceGroupName", valid_594247
  var valid_594248 = path.getOrDefault("networkName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "networkName", valid_594248
  var valid_594249 = path.getOrDefault("subscriptionId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "subscriptionId", valid_594249
  var valid_594250 = path.getOrDefault("resourceName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resourceName", valid_594250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "api-version", valid_594251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594252: Call_ReplicationNetworkMappingsDelete_594242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a network mapping.
  ## 
  let valid = call_594252.validator(path, query, header, formData, body)
  let scheme = call_594252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594252.url(scheme.get, call_594252.host, call_594252.base,
                         call_594252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594252, url, valid)

proc call*(call_594253: Call_ReplicationNetworkMappingsDelete_594242;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsDelete
  ## The operation to delete a network mapping.
  ##   networkMappingName: string (required)
  ##                     : ARM Resource Name for network mapping.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594254 = newJObject()
  var query_594255 = newJObject()
  add(path_594254, "networkMappingName", newJString(networkMappingName))
  add(path_594254, "fabricName", newJString(fabricName))
  add(path_594254, "resourceGroupName", newJString(resourceGroupName))
  add(query_594255, "api-version", newJString(apiVersion))
  add(path_594254, "networkName", newJString(networkName))
  add(path_594254, "subscriptionId", newJString(subscriptionId))
  add(path_594254, "resourceName", newJString(resourceName))
  result = call_594253.call(path_594254, query_594255, nil, nil, nil)

var replicationNetworkMappingsDelete* = Call_ReplicationNetworkMappingsDelete_594242(
    name: "replicationNetworkMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsDelete_594243, base: "",
    url: url_ReplicationNetworkMappingsDelete_594244, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersListByReplicationFabrics_594272 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersListByReplicationFabrics_594274(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersListByReplicationFabrics_594273(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection containers in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594275 = path.getOrDefault("fabricName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "fabricName", valid_594275
  var valid_594276 = path.getOrDefault("resourceGroupName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "resourceGroupName", valid_594276
  var valid_594277 = path.getOrDefault("subscriptionId")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "subscriptionId", valid_594277
  var valid_594278 = path.getOrDefault("resourceName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "resourceName", valid_594278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "api-version", valid_594279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594280: Call_ReplicationProtectionContainersListByReplicationFabrics_594272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in the specified fabric.
  ## 
  let valid = call_594280.validator(path, query, header, formData, body)
  let scheme = call_594280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594280.url(scheme.get, call_594280.host, call_594280.base,
                         call_594280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594280, url, valid)

proc call*(call_594281: Call_ReplicationProtectionContainersListByReplicationFabrics_594272;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationProtectionContainersListByReplicationFabrics
  ## Lists the protection containers in the specified fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594282 = newJObject()
  var query_594283 = newJObject()
  add(path_594282, "fabricName", newJString(fabricName))
  add(path_594282, "resourceGroupName", newJString(resourceGroupName))
  add(query_594283, "api-version", newJString(apiVersion))
  add(path_594282, "subscriptionId", newJString(subscriptionId))
  add(path_594282, "resourceName", newJString(resourceName))
  result = call_594281.call(path_594282, query_594283, nil, nil, nil)

var replicationProtectionContainersListByReplicationFabrics* = Call_ReplicationProtectionContainersListByReplicationFabrics_594272(
    name: "replicationProtectionContainersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers", validator: validate_ReplicationProtectionContainersListByReplicationFabrics_594273,
    base: "", url: url_ReplicationProtectionContainersListByReplicationFabrics_594274,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersCreate_594297 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersCreate_594299(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersCreate_594298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to create a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594300 = path.getOrDefault("fabricName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "fabricName", valid_594300
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
  var valid_594303 = path.getOrDefault("resourceName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceName", valid_594303
  var valid_594304 = path.getOrDefault("protectionContainerName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "protectionContainerName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   creationInput: JObject (required)
  ##                : Creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_ReplicationProtectionContainersCreate_594297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to create a protection container.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_ReplicationProtectionContainersCreate_594297;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          creationInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersCreate
  ## Operation to create a protection container.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   creationInput: JObject (required)
  ##                : Creation input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  var body_594311 = newJObject()
  add(path_594309, "fabricName", newJString(fabricName))
  add(path_594309, "resourceGroupName", newJString(resourceGroupName))
  add(query_594310, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_594311 = creationInput
  add(path_594309, "subscriptionId", newJString(subscriptionId))
  add(path_594309, "resourceName", newJString(resourceName))
  add(path_594309, "protectionContainerName", newJString(protectionContainerName))
  result = call_594308.call(path_594309, query_594310, nil, nil, body_594311)

var replicationProtectionContainersCreate* = Call_ReplicationProtectionContainersCreate_594297(
    name: "replicationProtectionContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersCreate_594298, base: "",
    url: url_ReplicationProtectionContainersCreate_594299, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersGet_594284 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersGet_594286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersGet_594285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594287 = path.getOrDefault("fabricName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "fabricName", valid_594287
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("resourceName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resourceName", valid_594290
  var valid_594291 = path.getOrDefault("protectionContainerName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "protectionContainerName", valid_594291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594292 = query.getOrDefault("api-version")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "api-version", valid_594292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594293: Call_ReplicationProtectionContainersGet_594284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_ReplicationProtectionContainersGet_594284;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersGet
  ## Gets the details of a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  add(path_594295, "fabricName", newJString(fabricName))
  add(path_594295, "resourceGroupName", newJString(resourceGroupName))
  add(query_594296, "api-version", newJString(apiVersion))
  add(path_594295, "subscriptionId", newJString(subscriptionId))
  add(path_594295, "resourceName", newJString(resourceName))
  add(path_594295, "protectionContainerName", newJString(protectionContainerName))
  result = call_594294.call(path_594295, query_594296, nil, nil, nil)

var replicationProtectionContainersGet* = Call_ReplicationProtectionContainersGet_594284(
    name: "replicationProtectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersGet_594285, base: "",
    url: url_ReplicationProtectionContainersGet_594286, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDiscoverProtectableItem_594312 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersDiscoverProtectableItem_594314(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/discoverProtectableItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersDiscoverProtectableItem_594313(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the protection container.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594315 = path.getOrDefault("fabricName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "fabricName", valid_594315
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
  var valid_594318 = path.getOrDefault("resourceName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "resourceName", valid_594318
  var valid_594319 = path.getOrDefault("protectionContainerName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "protectionContainerName", valid_594319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594320 = query.getOrDefault("api-version")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "api-version", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   discoverProtectableItemRequest: JObject (required)
  ##                                 : The request object to add a protectable item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_ReplicationProtectionContainersDiscoverProtectableItem_594312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_ReplicationProtectionContainersDiscoverProtectableItem_594312;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string;
          discoverProtectableItemRequest: JsonNode): Recallable =
  ## replicationProtectionContainersDiscoverProtectableItem
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the protection container.
  ##   discoverProtectableItemRequest: JObject (required)
  ##                                 : The request object to add a protectable item.
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  var body_594326 = newJObject()
  add(path_594324, "fabricName", newJString(fabricName))
  add(path_594324, "resourceGroupName", newJString(resourceGroupName))
  add(query_594325, "api-version", newJString(apiVersion))
  add(path_594324, "subscriptionId", newJString(subscriptionId))
  add(path_594324, "resourceName", newJString(resourceName))
  add(path_594324, "protectionContainerName", newJString(protectionContainerName))
  if discoverProtectableItemRequest != nil:
    body_594326 = discoverProtectableItemRequest
  result = call_594323.call(path_594324, query_594325, nil, nil, body_594326)

var replicationProtectionContainersDiscoverProtectableItem* = Call_ReplicationProtectionContainersDiscoverProtectableItem_594312(
    name: "replicationProtectionContainersDiscoverProtectableItem",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/discoverProtectableItem",
    validator: validate_ReplicationProtectionContainersDiscoverProtectableItem_594313,
    base: "", url: url_ReplicationProtectionContainersDiscoverProtectableItem_594314,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDelete_594327 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersDelete_594329(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersDelete_594328(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594330 = path.getOrDefault("fabricName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "fabricName", valid_594330
  var valid_594331 = path.getOrDefault("resourceGroupName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "resourceGroupName", valid_594331
  var valid_594332 = path.getOrDefault("subscriptionId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "subscriptionId", valid_594332
  var valid_594333 = path.getOrDefault("resourceName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceName", valid_594333
  var valid_594334 = path.getOrDefault("protectionContainerName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "protectionContainerName", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594336: Call_ReplicationProtectionContainersDelete_594327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove a protection container.
  ## 
  let valid = call_594336.validator(path, query, header, formData, body)
  let scheme = call_594336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594336.url(scheme.get, call_594336.host, call_594336.base,
                         call_594336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594336, url, valid)

proc call*(call_594337: Call_ReplicationProtectionContainersDelete_594327;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersDelete
  ## Operation to remove a protection container.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  var path_594338 = newJObject()
  var query_594339 = newJObject()
  add(path_594338, "fabricName", newJString(fabricName))
  add(path_594338, "resourceGroupName", newJString(resourceGroupName))
  add(query_594339, "api-version", newJString(apiVersion))
  add(path_594338, "subscriptionId", newJString(subscriptionId))
  add(path_594338, "resourceName", newJString(resourceName))
  add(path_594338, "protectionContainerName", newJString(protectionContainerName))
  result = call_594337.call(path_594338, query_594339, nil, nil, nil)

var replicationProtectionContainersDelete* = Call_ReplicationProtectionContainersDelete_594327(
    name: "replicationProtectionContainersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/remove",
    validator: validate_ReplicationProtectionContainersDelete_594328, base: "",
    url: url_ReplicationProtectionContainersDelete_594329, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsListByReplicationProtectionContainers_594340 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsListByReplicationProtectionContainers_594342(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsListByReplicationProtectionContainers_594341(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR migration items in the protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594343 = path.getOrDefault("fabricName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "fabricName", valid_594343
  var valid_594344 = path.getOrDefault("resourceGroupName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "resourceGroupName", valid_594344
  var valid_594345 = path.getOrDefault("subscriptionId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "subscriptionId", valid_594345
  var valid_594346 = path.getOrDefault("resourceName")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "resourceName", valid_594346
  var valid_594347 = path.getOrDefault("protectionContainerName")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "protectionContainerName", valid_594347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594348 = query.getOrDefault("api-version")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "api-version", valid_594348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594349: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_594340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR migration items in the protection container.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_594340;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationMigrationItemsListByReplicationProtectionContainers
  ## Gets the list of ASR migration items in the protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  add(path_594351, "fabricName", newJString(fabricName))
  add(path_594351, "resourceGroupName", newJString(resourceGroupName))
  add(query_594352, "api-version", newJString(apiVersion))
  add(path_594351, "subscriptionId", newJString(subscriptionId))
  add(path_594351, "resourceName", newJString(resourceName))
  add(path_594351, "protectionContainerName", newJString(protectionContainerName))
  result = call_594350.call(path_594351, query_594352, nil, nil, nil)

var replicationMigrationItemsListByReplicationProtectionContainers* = Call_ReplicationMigrationItemsListByReplicationProtectionContainers_594340(
    name: "replicationMigrationItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems", validator: validate_ReplicationMigrationItemsListByReplicationProtectionContainers_594341,
    base: "",
    url: url_ReplicationMigrationItemsListByReplicationProtectionContainers_594342,
    schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsCreate_594367 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsCreate_594369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsCreate_594368(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR migration item (enable migration).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594370 = path.getOrDefault("fabricName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "fabricName", valid_594370
  var valid_594371 = path.getOrDefault("resourceGroupName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "resourceGroupName", valid_594371
  var valid_594372 = path.getOrDefault("subscriptionId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "subscriptionId", valid_594372
  var valid_594373 = path.getOrDefault("resourceName")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "resourceName", valid_594373
  var valid_594374 = path.getOrDefault("protectionContainerName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "protectionContainerName", valid_594374
  var valid_594375 = path.getOrDefault("migrationItemName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "migrationItemName", valid_594375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594376 = query.getOrDefault("api-version")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "api-version", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Enable migration input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594378: Call_ReplicationMigrationItemsCreate_594367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR migration item (enable migration).
  ## 
  let valid = call_594378.validator(path, query, header, formData, body)
  let scheme = call_594378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594378.url(scheme.get, call_594378.host, call_594378.base,
                         call_594378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594378, url, valid)

proc call*(call_594379: Call_ReplicationMigrationItemsCreate_594367;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsCreate
  ## The operation to create an ASR migration item (enable migration).
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Enable migration input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594380 = newJObject()
  var query_594381 = newJObject()
  var body_594382 = newJObject()
  add(path_594380, "fabricName", newJString(fabricName))
  add(path_594380, "resourceGroupName", newJString(resourceGroupName))
  add(query_594381, "api-version", newJString(apiVersion))
  add(path_594380, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594382 = input
  add(path_594380, "resourceName", newJString(resourceName))
  add(path_594380, "protectionContainerName", newJString(protectionContainerName))
  add(path_594380, "migrationItemName", newJString(migrationItemName))
  result = call_594379.call(path_594380, query_594381, nil, nil, body_594382)

var replicationMigrationItemsCreate* = Call_ReplicationMigrationItemsCreate_594367(
    name: "replicationMigrationItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsCreate_594368, base: "",
    url: url_ReplicationMigrationItemsCreate_594369, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsGet_594353 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsGet_594355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsGet_594354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594356 = path.getOrDefault("fabricName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "fabricName", valid_594356
  var valid_594357 = path.getOrDefault("resourceGroupName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "resourceGroupName", valid_594357
  var valid_594358 = path.getOrDefault("subscriptionId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "subscriptionId", valid_594358
  var valid_594359 = path.getOrDefault("resourceName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "resourceName", valid_594359
  var valid_594360 = path.getOrDefault("protectionContainerName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "protectionContainerName", valid_594360
  var valid_594361 = path.getOrDefault("migrationItemName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "migrationItemName", valid_594361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594362 = query.getOrDefault("api-version")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "api-version", valid_594362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594363: Call_ReplicationMigrationItemsGet_594353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_ReplicationMigrationItemsGet_594353;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsGet
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594365 = newJObject()
  var query_594366 = newJObject()
  add(path_594365, "fabricName", newJString(fabricName))
  add(path_594365, "resourceGroupName", newJString(resourceGroupName))
  add(query_594366, "api-version", newJString(apiVersion))
  add(path_594365, "subscriptionId", newJString(subscriptionId))
  add(path_594365, "resourceName", newJString(resourceName))
  add(path_594365, "protectionContainerName", newJString(protectionContainerName))
  add(path_594365, "migrationItemName", newJString(migrationItemName))
  result = call_594364.call(path_594365, query_594366, nil, nil, nil)

var replicationMigrationItemsGet* = Call_ReplicationMigrationItemsGet_594353(
    name: "replicationMigrationItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsGet_594354, base: "",
    url: url_ReplicationMigrationItemsGet_594355, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsUpdate_594398 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsUpdate_594400(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsUpdate_594399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR migration item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594401 = path.getOrDefault("fabricName")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "fabricName", valid_594401
  var valid_594402 = path.getOrDefault("resourceGroupName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "resourceGroupName", valid_594402
  var valid_594403 = path.getOrDefault("subscriptionId")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "subscriptionId", valid_594403
  var valid_594404 = path.getOrDefault("resourceName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "resourceName", valid_594404
  var valid_594405 = path.getOrDefault("protectionContainerName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "protectionContainerName", valid_594405
  var valid_594406 = path.getOrDefault("migrationItemName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "migrationItemName", valid_594406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594407 = query.getOrDefault("api-version")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "api-version", valid_594407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update migration item input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594409: Call_ReplicationMigrationItemsUpdate_594398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR migration item.
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_ReplicationMigrationItemsUpdate_594398;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsUpdate
  ## The operation to update the recovery settings of an ASR migration item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update migration item input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594411 = newJObject()
  var query_594412 = newJObject()
  var body_594413 = newJObject()
  add(path_594411, "fabricName", newJString(fabricName))
  add(path_594411, "resourceGroupName", newJString(resourceGroupName))
  add(query_594412, "api-version", newJString(apiVersion))
  add(path_594411, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594413 = input
  add(path_594411, "resourceName", newJString(resourceName))
  add(path_594411, "protectionContainerName", newJString(protectionContainerName))
  add(path_594411, "migrationItemName", newJString(migrationItemName))
  result = call_594410.call(path_594411, query_594412, nil, nil, body_594413)

var replicationMigrationItemsUpdate* = Call_ReplicationMigrationItemsUpdate_594398(
    name: "replicationMigrationItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsUpdate_594399, base: "",
    url: url_ReplicationMigrationItemsUpdate_594400, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsDelete_594383 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsDelete_594385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsDelete_594384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete an ASR migration item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594386 = path.getOrDefault("fabricName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "fabricName", valid_594386
  var valid_594387 = path.getOrDefault("resourceGroupName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "resourceGroupName", valid_594387
  var valid_594388 = path.getOrDefault("subscriptionId")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "subscriptionId", valid_594388
  var valid_594389 = path.getOrDefault("resourceName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "resourceName", valid_594389
  var valid_594390 = path.getOrDefault("protectionContainerName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "protectionContainerName", valid_594390
  var valid_594391 = path.getOrDefault("migrationItemName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "migrationItemName", valid_594391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   deleteOption: JString
  ##               : The delete option.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594392 = query.getOrDefault("api-version")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "api-version", valid_594392
  var valid_594393 = query.getOrDefault("deleteOption")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "deleteOption", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_ReplicationMigrationItemsDelete_594383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete an ASR migration item.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_ReplicationMigrationItemsDelete_594383;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string;
          deleteOption: string = ""): Recallable =
  ## replicationMigrationItemsDelete
  ## The operation to delete an ASR migration item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   deleteOption: string
  ##               : The delete option.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(path_594396, "fabricName", newJString(fabricName))
  add(path_594396, "resourceGroupName", newJString(resourceGroupName))
  add(query_594397, "api-version", newJString(apiVersion))
  add(path_594396, "subscriptionId", newJString(subscriptionId))
  add(path_594396, "resourceName", newJString(resourceName))
  add(path_594396, "protectionContainerName", newJString(protectionContainerName))
  add(query_594397, "deleteOption", newJString(deleteOption))
  add(path_594396, "migrationItemName", newJString(migrationItemName))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var replicationMigrationItemsDelete* = Call_ReplicationMigrationItemsDelete_594383(
    name: "replicationMigrationItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsDelete_594384, base: "",
    url: url_ReplicationMigrationItemsDelete_594385, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsMigrate_594414 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsMigrate_594416(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsMigrate_594415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate migration of the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594417 = path.getOrDefault("fabricName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "fabricName", valid_594417
  var valid_594418 = path.getOrDefault("resourceGroupName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "resourceGroupName", valid_594418
  var valid_594419 = path.getOrDefault("subscriptionId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "subscriptionId", valid_594419
  var valid_594420 = path.getOrDefault("resourceName")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "resourceName", valid_594420
  var valid_594421 = path.getOrDefault("protectionContainerName")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "protectionContainerName", valid_594421
  var valid_594422 = path.getOrDefault("migrationItemName")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "migrationItemName", valid_594422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594423 = query.getOrDefault("api-version")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "api-version", valid_594423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   migrateInput: JObject (required)
  ##               : Migrate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594425: Call_ReplicationMigrationItemsMigrate_594414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate migration of the item.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_ReplicationMigrationItemsMigrate_594414;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrateInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsMigrate
  ## The operation to initiate migration of the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrateInput: JObject (required)
  ##               : Migrate input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  var body_594429 = newJObject()
  add(path_594427, "fabricName", newJString(fabricName))
  add(path_594427, "resourceGroupName", newJString(resourceGroupName))
  add(query_594428, "api-version", newJString(apiVersion))
  add(path_594427, "subscriptionId", newJString(subscriptionId))
  add(path_594427, "resourceName", newJString(resourceName))
  add(path_594427, "protectionContainerName", newJString(protectionContainerName))
  if migrateInput != nil:
    body_594429 = migrateInput
  add(path_594427, "migrationItemName", newJString(migrationItemName))
  result = call_594426.call(path_594427, query_594428, nil, nil, body_594429)

var replicationMigrationItemsMigrate* = Call_ReplicationMigrationItemsMigrate_594414(
    name: "replicationMigrationItemsMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrate",
    validator: validate_ReplicationMigrationItemsMigrate_594415, base: "",
    url: url_ReplicationMigrationItemsMigrate_594416, schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsListByReplicationMigrationItems_594430 = ref object of OpenApiRestCall_593439
proc url_MigrationRecoveryPointsListByReplicationMigrationItems_594432(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrationRecoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationRecoveryPointsListByReplicationMigrationItems_594431(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594433 = path.getOrDefault("fabricName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "fabricName", valid_594433
  var valid_594434 = path.getOrDefault("resourceGroupName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "resourceGroupName", valid_594434
  var valid_594435 = path.getOrDefault("subscriptionId")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "subscriptionId", valid_594435
  var valid_594436 = path.getOrDefault("resourceName")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "resourceName", valid_594436
  var valid_594437 = path.getOrDefault("protectionContainerName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "protectionContainerName", valid_594437
  var valid_594438 = path.getOrDefault("migrationItemName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "migrationItemName", valid_594438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594439 = query.getOrDefault("api-version")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "api-version", valid_594439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594440: Call_MigrationRecoveryPointsListByReplicationMigrationItems_594430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594440.validator(path, query, header, formData, body)
  let scheme = call_594440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594440.url(scheme.get, call_594440.host, call_594440.base,
                         call_594440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594440, url, valid)

proc call*(call_594441: Call_MigrationRecoveryPointsListByReplicationMigrationItems_594430;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## migrationRecoveryPointsListByReplicationMigrationItems
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594442 = newJObject()
  var query_594443 = newJObject()
  add(path_594442, "fabricName", newJString(fabricName))
  add(path_594442, "resourceGroupName", newJString(resourceGroupName))
  add(query_594443, "api-version", newJString(apiVersion))
  add(path_594442, "subscriptionId", newJString(subscriptionId))
  add(path_594442, "resourceName", newJString(resourceName))
  add(path_594442, "protectionContainerName", newJString(protectionContainerName))
  add(path_594442, "migrationItemName", newJString(migrationItemName))
  result = call_594441.call(path_594442, query_594443, nil, nil, nil)

var migrationRecoveryPointsListByReplicationMigrationItems* = Call_MigrationRecoveryPointsListByReplicationMigrationItems_594430(
    name: "migrationRecoveryPointsListByReplicationMigrationItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints",
    validator: validate_MigrationRecoveryPointsListByReplicationMigrationItems_594431,
    base: "", url: url_MigrationRecoveryPointsListByReplicationMigrationItems_594432,
    schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsGet_594444 = ref object of OpenApiRestCall_593439
proc url_MigrationRecoveryPointsGet_594446(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  assert "migrationRecoveryPointName" in path,
        "`migrationRecoveryPointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrationRecoveryPoints/"),
               (kind: VariableSegment, value: "migrationRecoveryPointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationRecoveryPointsGet_594445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationRecoveryPointName: JString (required)
  ##                             : The migration recovery point name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594447 = path.getOrDefault("fabricName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "fabricName", valid_594447
  var valid_594448 = path.getOrDefault("resourceGroupName")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "resourceGroupName", valid_594448
  var valid_594449 = path.getOrDefault("subscriptionId")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "subscriptionId", valid_594449
  var valid_594450 = path.getOrDefault("resourceName")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "resourceName", valid_594450
  var valid_594451 = path.getOrDefault("protectionContainerName")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "protectionContainerName", valid_594451
  var valid_594452 = path.getOrDefault("migrationRecoveryPointName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "migrationRecoveryPointName", valid_594452
  var valid_594453 = path.getOrDefault("migrationItemName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "migrationItemName", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594455: Call_MigrationRecoveryPointsGet_594444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594455.validator(path, query, header, formData, body)
  let scheme = call_594455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594455.url(scheme.get, call_594455.host, call_594455.base,
                         call_594455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594455, url, valid)

proc call*(call_594456: Call_MigrationRecoveryPointsGet_594444; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          migrationRecoveryPointName: string; migrationItemName: string): Recallable =
  ## migrationRecoveryPointsGet
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationRecoveryPointName: string (required)
  ##                             : The migration recovery point name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594457 = newJObject()
  var query_594458 = newJObject()
  add(path_594457, "fabricName", newJString(fabricName))
  add(path_594457, "resourceGroupName", newJString(resourceGroupName))
  add(query_594458, "api-version", newJString(apiVersion))
  add(path_594457, "subscriptionId", newJString(subscriptionId))
  add(path_594457, "resourceName", newJString(resourceName))
  add(path_594457, "protectionContainerName", newJString(protectionContainerName))
  add(path_594457, "migrationRecoveryPointName",
      newJString(migrationRecoveryPointName))
  add(path_594457, "migrationItemName", newJString(migrationItemName))
  result = call_594456.call(path_594457, query_594458, nil, nil, nil)

var migrationRecoveryPointsGet* = Call_MigrationRecoveryPointsGet_594444(
    name: "migrationRecoveryPointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints/{migrationRecoveryPointName}",
    validator: validate_MigrationRecoveryPointsGet_594445, base: "",
    url: url_MigrationRecoveryPointsGet_594446, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrate_594459 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsTestMigrate_594461(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/testMigrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsTestMigrate_594460(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migration of the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594462 = path.getOrDefault("fabricName")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "fabricName", valid_594462
  var valid_594463 = path.getOrDefault("resourceGroupName")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "resourceGroupName", valid_594463
  var valid_594464 = path.getOrDefault("subscriptionId")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "subscriptionId", valid_594464
  var valid_594465 = path.getOrDefault("resourceName")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "resourceName", valid_594465
  var valid_594466 = path.getOrDefault("protectionContainerName")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "protectionContainerName", valid_594466
  var valid_594467 = path.getOrDefault("migrationItemName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "migrationItemName", valid_594467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594468 = query.getOrDefault("api-version")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "api-version", valid_594468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   testMigrateInput: JObject (required)
  ##                   : Test migrate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594470: Call_ReplicationMigrationItemsTestMigrate_594459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migration of the item.
  ## 
  let valid = call_594470.validator(path, query, header, formData, body)
  let scheme = call_594470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594470.url(scheme.get, call_594470.host, call_594470.base,
                         call_594470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594470, url, valid)

proc call*(call_594471: Call_ReplicationMigrationItemsTestMigrate_594459;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; testMigrateInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsTestMigrate
  ## The operation to initiate test migration of the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   testMigrateInput: JObject (required)
  ##                   : Test migrate input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594472 = newJObject()
  var query_594473 = newJObject()
  var body_594474 = newJObject()
  add(path_594472, "fabricName", newJString(fabricName))
  add(path_594472, "resourceGroupName", newJString(resourceGroupName))
  add(query_594473, "api-version", newJString(apiVersion))
  add(path_594472, "subscriptionId", newJString(subscriptionId))
  add(path_594472, "resourceName", newJString(resourceName))
  add(path_594472, "protectionContainerName", newJString(protectionContainerName))
  if testMigrateInput != nil:
    body_594474 = testMigrateInput
  add(path_594472, "migrationItemName", newJString(migrationItemName))
  result = call_594471.call(path_594472, query_594473, nil, nil, body_594474)

var replicationMigrationItemsTestMigrate* = Call_ReplicationMigrationItemsTestMigrate_594459(
    name: "replicationMigrationItemsTestMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrate",
    validator: validate_ReplicationMigrationItemsTestMigrate_594460, base: "",
    url: url_ReplicationMigrationItemsTestMigrate_594461, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrateCleanup_594475 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsTestMigrateCleanup_594477(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/testMigrateCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsTestMigrateCleanup_594476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migrate cleanup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594478 = path.getOrDefault("fabricName")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "fabricName", valid_594478
  var valid_594479 = path.getOrDefault("resourceGroupName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "resourceGroupName", valid_594479
  var valid_594480 = path.getOrDefault("subscriptionId")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "subscriptionId", valid_594480
  var valid_594481 = path.getOrDefault("resourceName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "resourceName", valid_594481
  var valid_594482 = path.getOrDefault("protectionContainerName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "protectionContainerName", valid_594482
  var valid_594483 = path.getOrDefault("migrationItemName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "migrationItemName", valid_594483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594484 = query.getOrDefault("api-version")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "api-version", valid_594484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   testMigrateCleanupInput: JObject (required)
  ##                          : Test migrate cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594486: Call_ReplicationMigrationItemsTestMigrateCleanup_594475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migrate cleanup.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_ReplicationMigrationItemsTestMigrateCleanup_594475;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; testMigrateCleanupInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsTestMigrateCleanup
  ## The operation to initiate test migrate cleanup.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   testMigrateCleanupInput: JObject (required)
  ##                          : Test migrate cleanup input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  var body_594490 = newJObject()
  add(path_594488, "fabricName", newJString(fabricName))
  add(path_594488, "resourceGroupName", newJString(resourceGroupName))
  add(query_594489, "api-version", newJString(apiVersion))
  add(path_594488, "subscriptionId", newJString(subscriptionId))
  add(path_594488, "resourceName", newJString(resourceName))
  add(path_594488, "protectionContainerName", newJString(protectionContainerName))
  if testMigrateCleanupInput != nil:
    body_594490 = testMigrateCleanupInput
  add(path_594488, "migrationItemName", newJString(migrationItemName))
  result = call_594487.call(path_594488, query_594489, nil, nil, body_594490)

var replicationMigrationItemsTestMigrateCleanup* = Call_ReplicationMigrationItemsTestMigrateCleanup_594475(
    name: "replicationMigrationItemsTestMigrateCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrateCleanup",
    validator: validate_ReplicationMigrationItemsTestMigrateCleanup_594476,
    base: "", url: url_ReplicationMigrationItemsTestMigrateCleanup_594477,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsListByReplicationProtectionContainers_594491 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectableItemsListByReplicationProtectionContainers_594493(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectableItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectableItemsListByReplicationProtectionContainers_594492(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protectable items in a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594494 = path.getOrDefault("fabricName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "fabricName", valid_594494
  var valid_594495 = path.getOrDefault("resourceGroupName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "resourceGroupName", valid_594495
  var valid_594496 = path.getOrDefault("subscriptionId")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "subscriptionId", valid_594496
  var valid_594497 = path.getOrDefault("resourceName")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "resourceName", valid_594497
  var valid_594498 = path.getOrDefault("protectionContainerName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "protectionContainerName", valid_594498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594499 = query.getOrDefault("api-version")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "api-version", valid_594499
  var valid_594500 = query.getOrDefault("$filter")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "$filter", valid_594500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594501: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_594491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protectable items in a protection container.
  ## 
  let valid = call_594501.validator(path, query, header, formData, body)
  let scheme = call_594501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594501.url(scheme.get, call_594501.host, call_594501.base,
                         call_594501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594501, url, valid)

proc call*(call_594502: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_594491;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; Filter: string = ""): Recallable =
  ## replicationProtectableItemsListByReplicationProtectionContainers
  ## Lists the protectable items in a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   Filter: string
  ##         : OData filter options.
  var path_594503 = newJObject()
  var query_594504 = newJObject()
  add(path_594503, "fabricName", newJString(fabricName))
  add(path_594503, "resourceGroupName", newJString(resourceGroupName))
  add(query_594504, "api-version", newJString(apiVersion))
  add(path_594503, "subscriptionId", newJString(subscriptionId))
  add(path_594503, "resourceName", newJString(resourceName))
  add(path_594503, "protectionContainerName", newJString(protectionContainerName))
  add(query_594504, "$filter", newJString(Filter))
  result = call_594502.call(path_594503, query_594504, nil, nil, nil)

var replicationProtectableItemsListByReplicationProtectionContainers* = Call_ReplicationProtectableItemsListByReplicationProtectionContainers_594491(
    name: "replicationProtectableItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems", validator: validate_ReplicationProtectableItemsListByReplicationProtectionContainers_594492,
    base: "",
    url: url_ReplicationProtectableItemsListByReplicationProtectionContainers_594493,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsGet_594505 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectableItemsGet_594507(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "protectableItemName" in path,
        "`protectableItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectableItems/"),
               (kind: VariableSegment, value: "protectableItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectableItemsGet_594506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of a protectable item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   protectableItemName: JString (required)
  ##                      : Protectable item name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594508 = path.getOrDefault("fabricName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "fabricName", valid_594508
  var valid_594509 = path.getOrDefault("resourceGroupName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "resourceGroupName", valid_594509
  var valid_594510 = path.getOrDefault("protectableItemName")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "protectableItemName", valid_594510
  var valid_594511 = path.getOrDefault("subscriptionId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "subscriptionId", valid_594511
  var valid_594512 = path.getOrDefault("resourceName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "resourceName", valid_594512
  var valid_594513 = path.getOrDefault("protectionContainerName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "protectionContainerName", valid_594513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594514 = query.getOrDefault("api-version")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "api-version", valid_594514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594515: Call_ReplicationProtectableItemsGet_594505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of a protectable item.
  ## 
  let valid = call_594515.validator(path, query, header, formData, body)
  let scheme = call_594515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594515.url(scheme.get, call_594515.host, call_594515.base,
                         call_594515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594515, url, valid)

proc call*(call_594516: Call_ReplicationProtectableItemsGet_594505;
          fabricName: string; resourceGroupName: string;
          protectableItemName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectableItemsGet
  ## The operation to get the details of a protectable item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   protectableItemName: string (required)
  ##                      : Protectable item name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594517 = newJObject()
  var query_594518 = newJObject()
  add(path_594517, "fabricName", newJString(fabricName))
  add(path_594517, "resourceGroupName", newJString(resourceGroupName))
  add(path_594517, "protectableItemName", newJString(protectableItemName))
  add(query_594518, "api-version", newJString(apiVersion))
  add(path_594517, "subscriptionId", newJString(subscriptionId))
  add(path_594517, "resourceName", newJString(resourceName))
  add(path_594517, "protectionContainerName", newJString(protectionContainerName))
  result = call_594516.call(path_594517, query_594518, nil, nil, nil)

var replicationProtectableItemsGet* = Call_ReplicationProtectableItemsGet_594505(
    name: "replicationProtectableItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems/{protectableItemName}",
    validator: validate_ReplicationProtectableItemsGet_594506, base: "",
    url: url_ReplicationProtectableItemsGet_594507, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsListByReplicationProtectionContainers_594519 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsListByReplicationProtectionContainers_594521(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsListByReplicationProtectionContainers_594520(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594522 = path.getOrDefault("fabricName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "fabricName", valid_594522
  var valid_594523 = path.getOrDefault("resourceGroupName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "resourceGroupName", valid_594523
  var valid_594524 = path.getOrDefault("subscriptionId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "subscriptionId", valid_594524
  var valid_594525 = path.getOrDefault("resourceName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "resourceName", valid_594525
  var valid_594526 = path.getOrDefault("protectionContainerName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "protectionContainerName", valid_594526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594527 = query.getOrDefault("api-version")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "api-version", valid_594527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594528: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_594519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  let valid = call_594528.validator(path, query, header, formData, body)
  let scheme = call_594528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594528.url(scheme.get, call_594528.host, call_594528.base,
                         call_594528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594528, url, valid)

proc call*(call_594529: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_594519;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectedItemsListByReplicationProtectionContainers
  ## Gets the list of ASR replication protected items in the protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594530 = newJObject()
  var query_594531 = newJObject()
  add(path_594530, "fabricName", newJString(fabricName))
  add(path_594530, "resourceGroupName", newJString(resourceGroupName))
  add(query_594531, "api-version", newJString(apiVersion))
  add(path_594530, "subscriptionId", newJString(subscriptionId))
  add(path_594530, "resourceName", newJString(resourceName))
  add(path_594530, "protectionContainerName", newJString(protectionContainerName))
  result = call_594529.call(path_594530, query_594531, nil, nil, nil)

var replicationProtectedItemsListByReplicationProtectionContainers* = Call_ReplicationProtectedItemsListByReplicationProtectionContainers_594519(
    name: "replicationProtectedItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems", validator: validate_ReplicationProtectedItemsListByReplicationProtectionContainers_594520,
    base: "",
    url: url_ReplicationProtectedItemsListByReplicationProtectionContainers_594521,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsCreate_594546 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsCreate_594548(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsCreate_594547(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : A name for the replication protected item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594549 = path.getOrDefault("fabricName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "fabricName", valid_594549
  var valid_594550 = path.getOrDefault("resourceGroupName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "resourceGroupName", valid_594550
  var valid_594551 = path.getOrDefault("subscriptionId")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "subscriptionId", valid_594551
  var valid_594552 = path.getOrDefault("resourceName")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "resourceName", valid_594552
  var valid_594553 = path.getOrDefault("protectionContainerName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "protectionContainerName", valid_594553
  var valid_594554 = path.getOrDefault("replicatedProtectedItemName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "replicatedProtectedItemName", valid_594554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594555 = query.getOrDefault("api-version")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "api-version", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Enable Protection Input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_ReplicationProtectedItemsCreate_594546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_ReplicationProtectedItemsCreate_594546;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsCreate
  ## The operation to create an ASR replication protected item (Enable replication).
  ##   fabricName: string (required)
  ##             : Name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Enable Protection Input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : A name for the replication protected item.
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  var body_594561 = newJObject()
  add(path_594559, "fabricName", newJString(fabricName))
  add(path_594559, "resourceGroupName", newJString(resourceGroupName))
  add(query_594560, "api-version", newJString(apiVersion))
  add(path_594559, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594561 = input
  add(path_594559, "resourceName", newJString(resourceName))
  add(path_594559, "protectionContainerName", newJString(protectionContainerName))
  add(path_594559, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594558.call(path_594559, query_594560, nil, nil, body_594561)

var replicationProtectedItemsCreate* = Call_ReplicationProtectedItemsCreate_594546(
    name: "replicationProtectedItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsCreate_594547, base: "",
    url: url_ReplicationProtectedItemsCreate_594548, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsGet_594532 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsGet_594534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsGet_594533(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594535 = path.getOrDefault("fabricName")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "fabricName", valid_594535
  var valid_594536 = path.getOrDefault("resourceGroupName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "resourceGroupName", valid_594536
  var valid_594537 = path.getOrDefault("subscriptionId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "subscriptionId", valid_594537
  var valid_594538 = path.getOrDefault("resourceName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "resourceName", valid_594538
  var valid_594539 = path.getOrDefault("protectionContainerName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "protectionContainerName", valid_594539
  var valid_594540 = path.getOrDefault("replicatedProtectedItemName")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "replicatedProtectedItemName", valid_594540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594541 = query.getOrDefault("api-version")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "api-version", valid_594541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594542: Call_ReplicationProtectedItemsGet_594532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR replication protected item.
  ## 
  let valid = call_594542.validator(path, query, header, formData, body)
  let scheme = call_594542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594542.url(scheme.get, call_594542.host, call_594542.base,
                         call_594542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594542, url, valid)

proc call*(call_594543: Call_ReplicationProtectedItemsGet_594532;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsGet
  ## Gets the details of an ASR replication protected item.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594544 = newJObject()
  var query_594545 = newJObject()
  add(path_594544, "fabricName", newJString(fabricName))
  add(path_594544, "resourceGroupName", newJString(resourceGroupName))
  add(query_594545, "api-version", newJString(apiVersion))
  add(path_594544, "subscriptionId", newJString(subscriptionId))
  add(path_594544, "resourceName", newJString(resourceName))
  add(path_594544, "protectionContainerName", newJString(protectionContainerName))
  add(path_594544, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594543.call(path_594544, query_594545, nil, nil, nil)

var replicationProtectedItemsGet* = Call_ReplicationProtectedItemsGet_594532(
    name: "replicationProtectedItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsGet_594533, base: "",
    url: url_ReplicationProtectedItemsGet_594534, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdate_594576 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsUpdate_594578(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUpdate_594577(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594579 = path.getOrDefault("fabricName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "fabricName", valid_594579
  var valid_594580 = path.getOrDefault("resourceGroupName")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "resourceGroupName", valid_594580
  var valid_594581 = path.getOrDefault("subscriptionId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "subscriptionId", valid_594581
  var valid_594582 = path.getOrDefault("resourceName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "resourceName", valid_594582
  var valid_594583 = path.getOrDefault("protectionContainerName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "protectionContainerName", valid_594583
  var valid_594584 = path.getOrDefault("replicatedProtectedItemName")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "replicatedProtectedItemName", valid_594584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594585 = query.getOrDefault("api-version")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "api-version", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateProtectionInput: JObject (required)
  ##                        : Update protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594587: Call_ReplicationProtectedItemsUpdate_594576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_ReplicationProtectedItemsUpdate_594576;
          updateProtectionInput: JsonNode; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUpdate
  ## The operation to update the recovery settings of an ASR replication protected item.
  ##   updateProtectionInput: JObject (required)
  ##                        : Update protection input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  var body_594591 = newJObject()
  if updateProtectionInput != nil:
    body_594591 = updateProtectionInput
  add(path_594589, "fabricName", newJString(fabricName))
  add(path_594589, "resourceGroupName", newJString(resourceGroupName))
  add(query_594590, "api-version", newJString(apiVersion))
  add(path_594589, "subscriptionId", newJString(subscriptionId))
  add(path_594589, "resourceName", newJString(resourceName))
  add(path_594589, "protectionContainerName", newJString(protectionContainerName))
  add(path_594589, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594588.call(path_594589, query_594590, nil, nil, body_594591)

var replicationProtectedItemsUpdate* = Call_ReplicationProtectedItemsUpdate_594576(
    name: "replicationProtectedItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsUpdate_594577, base: "",
    url: url_ReplicationProtectedItemsUpdate_594578, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPurge_594562 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsPurge_594564(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsPurge_594563(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594565 = path.getOrDefault("fabricName")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "fabricName", valid_594565
  var valid_594566 = path.getOrDefault("resourceGroupName")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "resourceGroupName", valid_594566
  var valid_594567 = path.getOrDefault("subscriptionId")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "subscriptionId", valid_594567
  var valid_594568 = path.getOrDefault("resourceName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "resourceName", valid_594568
  var valid_594569 = path.getOrDefault("protectionContainerName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "protectionContainerName", valid_594569
  var valid_594570 = path.getOrDefault("replicatedProtectedItemName")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "replicatedProtectedItemName", valid_594570
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594571 = query.getOrDefault("api-version")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "api-version", valid_594571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594572: Call_ReplicationProtectedItemsPurge_594562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  let valid = call_594572.validator(path, query, header, formData, body)
  let scheme = call_594572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594572.url(scheme.get, call_594572.host, call_594572.base,
                         call_594572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594572, url, valid)

proc call*(call_594573: Call_ReplicationProtectedItemsPurge_594562;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsPurge
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594574 = newJObject()
  var query_594575 = newJObject()
  add(path_594574, "fabricName", newJString(fabricName))
  add(path_594574, "resourceGroupName", newJString(resourceGroupName))
  add(query_594575, "api-version", newJString(apiVersion))
  add(path_594574, "subscriptionId", newJString(subscriptionId))
  add(path_594574, "resourceName", newJString(resourceName))
  add(path_594574, "protectionContainerName", newJString(protectionContainerName))
  add(path_594574, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594573.call(path_594574, query_594575, nil, nil, nil)

var replicationProtectedItemsPurge* = Call_ReplicationProtectedItemsPurge_594562(
    name: "replicationProtectedItemsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsPurge_594563, base: "",
    url: url_ReplicationProtectedItemsPurge_594564, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_594592 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsApplyRecoveryPoint_594594(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/applyRecoveryPoint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_594593(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The ARM fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replicated protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594595 = path.getOrDefault("fabricName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "fabricName", valid_594595
  var valid_594596 = path.getOrDefault("resourceGroupName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "resourceGroupName", valid_594596
  var valid_594597 = path.getOrDefault("subscriptionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "subscriptionId", valid_594597
  var valid_594598 = path.getOrDefault("resourceName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "resourceName", valid_594598
  var valid_594599 = path.getOrDefault("protectionContainerName")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "protectionContainerName", valid_594599
  var valid_594600 = path.getOrDefault("replicatedProtectedItemName")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "replicatedProtectedItemName", valid_594600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594601 = query.getOrDefault("api-version")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "api-version", valid_594601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyRecoveryPointInput: JObject (required)
  ##                          : The ApplyRecoveryPointInput.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_ReplicationProtectedItemsApplyRecoveryPoint_594592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_ReplicationProtectedItemsApplyRecoveryPoint_594592;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          applyRecoveryPointInput: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsApplyRecoveryPoint
  ## The operation to change the recovery point of a failed over replication protected item.
  ##   fabricName: string (required)
  ##             : The ARM fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   applyRecoveryPointInput: JObject (required)
  ##                          : The ApplyRecoveryPointInput.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replicated protected item's name.
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  var body_594607 = newJObject()
  add(path_594605, "fabricName", newJString(fabricName))
  add(path_594605, "resourceGroupName", newJString(resourceGroupName))
  add(query_594606, "api-version", newJString(apiVersion))
  if applyRecoveryPointInput != nil:
    body_594607 = applyRecoveryPointInput
  add(path_594605, "subscriptionId", newJString(subscriptionId))
  add(path_594605, "resourceName", newJString(resourceName))
  add(path_594605, "protectionContainerName", newJString(protectionContainerName))
  add(path_594605, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594604.call(path_594605, query_594606, nil, nil, body_594607)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_594592(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_594593,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_594594,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_594608 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsFailoverCommit_594610(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/failoverCommit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsFailoverCommit_594609(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to commit the failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594611 = path.getOrDefault("fabricName")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "fabricName", valid_594611
  var valid_594612 = path.getOrDefault("resourceGroupName")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "resourceGroupName", valid_594612
  var valid_594613 = path.getOrDefault("subscriptionId")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "subscriptionId", valid_594613
  var valid_594614 = path.getOrDefault("resourceName")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "resourceName", valid_594614
  var valid_594615 = path.getOrDefault("protectionContainerName")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "protectionContainerName", valid_594615
  var valid_594616 = path.getOrDefault("replicatedProtectedItemName")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "replicatedProtectedItemName", valid_594616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594617 = query.getOrDefault("api-version")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "api-version", valid_594617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594618: Call_ReplicationProtectedItemsFailoverCommit_594608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_594618.validator(path, query, header, formData, body)
  let scheme = call_594618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594618.url(scheme.get, call_594618.host, call_594618.base,
                         call_594618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594618, url, valid)

proc call*(call_594619: Call_ReplicationProtectedItemsFailoverCommit_594608;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsFailoverCommit
  ## Operation to commit the failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594620 = newJObject()
  var query_594621 = newJObject()
  add(path_594620, "fabricName", newJString(fabricName))
  add(path_594620, "resourceGroupName", newJString(resourceGroupName))
  add(query_594621, "api-version", newJString(apiVersion))
  add(path_594620, "subscriptionId", newJString(subscriptionId))
  add(path_594620, "resourceName", newJString(resourceName))
  add(path_594620, "protectionContainerName", newJString(protectionContainerName))
  add(path_594620, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594619.call(path_594620, query_594621, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_594608(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_594609, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_594610,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_594622 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsPlannedFailover_594624(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/plannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsPlannedFailover_594623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594625 = path.getOrDefault("fabricName")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "fabricName", valid_594625
  var valid_594626 = path.getOrDefault("resourceGroupName")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "resourceGroupName", valid_594626
  var valid_594627 = path.getOrDefault("subscriptionId")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "subscriptionId", valid_594627
  var valid_594628 = path.getOrDefault("resourceName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "resourceName", valid_594628
  var valid_594629 = path.getOrDefault("protectionContainerName")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "protectionContainerName", valid_594629
  var valid_594630 = path.getOrDefault("replicatedProtectedItemName")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "replicatedProtectedItemName", valid_594630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594631 = query.getOrDefault("api-version")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "api-version", valid_594631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594633: Call_ReplicationProtectedItemsPlannedFailover_594622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_594633.validator(path, query, header, formData, body)
  let scheme = call_594633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594633.url(scheme.get, call_594633.host, call_594633.base,
                         call_594633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594633, url, valid)

proc call*(call_594634: Call_ReplicationProtectedItemsPlannedFailover_594622;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsPlannedFailover
  ## Operation to initiate a planned failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594635 = newJObject()
  var query_594636 = newJObject()
  var body_594637 = newJObject()
  add(path_594635, "fabricName", newJString(fabricName))
  add(path_594635, "resourceGroupName", newJString(resourceGroupName))
  add(query_594636, "api-version", newJString(apiVersion))
  add(path_594635, "subscriptionId", newJString(subscriptionId))
  add(path_594635, "resourceName", newJString(resourceName))
  add(path_594635, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594637 = failoverInput
  add(path_594635, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594634.call(path_594635, query_594636, nil, nil, body_594637)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_594622(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_594623, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_594624,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_594638 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsReprotect_594640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/reProtect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsReprotect_594639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594641 = path.getOrDefault("fabricName")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "fabricName", valid_594641
  var valid_594642 = path.getOrDefault("resourceGroupName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "resourceGroupName", valid_594642
  var valid_594643 = path.getOrDefault("subscriptionId")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "subscriptionId", valid_594643
  var valid_594644 = path.getOrDefault("resourceName")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "resourceName", valid_594644
  var valid_594645 = path.getOrDefault("protectionContainerName")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "protectionContainerName", valid_594645
  var valid_594646 = path.getOrDefault("replicatedProtectedItemName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "replicatedProtectedItemName", valid_594646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594647 = query.getOrDefault("api-version")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "api-version", valid_594647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   rrInput: JObject (required)
  ##          : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594649: Call_ReplicationProtectedItemsReprotect_594638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_594649.validator(path, query, header, formData, body)
  let scheme = call_594649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594649.url(scheme.get, call_594649.host, call_594649.base,
                         call_594649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594649, url, valid)

proc call*(call_594650: Call_ReplicationProtectedItemsReprotect_594638;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; rrInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsReprotect
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   rrInput: JObject (required)
  ##          : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594651 = newJObject()
  var query_594652 = newJObject()
  var body_594653 = newJObject()
  add(path_594651, "fabricName", newJString(fabricName))
  add(path_594651, "resourceGroupName", newJString(resourceGroupName))
  add(query_594652, "api-version", newJString(apiVersion))
  add(path_594651, "subscriptionId", newJString(subscriptionId))
  add(path_594651, "resourceName", newJString(resourceName))
  add(path_594651, "protectionContainerName", newJString(protectionContainerName))
  if rrInput != nil:
    body_594653 = rrInput
  add(path_594651, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594650.call(path_594651, query_594652, nil, nil, body_594653)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_594638(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_594639, base: "",
    url: url_ReplicationProtectedItemsReprotect_594640, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_594654 = ref object of OpenApiRestCall_593439
proc url_RecoveryPointsListByReplicationProtectedItems_594656(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsListByReplicationProtectedItems_594655(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available recovery points for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594657 = path.getOrDefault("fabricName")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "fabricName", valid_594657
  var valid_594658 = path.getOrDefault("resourceGroupName")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "resourceGroupName", valid_594658
  var valid_594659 = path.getOrDefault("subscriptionId")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "subscriptionId", valid_594659
  var valid_594660 = path.getOrDefault("resourceName")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "resourceName", valid_594660
  var valid_594661 = path.getOrDefault("protectionContainerName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "protectionContainerName", valid_594661
  var valid_594662 = path.getOrDefault("replicatedProtectedItemName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "replicatedProtectedItemName", valid_594662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594663 = query.getOrDefault("api-version")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "api-version", valid_594663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594664: Call_RecoveryPointsListByReplicationProtectedItems_594654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_RecoveryPointsListByReplicationProtectedItems_594654;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## recoveryPointsListByReplicationProtectedItems
  ## Lists the available recovery points for a replication protected item.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  add(path_594666, "fabricName", newJString(fabricName))
  add(path_594666, "resourceGroupName", newJString(resourceGroupName))
  add(query_594667, "api-version", newJString(apiVersion))
  add(path_594666, "subscriptionId", newJString(subscriptionId))
  add(path_594666, "resourceName", newJString(resourceName))
  add(path_594666, "protectionContainerName", newJString(protectionContainerName))
  add(path_594666, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594665.call(path_594666, query_594667, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_594654(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_594655,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_594656,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_594668 = ref object of OpenApiRestCall_593439
proc url_RecoveryPointsGet_594670(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  assert "recoveryPointName" in path,
        "`recoveryPointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsGet_594669(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the details of specified recovery point.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   recoveryPointName: JString (required)
  ##                    : The recovery point name.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594671 = path.getOrDefault("fabricName")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "fabricName", valid_594671
  var valid_594672 = path.getOrDefault("resourceGroupName")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "resourceGroupName", valid_594672
  var valid_594673 = path.getOrDefault("subscriptionId")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "subscriptionId", valid_594673
  var valid_594674 = path.getOrDefault("resourceName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "resourceName", valid_594674
  var valid_594675 = path.getOrDefault("recoveryPointName")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "recoveryPointName", valid_594675
  var valid_594676 = path.getOrDefault("protectionContainerName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "protectionContainerName", valid_594676
  var valid_594677 = path.getOrDefault("replicatedProtectedItemName")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "replicatedProtectedItemName", valid_594677
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594678 = query.getOrDefault("api-version")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "api-version", valid_594678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594679: Call_RecoveryPointsGet_594668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_594679.validator(path, query, header, formData, body)
  let scheme = call_594679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594679.url(scheme.get, call_594679.host, call_594679.base,
                         call_594679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594679, url, valid)

proc call*(call_594680: Call_RecoveryPointsGet_594668; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; recoveryPointName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## recoveryPointsGet
  ## Get the details of specified recovery point.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   recoveryPointName: string (required)
  ##                    : The recovery point name.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  var path_594681 = newJObject()
  var query_594682 = newJObject()
  add(path_594681, "fabricName", newJString(fabricName))
  add(path_594681, "resourceGroupName", newJString(resourceGroupName))
  add(query_594682, "api-version", newJString(apiVersion))
  add(path_594681, "subscriptionId", newJString(subscriptionId))
  add(path_594681, "resourceName", newJString(resourceName))
  add(path_594681, "recoveryPointName", newJString(recoveryPointName))
  add(path_594681, "protectionContainerName", newJString(protectionContainerName))
  add(path_594681, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594680.call(path_594681, query_594682, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_594668(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_594669, base: "",
    url: url_RecoveryPointsGet_594670, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_594683 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsDelete_594685(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsDelete_594684(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594686 = path.getOrDefault("fabricName")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "fabricName", valid_594686
  var valid_594687 = path.getOrDefault("resourceGroupName")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "resourceGroupName", valid_594687
  var valid_594688 = path.getOrDefault("subscriptionId")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "subscriptionId", valid_594688
  var valid_594689 = path.getOrDefault("resourceName")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "resourceName", valid_594689
  var valid_594690 = path.getOrDefault("protectionContainerName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "protectionContainerName", valid_594690
  var valid_594691 = path.getOrDefault("replicatedProtectedItemName")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "replicatedProtectedItemName", valid_594691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594692 = query.getOrDefault("api-version")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "api-version", valid_594692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disableProtectionInput: JObject (required)
  ##                         : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594694: Call_ReplicationProtectedItemsDelete_594683;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_594694.validator(path, query, header, formData, body)
  let scheme = call_594694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594694.url(scheme.get, call_594694.host, call_594694.base,
                         call_594694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594694, url, valid)

proc call*(call_594695: Call_ReplicationProtectedItemsDelete_594683;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; disableProtectionInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsDelete
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   disableProtectionInput: JObject (required)
  ##                         : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594696 = newJObject()
  var query_594697 = newJObject()
  var body_594698 = newJObject()
  add(path_594696, "fabricName", newJString(fabricName))
  add(path_594696, "resourceGroupName", newJString(resourceGroupName))
  add(query_594697, "api-version", newJString(apiVersion))
  add(path_594696, "subscriptionId", newJString(subscriptionId))
  add(path_594696, "resourceName", newJString(resourceName))
  add(path_594696, "protectionContainerName", newJString(protectionContainerName))
  if disableProtectionInput != nil:
    body_594698 = disableProtectionInput
  add(path_594696, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594695.call(path_594696, query_594697, nil, nil, body_594698)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_594683(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_594684, base: "",
    url: url_ReplicationProtectedItemsDelete_594685, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_594699 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsRepairReplication_594701(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/repairReplication")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsRepairReplication_594700(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The name of the replication protected item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594702 = path.getOrDefault("fabricName")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "fabricName", valid_594702
  var valid_594703 = path.getOrDefault("resourceGroupName")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "resourceGroupName", valid_594703
  var valid_594704 = path.getOrDefault("subscriptionId")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "subscriptionId", valid_594704
  var valid_594705 = path.getOrDefault("resourceName")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "resourceName", valid_594705
  var valid_594706 = path.getOrDefault("protectionContainerName")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "protectionContainerName", valid_594706
  var valid_594707 = path.getOrDefault("replicatedProtectedItemName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "replicatedProtectedItemName", valid_594707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594708 = query.getOrDefault("api-version")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "api-version", valid_594708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594709: Call_ReplicationProtectedItemsRepairReplication_594699;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_594709.validator(path, query, header, formData, body)
  let scheme = call_594709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594709.url(scheme.get, call_594709.host, call_594709.base,
                         call_594709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594709, url, valid)

proc call*(call_594710: Call_ReplicationProtectedItemsRepairReplication_594699;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsRepairReplication
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The name of the replication protected item.
  var path_594711 = newJObject()
  var query_594712 = newJObject()
  add(path_594711, "fabricName", newJString(fabricName))
  add(path_594711, "resourceGroupName", newJString(resourceGroupName))
  add(query_594712, "api-version", newJString(apiVersion))
  add(path_594711, "subscriptionId", newJString(subscriptionId))
  add(path_594711, "resourceName", newJString(resourceName))
  add(path_594711, "protectionContainerName", newJString(protectionContainerName))
  add(path_594711, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594710.call(path_594711, query_594712, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_594699(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_594700,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_594701,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_594713 = ref object of OpenApiRestCall_593439
proc url_TargetComputeSizesListByReplicationProtectedItems_594715(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/targetComputeSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TargetComputeSizesListByReplicationProtectedItems_594714(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594716 = path.getOrDefault("fabricName")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "fabricName", valid_594716
  var valid_594717 = path.getOrDefault("resourceGroupName")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = nil)
  if valid_594717 != nil:
    section.add "resourceGroupName", valid_594717
  var valid_594718 = path.getOrDefault("subscriptionId")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "subscriptionId", valid_594718
  var valid_594719 = path.getOrDefault("resourceName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "resourceName", valid_594719
  var valid_594720 = path.getOrDefault("protectionContainerName")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "protectionContainerName", valid_594720
  var valid_594721 = path.getOrDefault("replicatedProtectedItemName")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "replicatedProtectedItemName", valid_594721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594722 = query.getOrDefault("api-version")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "api-version", valid_594722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594723: Call_TargetComputeSizesListByReplicationProtectedItems_594713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_594723.validator(path, query, header, formData, body)
  let scheme = call_594723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594723.url(scheme.get, call_594723.host, call_594723.base,
                         call_594723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594723, url, valid)

proc call*(call_594724: Call_TargetComputeSizesListByReplicationProtectedItems_594713;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## targetComputeSizesListByReplicationProtectedItems
  ## Lists the available target compute sizes for a replication protected item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594725 = newJObject()
  var query_594726 = newJObject()
  add(path_594725, "fabricName", newJString(fabricName))
  add(path_594725, "resourceGroupName", newJString(resourceGroupName))
  add(query_594726, "api-version", newJString(apiVersion))
  add(path_594725, "subscriptionId", newJString(subscriptionId))
  add(path_594725, "resourceName", newJString(resourceName))
  add(path_594725, "protectionContainerName", newJString(protectionContainerName))
  add(path_594725, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594724.call(path_594725, query_594726, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_594713(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_594714,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_594715,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_594727 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsTestFailover_594729(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/testFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsTestFailover_594728(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594730 = path.getOrDefault("fabricName")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "fabricName", valid_594730
  var valid_594731 = path.getOrDefault("resourceGroupName")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "resourceGroupName", valid_594731
  var valid_594732 = path.getOrDefault("subscriptionId")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "subscriptionId", valid_594732
  var valid_594733 = path.getOrDefault("resourceName")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "resourceName", valid_594733
  var valid_594734 = path.getOrDefault("protectionContainerName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "protectionContainerName", valid_594734
  var valid_594735 = path.getOrDefault("replicatedProtectedItemName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "replicatedProtectedItemName", valid_594735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594736 = query.getOrDefault("api-version")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "api-version", valid_594736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594738: Call_ReplicationProtectedItemsTestFailover_594727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_594738.validator(path, query, header, formData, body)
  let scheme = call_594738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594738.url(scheme.get, call_594738.host, call_594738.base,
                         call_594738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594738, url, valid)

proc call*(call_594739: Call_ReplicationProtectedItemsTestFailover_594727;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsTestFailover
  ## Operation to perform a test failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594740 = newJObject()
  var query_594741 = newJObject()
  var body_594742 = newJObject()
  add(path_594740, "fabricName", newJString(fabricName))
  add(path_594740, "resourceGroupName", newJString(resourceGroupName))
  add(query_594741, "api-version", newJString(apiVersion))
  add(path_594740, "subscriptionId", newJString(subscriptionId))
  add(path_594740, "resourceName", newJString(resourceName))
  add(path_594740, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594742 = failoverInput
  add(path_594740, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594739.call(path_594740, query_594741, nil, nil, body_594742)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_594727(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_594728, base: "",
    url: url_ReplicationProtectedItemsTestFailover_594729, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_594743 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsTestFailoverCleanup_594745(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/testFailoverCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsTestFailoverCleanup_594744(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594746 = path.getOrDefault("fabricName")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "fabricName", valid_594746
  var valid_594747 = path.getOrDefault("resourceGroupName")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "resourceGroupName", valid_594747
  var valid_594748 = path.getOrDefault("subscriptionId")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "subscriptionId", valid_594748
  var valid_594749 = path.getOrDefault("resourceName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "resourceName", valid_594749
  var valid_594750 = path.getOrDefault("protectionContainerName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "protectionContainerName", valid_594750
  var valid_594751 = path.getOrDefault("replicatedProtectedItemName")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "replicatedProtectedItemName", valid_594751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594752 = query.getOrDefault("api-version")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "api-version", valid_594752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cleanupInput: JObject (required)
  ##               : Test failover cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594754: Call_ReplicationProtectedItemsTestFailoverCleanup_594743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_594754.validator(path, query, header, formData, body)
  let scheme = call_594754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594754.url(scheme.get, call_594754.host, call_594754.base,
                         call_594754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594754, url, valid)

proc call*(call_594755: Call_ReplicationProtectedItemsTestFailoverCleanup_594743;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          cleanupInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsTestFailoverCleanup
  ## Operation to clean up the test failover of a replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cleanupInput: JObject (required)
  ##               : Test failover cleanup input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594756 = newJObject()
  var query_594757 = newJObject()
  var body_594758 = newJObject()
  add(path_594756, "fabricName", newJString(fabricName))
  add(path_594756, "resourceGroupName", newJString(resourceGroupName))
  add(query_594757, "api-version", newJString(apiVersion))
  if cleanupInput != nil:
    body_594758 = cleanupInput
  add(path_594756, "subscriptionId", newJString(subscriptionId))
  add(path_594756, "resourceName", newJString(resourceName))
  add(path_594756, "protectionContainerName", newJString(protectionContainerName))
  add(path_594756, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594755.call(path_594756, query_594757, nil, nil, body_594758)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_594743(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_594744,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_594745,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_594759 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsUnplannedFailover_594761(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/unplannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUnplannedFailover_594760(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594762 = path.getOrDefault("fabricName")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "fabricName", valid_594762
  var valid_594763 = path.getOrDefault("resourceGroupName")
  valid_594763 = validateParameter(valid_594763, JString, required = true,
                                 default = nil)
  if valid_594763 != nil:
    section.add "resourceGroupName", valid_594763
  var valid_594764 = path.getOrDefault("subscriptionId")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "subscriptionId", valid_594764
  var valid_594765 = path.getOrDefault("resourceName")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "resourceName", valid_594765
  var valid_594766 = path.getOrDefault("protectionContainerName")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "protectionContainerName", valid_594766
  var valid_594767 = path.getOrDefault("replicatedProtectedItemName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "replicatedProtectedItemName", valid_594767
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594768 = query.getOrDefault("api-version")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "api-version", valid_594768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594770: Call_ReplicationProtectedItemsUnplannedFailover_594759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_594770.validator(path, query, header, formData, body)
  let scheme = call_594770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594770.url(scheme.get, call_594770.host, call_594770.base,
                         call_594770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594770, url, valid)

proc call*(call_594771: Call_ReplicationProtectedItemsUnplannedFailover_594759;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUnplannedFailover
  ## Operation to initiate a failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594772 = newJObject()
  var query_594773 = newJObject()
  var body_594774 = newJObject()
  add(path_594772, "fabricName", newJString(fabricName))
  add(path_594772, "resourceGroupName", newJString(resourceGroupName))
  add(query_594773, "api-version", newJString(apiVersion))
  add(path_594772, "subscriptionId", newJString(subscriptionId))
  add(path_594772, "resourceName", newJString(resourceName))
  add(path_594772, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594774 = failoverInput
  add(path_594772, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594771.call(path_594772, query_594773, nil, nil, body_594774)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_594759(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_594760,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_594761,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_594775 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsUpdateMobilityService_594777(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicationProtectedItemName" in path,
        "`replicationProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicationProtectedItemName"),
               (kind: ConstantSegment, value: "/updateMobilityService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUpdateMobilityService_594776(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the protected item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container containing the protected item.
  ##   replicationProtectedItemName: JString (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594778 = path.getOrDefault("fabricName")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "fabricName", valid_594778
  var valid_594779 = path.getOrDefault("resourceGroupName")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "resourceGroupName", valid_594779
  var valid_594780 = path.getOrDefault("subscriptionId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "subscriptionId", valid_594780
  var valid_594781 = path.getOrDefault("resourceName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "resourceName", valid_594781
  var valid_594782 = path.getOrDefault("protectionContainerName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "protectionContainerName", valid_594782
  var valid_594783 = path.getOrDefault("replicationProtectedItemName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "replicationProtectedItemName", valid_594783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594784 = query.getOrDefault("api-version")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "api-version", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateMobilityServiceRequest: JObject (required)
  ##                               : Request to update the mobility service on the protected item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594786: Call_ReplicationProtectedItemsUpdateMobilityService_594775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_594786.validator(path, query, header, formData, body)
  let scheme = call_594786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594786.url(scheme.get, call_594786.host, call_594786.base,
                         call_594786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594786, url, valid)

proc call*(call_594787: Call_ReplicationProtectedItemsUpdateMobilityService_594775;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          updateMobilityServiceRequest: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicationProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUpdateMobilityService
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the protected item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   updateMobilityServiceRequest: JObject (required)
  ##                               : Request to update the mobility service on the protected item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container containing the protected item.
  ##   replicationProtectedItemName: string (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  var path_594788 = newJObject()
  var query_594789 = newJObject()
  var body_594790 = newJObject()
  add(path_594788, "fabricName", newJString(fabricName))
  add(path_594788, "resourceGroupName", newJString(resourceGroupName))
  add(query_594789, "api-version", newJString(apiVersion))
  if updateMobilityServiceRequest != nil:
    body_594790 = updateMobilityServiceRequest
  add(path_594788, "subscriptionId", newJString(subscriptionId))
  add(path_594788, "resourceName", newJString(resourceName))
  add(path_594788, "protectionContainerName", newJString(protectionContainerName))
  add(path_594788, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  result = call_594787.call(path_594788, query_594789, nil, nil, body_594790)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_594775(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_594776,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_594777,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594791 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594793(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594792(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection container mappings for a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594794 = path.getOrDefault("fabricName")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "fabricName", valid_594794
  var valid_594795 = path.getOrDefault("resourceGroupName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "resourceGroupName", valid_594795
  var valid_594796 = path.getOrDefault("subscriptionId")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "subscriptionId", valid_594796
  var valid_594797 = path.getOrDefault("resourceName")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "resourceName", valid_594797
  var valid_594798 = path.getOrDefault("protectionContainerName")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "protectionContainerName", valid_594798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594799 = query.getOrDefault("api-version")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "api-version", valid_594799
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594800: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_594800.validator(path, query, header, formData, body)
  let scheme = call_594800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594800.url(scheme.get, call_594800.host, call_594800.base,
                         call_594800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594800, url, valid)

proc call*(call_594801: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594791;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsListByReplicationProtectionContainers
  ## Lists the protection container mappings for a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594802 = newJObject()
  var query_594803 = newJObject()
  add(path_594802, "fabricName", newJString(fabricName))
  add(path_594802, "resourceGroupName", newJString(resourceGroupName))
  add(query_594803, "api-version", newJString(apiVersion))
  add(path_594802, "subscriptionId", newJString(subscriptionId))
  add(path_594802, "resourceName", newJString(resourceName))
  add(path_594802, "protectionContainerName", newJString(protectionContainerName))
  result = call_594801.call(path_594802, query_594803, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594791(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594792,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594793,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_594818 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsCreate_594820(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsCreate_594819(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594821 = path.getOrDefault("fabricName")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "fabricName", valid_594821
  var valid_594822 = path.getOrDefault("resourceGroupName")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "resourceGroupName", valid_594822
  var valid_594823 = path.getOrDefault("mappingName")
  valid_594823 = validateParameter(valid_594823, JString, required = true,
                                 default = nil)
  if valid_594823 != nil:
    section.add "mappingName", valid_594823
  var valid_594824 = path.getOrDefault("subscriptionId")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = nil)
  if valid_594824 != nil:
    section.add "subscriptionId", valid_594824
  var valid_594825 = path.getOrDefault("resourceName")
  valid_594825 = validateParameter(valid_594825, JString, required = true,
                                 default = nil)
  if valid_594825 != nil:
    section.add "resourceName", valid_594825
  var valid_594826 = path.getOrDefault("protectionContainerName")
  valid_594826 = validateParameter(valid_594826, JString, required = true,
                                 default = nil)
  if valid_594826 != nil:
    section.add "protectionContainerName", valid_594826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594827 = query.getOrDefault("api-version")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "api-version", valid_594827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   creationInput: JObject (required)
  ##                : Mapping creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594829: Call_ReplicationProtectionContainerMappingsCreate_594818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_594829.validator(path, query, header, formData, body)
  let scheme = call_594829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594829.url(scheme.get, call_594829.host, call_594829.base,
                         call_594829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594829, url, valid)

proc call*(call_594830: Call_ReplicationProtectionContainerMappingsCreate_594818;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; creationInput: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsCreate
  ## The operation to create a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   creationInput: JObject (required)
  ##                : Mapping creation input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594831 = newJObject()
  var query_594832 = newJObject()
  var body_594833 = newJObject()
  add(path_594831, "fabricName", newJString(fabricName))
  add(path_594831, "resourceGroupName", newJString(resourceGroupName))
  add(query_594832, "api-version", newJString(apiVersion))
  add(path_594831, "mappingName", newJString(mappingName))
  if creationInput != nil:
    body_594833 = creationInput
  add(path_594831, "subscriptionId", newJString(subscriptionId))
  add(path_594831, "resourceName", newJString(resourceName))
  add(path_594831, "protectionContainerName", newJString(protectionContainerName))
  result = call_594830.call(path_594831, query_594832, nil, nil, body_594833)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_594818(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_594819,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_594820,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_594804 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsGet_594806(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsGet_594805(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection Container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594807 = path.getOrDefault("fabricName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "fabricName", valid_594807
  var valid_594808 = path.getOrDefault("resourceGroupName")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "resourceGroupName", valid_594808
  var valid_594809 = path.getOrDefault("mappingName")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "mappingName", valid_594809
  var valid_594810 = path.getOrDefault("subscriptionId")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "subscriptionId", valid_594810
  var valid_594811 = path.getOrDefault("resourceName")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "resourceName", valid_594811
  var valid_594812 = path.getOrDefault("protectionContainerName")
  valid_594812 = validateParameter(valid_594812, JString, required = true,
                                 default = nil)
  if valid_594812 != nil:
    section.add "protectionContainerName", valid_594812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594813 = query.getOrDefault("api-version")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "api-version", valid_594813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594814: Call_ReplicationProtectionContainerMappingsGet_594804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_594814.validator(path, query, header, formData, body)
  let scheme = call_594814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594814.url(scheme.get, call_594814.host, call_594814.base,
                         call_594814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594814, url, valid)

proc call*(call_594815: Call_ReplicationProtectionContainerMappingsGet_594804;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsGet
  ## Gets the details of a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection Container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594816 = newJObject()
  var query_594817 = newJObject()
  add(path_594816, "fabricName", newJString(fabricName))
  add(path_594816, "resourceGroupName", newJString(resourceGroupName))
  add(query_594817, "api-version", newJString(apiVersion))
  add(path_594816, "mappingName", newJString(mappingName))
  add(path_594816, "subscriptionId", newJString(subscriptionId))
  add(path_594816, "resourceName", newJString(resourceName))
  add(path_594816, "protectionContainerName", newJString(protectionContainerName))
  result = call_594815.call(path_594816, query_594817, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_594804(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_594805,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_594806,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_594848 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsUpdate_594850(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsUpdate_594849(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594851 = path.getOrDefault("fabricName")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "fabricName", valid_594851
  var valid_594852 = path.getOrDefault("resourceGroupName")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "resourceGroupName", valid_594852
  var valid_594853 = path.getOrDefault("mappingName")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "mappingName", valid_594853
  var valid_594854 = path.getOrDefault("subscriptionId")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "subscriptionId", valid_594854
  var valid_594855 = path.getOrDefault("resourceName")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "resourceName", valid_594855
  var valid_594856 = path.getOrDefault("protectionContainerName")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "protectionContainerName", valid_594856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594857 = query.getOrDefault("api-version")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "api-version", valid_594857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594859: Call_ReplicationProtectionContainerMappingsUpdate_594848;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_594859.validator(path, query, header, formData, body)
  let scheme = call_594859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594859.url(scheme.get, call_594859.host, call_594859.base,
                         call_594859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594859, url, valid)

proc call*(call_594860: Call_ReplicationProtectionContainerMappingsUpdate_594848;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; updateInput: JsonNode;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsUpdate
  ## The operation to update protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594861 = newJObject()
  var query_594862 = newJObject()
  var body_594863 = newJObject()
  add(path_594861, "fabricName", newJString(fabricName))
  add(path_594861, "resourceGroupName", newJString(resourceGroupName))
  add(query_594862, "api-version", newJString(apiVersion))
  add(path_594861, "mappingName", newJString(mappingName))
  add(path_594861, "subscriptionId", newJString(subscriptionId))
  if updateInput != nil:
    body_594863 = updateInput
  add(path_594861, "resourceName", newJString(resourceName))
  add(path_594861, "protectionContainerName", newJString(protectionContainerName))
  result = call_594860.call(path_594861, query_594862, nil, nil, body_594863)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_594848(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_594849,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_594850,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_594834 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsPurge_594836(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsPurge_594835(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594837 = path.getOrDefault("fabricName")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "fabricName", valid_594837
  var valid_594838 = path.getOrDefault("resourceGroupName")
  valid_594838 = validateParameter(valid_594838, JString, required = true,
                                 default = nil)
  if valid_594838 != nil:
    section.add "resourceGroupName", valid_594838
  var valid_594839 = path.getOrDefault("mappingName")
  valid_594839 = validateParameter(valid_594839, JString, required = true,
                                 default = nil)
  if valid_594839 != nil:
    section.add "mappingName", valid_594839
  var valid_594840 = path.getOrDefault("subscriptionId")
  valid_594840 = validateParameter(valid_594840, JString, required = true,
                                 default = nil)
  if valid_594840 != nil:
    section.add "subscriptionId", valid_594840
  var valid_594841 = path.getOrDefault("resourceName")
  valid_594841 = validateParameter(valid_594841, JString, required = true,
                                 default = nil)
  if valid_594841 != nil:
    section.add "resourceName", valid_594841
  var valid_594842 = path.getOrDefault("protectionContainerName")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "protectionContainerName", valid_594842
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594843 = query.getOrDefault("api-version")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "api-version", valid_594843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594844: Call_ReplicationProtectionContainerMappingsPurge_594834;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_594844.validator(path, query, header, formData, body)
  let scheme = call_594844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594844.url(scheme.get, call_594844.host, call_594844.base,
                         call_594844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594844, url, valid)

proc call*(call_594845: Call_ReplicationProtectionContainerMappingsPurge_594834;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsPurge
  ## The operation to purge(force delete) a protection container mapping
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_594846 = newJObject()
  var query_594847 = newJObject()
  add(path_594846, "fabricName", newJString(fabricName))
  add(path_594846, "resourceGroupName", newJString(resourceGroupName))
  add(query_594847, "api-version", newJString(apiVersion))
  add(path_594846, "mappingName", newJString(mappingName))
  add(path_594846, "subscriptionId", newJString(subscriptionId))
  add(path_594846, "resourceName", newJString(resourceName))
  add(path_594846, "protectionContainerName", newJString(protectionContainerName))
  result = call_594845.call(path_594846, query_594847, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_594834(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_594835,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_594836,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_594864 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsDelete_594866(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsDelete_594865(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594867 = path.getOrDefault("fabricName")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "fabricName", valid_594867
  var valid_594868 = path.getOrDefault("resourceGroupName")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "resourceGroupName", valid_594868
  var valid_594869 = path.getOrDefault("mappingName")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "mappingName", valid_594869
  var valid_594870 = path.getOrDefault("subscriptionId")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "subscriptionId", valid_594870
  var valid_594871 = path.getOrDefault("resourceName")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "resourceName", valid_594871
  var valid_594872 = path.getOrDefault("protectionContainerName")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = nil)
  if valid_594872 != nil:
    section.add "protectionContainerName", valid_594872
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594873 = query.getOrDefault("api-version")
  valid_594873 = validateParameter(valid_594873, JString, required = true,
                                 default = nil)
  if valid_594873 != nil:
    section.add "api-version", valid_594873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removalInput: JObject (required)
  ##               : Removal input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594875: Call_ReplicationProtectionContainerMappingsDelete_594864;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_594875.validator(path, query, header, formData, body)
  let scheme = call_594875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594875.url(scheme.get, call_594875.host, call_594875.base,
                         call_594875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594875, url, valid)

proc call*(call_594876: Call_ReplicationProtectionContainerMappingsDelete_594864;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string; removalInput: JsonNode): Recallable =
  ## replicationProtectionContainerMappingsDelete
  ## The operation to delete or remove a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   removalInput: JObject (required)
  ##               : Removal input.
  var path_594877 = newJObject()
  var query_594878 = newJObject()
  var body_594879 = newJObject()
  add(path_594877, "fabricName", newJString(fabricName))
  add(path_594877, "resourceGroupName", newJString(resourceGroupName))
  add(query_594878, "api-version", newJString(apiVersion))
  add(path_594877, "mappingName", newJString(mappingName))
  add(path_594877, "subscriptionId", newJString(subscriptionId))
  add(path_594877, "resourceName", newJString(resourceName))
  add(path_594877, "protectionContainerName", newJString(protectionContainerName))
  if removalInput != nil:
    body_594879 = removalInput
  result = call_594876.call(path_594877, query_594878, nil, nil, body_594879)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_594864(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_594865,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_594866,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_594880 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersSwitchProtection_594882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/switchprotection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersSwitchProtection_594881(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594883 = path.getOrDefault("fabricName")
  valid_594883 = validateParameter(valid_594883, JString, required = true,
                                 default = nil)
  if valid_594883 != nil:
    section.add "fabricName", valid_594883
  var valid_594884 = path.getOrDefault("resourceGroupName")
  valid_594884 = validateParameter(valid_594884, JString, required = true,
                                 default = nil)
  if valid_594884 != nil:
    section.add "resourceGroupName", valid_594884
  var valid_594885 = path.getOrDefault("subscriptionId")
  valid_594885 = validateParameter(valid_594885, JString, required = true,
                                 default = nil)
  if valid_594885 != nil:
    section.add "subscriptionId", valid_594885
  var valid_594886 = path.getOrDefault("resourceName")
  valid_594886 = validateParameter(valid_594886, JString, required = true,
                                 default = nil)
  if valid_594886 != nil:
    section.add "resourceName", valid_594886
  var valid_594887 = path.getOrDefault("protectionContainerName")
  valid_594887 = validateParameter(valid_594887, JString, required = true,
                                 default = nil)
  if valid_594887 != nil:
    section.add "protectionContainerName", valid_594887
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594888 = query.getOrDefault("api-version")
  valid_594888 = validateParameter(valid_594888, JString, required = true,
                                 default = nil)
  if valid_594888 != nil:
    section.add "api-version", valid_594888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   switchInput: JObject (required)
  ##              : Switch protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594890: Call_ReplicationProtectionContainersSwitchProtection_594880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_594890.validator(path, query, header, formData, body)
  let scheme = call_594890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594890.url(scheme.get, call_594890.host, call_594890.base,
                         call_594890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594890, url, valid)

proc call*(call_594891: Call_ReplicationProtectionContainersSwitchProtection_594880;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; switchInput: JsonNode): Recallable =
  ## replicationProtectionContainersSwitchProtection
  ## Operation to switch protection from one container to another or one replication provider to another.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   switchInput: JObject (required)
  ##              : Switch protection input.
  var path_594892 = newJObject()
  var query_594893 = newJObject()
  var body_594894 = newJObject()
  add(path_594892, "fabricName", newJString(fabricName))
  add(path_594892, "resourceGroupName", newJString(resourceGroupName))
  add(query_594893, "api-version", newJString(apiVersion))
  add(path_594892, "subscriptionId", newJString(subscriptionId))
  add(path_594892, "resourceName", newJString(resourceName))
  add(path_594892, "protectionContainerName", newJString(protectionContainerName))
  if switchInput != nil:
    body_594894 = switchInput
  result = call_594891.call(path_594892, query_594893, nil, nil, body_594894)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_594880(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_594881,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_594882,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594895 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594897(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594896(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594898 = path.getOrDefault("fabricName")
  valid_594898 = validateParameter(valid_594898, JString, required = true,
                                 default = nil)
  if valid_594898 != nil:
    section.add "fabricName", valid_594898
  var valid_594899 = path.getOrDefault("resourceGroupName")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "resourceGroupName", valid_594899
  var valid_594900 = path.getOrDefault("subscriptionId")
  valid_594900 = validateParameter(valid_594900, JString, required = true,
                                 default = nil)
  if valid_594900 != nil:
    section.add "subscriptionId", valid_594900
  var valid_594901 = path.getOrDefault("resourceName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "resourceName", valid_594901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594902 = query.getOrDefault("api-version")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "api-version", valid_594902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594903: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_594903.validator(path, query, header, formData, body)
  let scheme = call_594903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594903.url(scheme.get, call_594903.host, call_594903.base,
                         call_594903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594903, url, valid)

proc call*(call_594904: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594895;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersListByReplicationFabrics
  ## Lists the registered recovery services providers for the specified fabric.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594905 = newJObject()
  var query_594906 = newJObject()
  add(path_594905, "fabricName", newJString(fabricName))
  add(path_594905, "resourceGroupName", newJString(resourceGroupName))
  add(query_594906, "api-version", newJString(apiVersion))
  add(path_594905, "subscriptionId", newJString(subscriptionId))
  add(path_594905, "resourceName", newJString(resourceName))
  result = call_594904.call(path_594905, query_594906, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594895(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594896,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594897,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_594920 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersCreate_594922(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersCreate_594921(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594923 = path.getOrDefault("fabricName")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = nil)
  if valid_594923 != nil:
    section.add "fabricName", valid_594923
  var valid_594924 = path.getOrDefault("resourceGroupName")
  valid_594924 = validateParameter(valid_594924, JString, required = true,
                                 default = nil)
  if valid_594924 != nil:
    section.add "resourceGroupName", valid_594924
  var valid_594925 = path.getOrDefault("subscriptionId")
  valid_594925 = validateParameter(valid_594925, JString, required = true,
                                 default = nil)
  if valid_594925 != nil:
    section.add "subscriptionId", valid_594925
  var valid_594926 = path.getOrDefault("resourceName")
  valid_594926 = validateParameter(valid_594926, JString, required = true,
                                 default = nil)
  if valid_594926 != nil:
    section.add "resourceName", valid_594926
  var valid_594927 = path.getOrDefault("providerName")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "providerName", valid_594927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594928 = query.getOrDefault("api-version")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "api-version", valid_594928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   addProviderInput: JObject (required)
  ##                   : Add provider input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594930: Call_ReplicationRecoveryServicesProvidersCreate_594920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_594930.validator(path, query, header, formData, body)
  let scheme = call_594930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594930.url(scheme.get, call_594930.host, call_594930.base,
                         call_594930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594930, url, valid)

proc call*(call_594931: Call_ReplicationRecoveryServicesProvidersCreate_594920;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          addProviderInput: JsonNode; subscriptionId: string; resourceName: string;
          providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersCreate
  ## The operation to add a recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   addProviderInput: JObject (required)
  ##                   : Add provider input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_594932 = newJObject()
  var query_594933 = newJObject()
  var body_594934 = newJObject()
  add(path_594932, "fabricName", newJString(fabricName))
  add(path_594932, "resourceGroupName", newJString(resourceGroupName))
  add(query_594933, "api-version", newJString(apiVersion))
  if addProviderInput != nil:
    body_594934 = addProviderInput
  add(path_594932, "subscriptionId", newJString(subscriptionId))
  add(path_594932, "resourceName", newJString(resourceName))
  add(path_594932, "providerName", newJString(providerName))
  result = call_594931.call(path_594932, query_594933, nil, nil, body_594934)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_594920(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_594921,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_594922,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_594907 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersGet_594909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersGet_594908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of registered recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594910 = path.getOrDefault("fabricName")
  valid_594910 = validateParameter(valid_594910, JString, required = true,
                                 default = nil)
  if valid_594910 != nil:
    section.add "fabricName", valid_594910
  var valid_594911 = path.getOrDefault("resourceGroupName")
  valid_594911 = validateParameter(valid_594911, JString, required = true,
                                 default = nil)
  if valid_594911 != nil:
    section.add "resourceGroupName", valid_594911
  var valid_594912 = path.getOrDefault("subscriptionId")
  valid_594912 = validateParameter(valid_594912, JString, required = true,
                                 default = nil)
  if valid_594912 != nil:
    section.add "subscriptionId", valid_594912
  var valid_594913 = path.getOrDefault("resourceName")
  valid_594913 = validateParameter(valid_594913, JString, required = true,
                                 default = nil)
  if valid_594913 != nil:
    section.add "resourceName", valid_594913
  var valid_594914 = path.getOrDefault("providerName")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "providerName", valid_594914
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594915 = query.getOrDefault("api-version")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "api-version", valid_594915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594916: Call_ReplicationRecoveryServicesProvidersGet_594907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_594916.validator(path, query, header, formData, body)
  let scheme = call_594916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594916.url(scheme.get, call_594916.host, call_594916.base,
                         call_594916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594916, url, valid)

proc call*(call_594917: Call_ReplicationRecoveryServicesProvidersGet_594907;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersGet
  ## Gets the details of registered recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name
  var path_594918 = newJObject()
  var query_594919 = newJObject()
  add(path_594918, "fabricName", newJString(fabricName))
  add(path_594918, "resourceGroupName", newJString(resourceGroupName))
  add(query_594919, "api-version", newJString(apiVersion))
  add(path_594918, "subscriptionId", newJString(subscriptionId))
  add(path_594918, "resourceName", newJString(resourceName))
  add(path_594918, "providerName", newJString(providerName))
  result = call_594917.call(path_594918, query_594919, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_594907(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_594908, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_594909,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_594935 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersPurge_594937(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersPurge_594936(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594938 = path.getOrDefault("fabricName")
  valid_594938 = validateParameter(valid_594938, JString, required = true,
                                 default = nil)
  if valid_594938 != nil:
    section.add "fabricName", valid_594938
  var valid_594939 = path.getOrDefault("resourceGroupName")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "resourceGroupName", valid_594939
  var valid_594940 = path.getOrDefault("subscriptionId")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "subscriptionId", valid_594940
  var valid_594941 = path.getOrDefault("resourceName")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "resourceName", valid_594941
  var valid_594942 = path.getOrDefault("providerName")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "providerName", valid_594942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594943 = query.getOrDefault("api-version")
  valid_594943 = validateParameter(valid_594943, JString, required = true,
                                 default = nil)
  if valid_594943 != nil:
    section.add "api-version", valid_594943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594944: Call_ReplicationRecoveryServicesProvidersPurge_594935;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_594944.validator(path, query, header, formData, body)
  let scheme = call_594944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594944.url(scheme.get, call_594944.host, call_594944.base,
                         call_594944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594944, url, valid)

proc call*(call_594945: Call_ReplicationRecoveryServicesProvidersPurge_594935;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersPurge
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_594946 = newJObject()
  var query_594947 = newJObject()
  add(path_594946, "fabricName", newJString(fabricName))
  add(path_594946, "resourceGroupName", newJString(resourceGroupName))
  add(query_594947, "api-version", newJString(apiVersion))
  add(path_594946, "subscriptionId", newJString(subscriptionId))
  add(path_594946, "resourceName", newJString(resourceName))
  add(path_594946, "providerName", newJString(providerName))
  result = call_594945.call(path_594946, query_594947, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_594935(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_594936,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_594937,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_594948 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_594950(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/refreshProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_594949(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594951 = path.getOrDefault("fabricName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "fabricName", valid_594951
  var valid_594952 = path.getOrDefault("resourceGroupName")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "resourceGroupName", valid_594952
  var valid_594953 = path.getOrDefault("subscriptionId")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "subscriptionId", valid_594953
  var valid_594954 = path.getOrDefault("resourceName")
  valid_594954 = validateParameter(valid_594954, JString, required = true,
                                 default = nil)
  if valid_594954 != nil:
    section.add "resourceName", valid_594954
  var valid_594955 = path.getOrDefault("providerName")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "providerName", valid_594955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594956 = query.getOrDefault("api-version")
  valid_594956 = validateParameter(valid_594956, JString, required = true,
                                 default = nil)
  if valid_594956 != nil:
    section.add "api-version", valid_594956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594957: Call_ReplicationRecoveryServicesProvidersRefreshProvider_594948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_594957.validator(path, query, header, formData, body)
  let scheme = call_594957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594957.url(scheme.get, call_594957.host, call_594957.base,
                         call_594957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594957, url, valid)

proc call*(call_594958: Call_ReplicationRecoveryServicesProvidersRefreshProvider_594948;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersRefreshProvider
  ## The operation to refresh the information from the recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_594959 = newJObject()
  var query_594960 = newJObject()
  add(path_594959, "fabricName", newJString(fabricName))
  add(path_594959, "resourceGroupName", newJString(resourceGroupName))
  add(query_594960, "api-version", newJString(apiVersion))
  add(path_594959, "subscriptionId", newJString(subscriptionId))
  add(path_594959, "resourceName", newJString(resourceName))
  add(path_594959, "providerName", newJString(providerName))
  result = call_594958.call(path_594959, query_594960, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_594948(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_594949,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_594950,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_594961 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersDelete_594963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersDelete_594962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594964 = path.getOrDefault("fabricName")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "fabricName", valid_594964
  var valid_594965 = path.getOrDefault("resourceGroupName")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "resourceGroupName", valid_594965
  var valid_594966 = path.getOrDefault("subscriptionId")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "subscriptionId", valid_594966
  var valid_594967 = path.getOrDefault("resourceName")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "resourceName", valid_594967
  var valid_594968 = path.getOrDefault("providerName")
  valid_594968 = validateParameter(valid_594968, JString, required = true,
                                 default = nil)
  if valid_594968 != nil:
    section.add "providerName", valid_594968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594969 = query.getOrDefault("api-version")
  valid_594969 = validateParameter(valid_594969, JString, required = true,
                                 default = nil)
  if valid_594969 != nil:
    section.add "api-version", valid_594969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594970: Call_ReplicationRecoveryServicesProvidersDelete_594961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_594970.validator(path, query, header, formData, body)
  let scheme = call_594970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594970.url(scheme.get, call_594970.host, call_594970.base,
                         call_594970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594970, url, valid)

proc call*(call_594971: Call_ReplicationRecoveryServicesProvidersDelete_594961;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersDelete
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_594972 = newJObject()
  var query_594973 = newJObject()
  add(path_594972, "fabricName", newJString(fabricName))
  add(path_594972, "resourceGroupName", newJString(resourceGroupName))
  add(query_594973, "api-version", newJString(apiVersion))
  add(path_594972, "subscriptionId", newJString(subscriptionId))
  add(path_594972, "resourceName", newJString(resourceName))
  add(path_594972, "providerName", newJString(providerName))
  result = call_594971.call(path_594972, query_594973, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_594961(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_594962,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_594963,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_594974 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsListByReplicationFabrics_594976(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_594975(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Site name of interest.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594977 = path.getOrDefault("fabricName")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "fabricName", valid_594977
  var valid_594978 = path.getOrDefault("resourceGroupName")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "resourceGroupName", valid_594978
  var valid_594979 = path.getOrDefault("subscriptionId")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "subscriptionId", valid_594979
  var valid_594980 = path.getOrDefault("resourceName")
  valid_594980 = validateParameter(valid_594980, JString, required = true,
                                 default = nil)
  if valid_594980 != nil:
    section.add "resourceName", valid_594980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594981 = query.getOrDefault("api-version")
  valid_594981 = validateParameter(valid_594981, JString, required = true,
                                 default = nil)
  if valid_594981 != nil:
    section.add "api-version", valid_594981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594982: Call_ReplicationStorageClassificationsListByReplicationFabrics_594974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_594982.validator(path, query, header, formData, body)
  let scheme = call_594982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594982.url(scheme.get, call_594982.host, call_594982.base,
                         call_594982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594982, url, valid)

proc call*(call_594983: Call_ReplicationStorageClassificationsListByReplicationFabrics_594974;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationStorageClassificationsListByReplicationFabrics
  ## Lists the storage classifications available in the specified fabric.
  ##   fabricName: string (required)
  ##             : Site name of interest.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_594984 = newJObject()
  var query_594985 = newJObject()
  add(path_594984, "fabricName", newJString(fabricName))
  add(path_594984, "resourceGroupName", newJString(resourceGroupName))
  add(query_594985, "api-version", newJString(apiVersion))
  add(path_594984, "subscriptionId", newJString(subscriptionId))
  add(path_594984, "resourceName", newJString(resourceName))
  result = call_594983.call(path_594984, query_594985, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_594974(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_594975,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_594976,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_594986 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsGet_594988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsGet_594987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_594989 = path.getOrDefault("fabricName")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "fabricName", valid_594989
  var valid_594990 = path.getOrDefault("resourceGroupName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "resourceGroupName", valid_594990
  var valid_594991 = path.getOrDefault("subscriptionId")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "subscriptionId", valid_594991
  var valid_594992 = path.getOrDefault("resourceName")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "resourceName", valid_594992
  var valid_594993 = path.getOrDefault("storageClassificationName")
  valid_594993 = validateParameter(valid_594993, JString, required = true,
                                 default = nil)
  if valid_594993 != nil:
    section.add "storageClassificationName", valid_594993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594994 = query.getOrDefault("api-version")
  valid_594994 = validateParameter(valid_594994, JString, required = true,
                                 default = nil)
  if valid_594994 != nil:
    section.add "api-version", valid_594994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594995: Call_ReplicationStorageClassificationsGet_594986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_594995.validator(path, query, header, formData, body)
  let scheme = call_594995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594995.url(scheme.get, call_594995.host, call_594995.base,
                         call_594995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594995, url, valid)

proc call*(call_594996: Call_ReplicationStorageClassificationsGet_594986;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationsGet
  ## Gets the details of the specified storage classification.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_594997 = newJObject()
  var query_594998 = newJObject()
  add(path_594997, "fabricName", newJString(fabricName))
  add(path_594997, "resourceGroupName", newJString(resourceGroupName))
  add(query_594998, "api-version", newJString(apiVersion))
  add(path_594997, "subscriptionId", newJString(subscriptionId))
  add(path_594997, "resourceName", newJString(resourceName))
  add(path_594997, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_594996.call(path_594997, query_594998, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_594986(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_594987, base: "",
    url: url_ReplicationStorageClassificationsGet_594988, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_594999 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595001(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595000(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classification mappings for the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595002 = path.getOrDefault("fabricName")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "fabricName", valid_595002
  var valid_595003 = path.getOrDefault("resourceGroupName")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "resourceGroupName", valid_595003
  var valid_595004 = path.getOrDefault("subscriptionId")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "subscriptionId", valid_595004
  var valid_595005 = path.getOrDefault("resourceName")
  valid_595005 = validateParameter(valid_595005, JString, required = true,
                                 default = nil)
  if valid_595005 != nil:
    section.add "resourceName", valid_595005
  var valid_595006 = path.getOrDefault("storageClassificationName")
  valid_595006 = validateParameter(valid_595006, JString, required = true,
                                 default = nil)
  if valid_595006 != nil:
    section.add "storageClassificationName", valid_595006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595007 = query.getOrDefault("api-version")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "api-version", valid_595007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595008: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_594999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_595008.validator(path, query, header, formData, body)
  let scheme = call_595008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595008.url(scheme.get, call_595008.host, call_595008.base,
                         call_595008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595008, url, valid)

proc call*(call_595009: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_594999;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsListByReplicationStorageClassifications
  ## Lists the storage classification mappings for the fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_595010 = newJObject()
  var query_595011 = newJObject()
  add(path_595010, "fabricName", newJString(fabricName))
  add(path_595010, "resourceGroupName", newJString(resourceGroupName))
  add(query_595011, "api-version", newJString(apiVersion))
  add(path_595010, "subscriptionId", newJString(subscriptionId))
  add(path_595010, "resourceName", newJString(resourceName))
  add(path_595010, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595009.call(path_595010, query_595011, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_594999(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595000,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595001,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_595026 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsCreate_595028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsCreate_595027(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595029 = path.getOrDefault("fabricName")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "fabricName", valid_595029
  var valid_595030 = path.getOrDefault("resourceGroupName")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "resourceGroupName", valid_595030
  var valid_595031 = path.getOrDefault("storageClassificationMappingName")
  valid_595031 = validateParameter(valid_595031, JString, required = true,
                                 default = nil)
  if valid_595031 != nil:
    section.add "storageClassificationMappingName", valid_595031
  var valid_595032 = path.getOrDefault("subscriptionId")
  valid_595032 = validateParameter(valid_595032, JString, required = true,
                                 default = nil)
  if valid_595032 != nil:
    section.add "subscriptionId", valid_595032
  var valid_595033 = path.getOrDefault("resourceName")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "resourceName", valid_595033
  var valid_595034 = path.getOrDefault("storageClassificationName")
  valid_595034 = validateParameter(valid_595034, JString, required = true,
                                 default = nil)
  if valid_595034 != nil:
    section.add "storageClassificationName", valid_595034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595035 = query.getOrDefault("api-version")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = nil)
  if valid_595035 != nil:
    section.add "api-version", valid_595035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pairingInput: JObject (required)
  ##               : Pairing input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595037: Call_ReplicationStorageClassificationMappingsCreate_595026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_595037.validator(path, query, header, formData, body)
  let scheme = call_595037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595037.url(scheme.get, call_595037.host, call_595037.base,
                         call_595037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595037, url, valid)

proc call*(call_595038: Call_ReplicationStorageClassificationMappingsCreate_595026;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; pairingInput: JsonNode;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsCreate
  ## The operation to create a storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   pairingInput: JObject (required)
  ##               : Pairing input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_595039 = newJObject()
  var query_595040 = newJObject()
  var body_595041 = newJObject()
  add(path_595039, "fabricName", newJString(fabricName))
  add(path_595039, "resourceGroupName", newJString(resourceGroupName))
  add(query_595040, "api-version", newJString(apiVersion))
  add(path_595039, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  if pairingInput != nil:
    body_595041 = pairingInput
  add(path_595039, "subscriptionId", newJString(subscriptionId))
  add(path_595039, "resourceName", newJString(resourceName))
  add(path_595039, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595038.call(path_595039, query_595040, nil, nil, body_595041)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_595026(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_595027,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_595028,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_595012 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsGet_595014(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsGet_595013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595015 = path.getOrDefault("fabricName")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "fabricName", valid_595015
  var valid_595016 = path.getOrDefault("resourceGroupName")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "resourceGroupName", valid_595016
  var valid_595017 = path.getOrDefault("storageClassificationMappingName")
  valid_595017 = validateParameter(valid_595017, JString, required = true,
                                 default = nil)
  if valid_595017 != nil:
    section.add "storageClassificationMappingName", valid_595017
  var valid_595018 = path.getOrDefault("subscriptionId")
  valid_595018 = validateParameter(valid_595018, JString, required = true,
                                 default = nil)
  if valid_595018 != nil:
    section.add "subscriptionId", valid_595018
  var valid_595019 = path.getOrDefault("resourceName")
  valid_595019 = validateParameter(valid_595019, JString, required = true,
                                 default = nil)
  if valid_595019 != nil:
    section.add "resourceName", valid_595019
  var valid_595020 = path.getOrDefault("storageClassificationName")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "storageClassificationName", valid_595020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595021 = query.getOrDefault("api-version")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "api-version", valid_595021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595022: Call_ReplicationStorageClassificationMappingsGet_595012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_595022.validator(path, query, header, formData, body)
  let scheme = call_595022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595022.url(scheme.get, call_595022.host, call_595022.base,
                         call_595022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595022, url, valid)

proc call*(call_595023: Call_ReplicationStorageClassificationMappingsGet_595012;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; subscriptionId: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsGet
  ## Gets the details of the specified storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_595024 = newJObject()
  var query_595025 = newJObject()
  add(path_595024, "fabricName", newJString(fabricName))
  add(path_595024, "resourceGroupName", newJString(resourceGroupName))
  add(query_595025, "api-version", newJString(apiVersion))
  add(path_595024, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_595024, "subscriptionId", newJString(subscriptionId))
  add(path_595024, "resourceName", newJString(resourceName))
  add(path_595024, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595023.call(path_595024, query_595025, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_595012(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_595013,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_595014,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_595042 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsDelete_595044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsDelete_595043(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to delete a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595045 = path.getOrDefault("fabricName")
  valid_595045 = validateParameter(valid_595045, JString, required = true,
                                 default = nil)
  if valid_595045 != nil:
    section.add "fabricName", valid_595045
  var valid_595046 = path.getOrDefault("resourceGroupName")
  valid_595046 = validateParameter(valid_595046, JString, required = true,
                                 default = nil)
  if valid_595046 != nil:
    section.add "resourceGroupName", valid_595046
  var valid_595047 = path.getOrDefault("storageClassificationMappingName")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = nil)
  if valid_595047 != nil:
    section.add "storageClassificationMappingName", valid_595047
  var valid_595048 = path.getOrDefault("subscriptionId")
  valid_595048 = validateParameter(valid_595048, JString, required = true,
                                 default = nil)
  if valid_595048 != nil:
    section.add "subscriptionId", valid_595048
  var valid_595049 = path.getOrDefault("resourceName")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = nil)
  if valid_595049 != nil:
    section.add "resourceName", valid_595049
  var valid_595050 = path.getOrDefault("storageClassificationName")
  valid_595050 = validateParameter(valid_595050, JString, required = true,
                                 default = nil)
  if valid_595050 != nil:
    section.add "storageClassificationName", valid_595050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595051 = query.getOrDefault("api-version")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "api-version", valid_595051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595052: Call_ReplicationStorageClassificationMappingsDelete_595042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_595052.validator(path, query, header, formData, body)
  let scheme = call_595052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595052.url(scheme.get, call_595052.host, call_595052.base,
                         call_595052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595052, url, valid)

proc call*(call_595053: Call_ReplicationStorageClassificationMappingsDelete_595042;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; subscriptionId: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsDelete
  ## The operation to delete a storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_595054 = newJObject()
  var query_595055 = newJObject()
  add(path_595054, "fabricName", newJString(fabricName))
  add(path_595054, "resourceGroupName", newJString(resourceGroupName))
  add(query_595055, "api-version", newJString(apiVersion))
  add(path_595054, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_595054, "subscriptionId", newJString(subscriptionId))
  add(path_595054, "resourceName", newJString(resourceName))
  add(path_595054, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595053.call(path_595054, query_595055, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_595042(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_595043,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_595044,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_595056 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersListByReplicationFabrics_595058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersListByReplicationFabrics_595057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595059 = path.getOrDefault("fabricName")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = nil)
  if valid_595059 != nil:
    section.add "fabricName", valid_595059
  var valid_595060 = path.getOrDefault("resourceGroupName")
  valid_595060 = validateParameter(valid_595060, JString, required = true,
                                 default = nil)
  if valid_595060 != nil:
    section.add "resourceGroupName", valid_595060
  var valid_595061 = path.getOrDefault("subscriptionId")
  valid_595061 = validateParameter(valid_595061, JString, required = true,
                                 default = nil)
  if valid_595061 != nil:
    section.add "subscriptionId", valid_595061
  var valid_595062 = path.getOrDefault("resourceName")
  valid_595062 = validateParameter(valid_595062, JString, required = true,
                                 default = nil)
  if valid_595062 != nil:
    section.add "resourceName", valid_595062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595063 = query.getOrDefault("api-version")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "api-version", valid_595063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595064: Call_ReplicationvCentersListByReplicationFabrics_595056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_595064.validator(path, query, header, formData, body)
  let scheme = call_595064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595064.url(scheme.get, call_595064.host, call_595064.base,
                         call_595064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595064, url, valid)

proc call*(call_595065: Call_ReplicationvCentersListByReplicationFabrics_595056;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationvCentersListByReplicationFabrics
  ## Lists the vCenter servers registered in a fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595066 = newJObject()
  var query_595067 = newJObject()
  add(path_595066, "fabricName", newJString(fabricName))
  add(path_595066, "resourceGroupName", newJString(resourceGroupName))
  add(query_595067, "api-version", newJString(apiVersion))
  add(path_595066, "subscriptionId", newJString(subscriptionId))
  add(path_595066, "resourceName", newJString(resourceName))
  result = call_595065.call(path_595066, query_595067, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_595056(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_595057,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_595058,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_595081 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersCreate_595083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersCreate_595082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a vCenter object..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595084 = path.getOrDefault("fabricName")
  valid_595084 = validateParameter(valid_595084, JString, required = true,
                                 default = nil)
  if valid_595084 != nil:
    section.add "fabricName", valid_595084
  var valid_595085 = path.getOrDefault("resourceGroupName")
  valid_595085 = validateParameter(valid_595085, JString, required = true,
                                 default = nil)
  if valid_595085 != nil:
    section.add "resourceGroupName", valid_595085
  var valid_595086 = path.getOrDefault("subscriptionId")
  valid_595086 = validateParameter(valid_595086, JString, required = true,
                                 default = nil)
  if valid_595086 != nil:
    section.add "subscriptionId", valid_595086
  var valid_595087 = path.getOrDefault("resourceName")
  valid_595087 = validateParameter(valid_595087, JString, required = true,
                                 default = nil)
  if valid_595087 != nil:
    section.add "resourceName", valid_595087
  var valid_595088 = path.getOrDefault("vCenterName")
  valid_595088 = validateParameter(valid_595088, JString, required = true,
                                 default = nil)
  if valid_595088 != nil:
    section.add "vCenterName", valid_595088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595089 = query.getOrDefault("api-version")
  valid_595089 = validateParameter(valid_595089, JString, required = true,
                                 default = nil)
  if valid_595089 != nil:
    section.add "api-version", valid_595089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   addVCenterRequest: JObject (required)
  ##                    : The input to the add vCenter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595091: Call_ReplicationvCentersCreate_595081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_595091.validator(path, query, header, formData, body)
  let scheme = call_595091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595091.url(scheme.get, call_595091.host, call_595091.base,
                         call_595091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595091, url, valid)

proc call*(call_595092: Call_ReplicationvCentersCreate_595081; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; addVCenterRequest: JsonNode; vCenterName: string): Recallable =
  ## replicationvCentersCreate
  ## The operation to create a vCenter object..
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   addVCenterRequest: JObject (required)
  ##                    : The input to the add vCenter operation.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_595093 = newJObject()
  var query_595094 = newJObject()
  var body_595095 = newJObject()
  add(path_595093, "fabricName", newJString(fabricName))
  add(path_595093, "resourceGroupName", newJString(resourceGroupName))
  add(query_595094, "api-version", newJString(apiVersion))
  add(path_595093, "subscriptionId", newJString(subscriptionId))
  add(path_595093, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_595095 = addVCenterRequest
  add(path_595093, "vCenterName", newJString(vCenterName))
  result = call_595092.call(path_595093, query_595094, nil, nil, body_595095)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_595081(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_595082, base: "",
    url: url_ReplicationvCentersCreate_595083, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_595068 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersGet_595070(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersGet_595069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595071 = path.getOrDefault("fabricName")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "fabricName", valid_595071
  var valid_595072 = path.getOrDefault("resourceGroupName")
  valid_595072 = validateParameter(valid_595072, JString, required = true,
                                 default = nil)
  if valid_595072 != nil:
    section.add "resourceGroupName", valid_595072
  var valid_595073 = path.getOrDefault("subscriptionId")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "subscriptionId", valid_595073
  var valid_595074 = path.getOrDefault("resourceName")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "resourceName", valid_595074
  var valid_595075 = path.getOrDefault("vCenterName")
  valid_595075 = validateParameter(valid_595075, JString, required = true,
                                 default = nil)
  if valid_595075 != nil:
    section.add "vCenterName", valid_595075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595076 = query.getOrDefault("api-version")
  valid_595076 = validateParameter(valid_595076, JString, required = true,
                                 default = nil)
  if valid_595076 != nil:
    section.add "api-version", valid_595076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595077: Call_ReplicationvCentersGet_595068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_595077.validator(path, query, header, formData, body)
  let scheme = call_595077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595077.url(scheme.get, call_595077.host, call_595077.base,
                         call_595077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595077, url, valid)

proc call*(call_595078: Call_ReplicationvCentersGet_595068; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string): Recallable =
  ## replicationvCentersGet
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_595079 = newJObject()
  var query_595080 = newJObject()
  add(path_595079, "fabricName", newJString(fabricName))
  add(path_595079, "resourceGroupName", newJString(resourceGroupName))
  add(query_595080, "api-version", newJString(apiVersion))
  add(path_595079, "subscriptionId", newJString(subscriptionId))
  add(path_595079, "resourceName", newJString(resourceName))
  add(path_595079, "vCenterName", newJString(vCenterName))
  result = call_595078.call(path_595079, query_595080, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_595068(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_595069, base: "",
    url: url_ReplicationvCentersGet_595070, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_595109 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersUpdate_595111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersUpdate_595110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a registered vCenter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595112 = path.getOrDefault("fabricName")
  valid_595112 = validateParameter(valid_595112, JString, required = true,
                                 default = nil)
  if valid_595112 != nil:
    section.add "fabricName", valid_595112
  var valid_595113 = path.getOrDefault("resourceGroupName")
  valid_595113 = validateParameter(valid_595113, JString, required = true,
                                 default = nil)
  if valid_595113 != nil:
    section.add "resourceGroupName", valid_595113
  var valid_595114 = path.getOrDefault("subscriptionId")
  valid_595114 = validateParameter(valid_595114, JString, required = true,
                                 default = nil)
  if valid_595114 != nil:
    section.add "subscriptionId", valid_595114
  var valid_595115 = path.getOrDefault("resourceName")
  valid_595115 = validateParameter(valid_595115, JString, required = true,
                                 default = nil)
  if valid_595115 != nil:
    section.add "resourceName", valid_595115
  var valid_595116 = path.getOrDefault("vCenterName")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "vCenterName", valid_595116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595117 = query.getOrDefault("api-version")
  valid_595117 = validateParameter(valid_595117, JString, required = true,
                                 default = nil)
  if valid_595117 != nil:
    section.add "api-version", valid_595117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateVCenterRequest: JObject (required)
  ##                       : The input to the update vCenter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595119: Call_ReplicationvCentersUpdate_595109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_595119.validator(path, query, header, formData, body)
  let scheme = call_595119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595119.url(scheme.get, call_595119.host, call_595119.base,
                         call_595119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595119, url, valid)

proc call*(call_595120: Call_ReplicationvCentersUpdate_595109; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string; updateVCenterRequest: JsonNode): Recallable =
  ## replicationvCentersUpdate
  ## The operation to update a registered vCenter.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name
  ##   updateVCenterRequest: JObject (required)
  ##                       : The input to the update vCenter operation.
  var path_595121 = newJObject()
  var query_595122 = newJObject()
  var body_595123 = newJObject()
  add(path_595121, "fabricName", newJString(fabricName))
  add(path_595121, "resourceGroupName", newJString(resourceGroupName))
  add(query_595122, "api-version", newJString(apiVersion))
  add(path_595121, "subscriptionId", newJString(subscriptionId))
  add(path_595121, "resourceName", newJString(resourceName))
  add(path_595121, "vCenterName", newJString(vCenterName))
  if updateVCenterRequest != nil:
    body_595123 = updateVCenterRequest
  result = call_595120.call(path_595121, query_595122, nil, nil, body_595123)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_595109(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_595110, base: "",
    url: url_ReplicationvCentersUpdate_595111, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_595096 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersDelete_595098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersDelete_595097(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_595099 = path.getOrDefault("fabricName")
  valid_595099 = validateParameter(valid_595099, JString, required = true,
                                 default = nil)
  if valid_595099 != nil:
    section.add "fabricName", valid_595099
  var valid_595100 = path.getOrDefault("resourceGroupName")
  valid_595100 = validateParameter(valid_595100, JString, required = true,
                                 default = nil)
  if valid_595100 != nil:
    section.add "resourceGroupName", valid_595100
  var valid_595101 = path.getOrDefault("subscriptionId")
  valid_595101 = validateParameter(valid_595101, JString, required = true,
                                 default = nil)
  if valid_595101 != nil:
    section.add "subscriptionId", valid_595101
  var valid_595102 = path.getOrDefault("resourceName")
  valid_595102 = validateParameter(valid_595102, JString, required = true,
                                 default = nil)
  if valid_595102 != nil:
    section.add "resourceName", valid_595102
  var valid_595103 = path.getOrDefault("vCenterName")
  valid_595103 = validateParameter(valid_595103, JString, required = true,
                                 default = nil)
  if valid_595103 != nil:
    section.add "vCenterName", valid_595103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595104 = query.getOrDefault("api-version")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "api-version", valid_595104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595105: Call_ReplicationvCentersDelete_595096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_595105.validator(path, query, header, formData, body)
  let scheme = call_595105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595105.url(scheme.get, call_595105.host, call_595105.base,
                         call_595105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595105, url, valid)

proc call*(call_595106: Call_ReplicationvCentersDelete_595096; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string): Recallable =
  ## replicationvCentersDelete
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_595107 = newJObject()
  var query_595108 = newJObject()
  add(path_595107, "fabricName", newJString(fabricName))
  add(path_595107, "resourceGroupName", newJString(resourceGroupName))
  add(query_595108, "api-version", newJString(apiVersion))
  add(path_595107, "subscriptionId", newJString(subscriptionId))
  add(path_595107, "resourceName", newJString(resourceName))
  add(path_595107, "vCenterName", newJString(vCenterName))
  result = call_595106.call(path_595107, query_595108, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_595096(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_595097, base: "",
    url: url_ReplicationvCentersDelete_595098, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_595124 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsList_595126(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsList_595125(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595127 = path.getOrDefault("resourceGroupName")
  valid_595127 = validateParameter(valid_595127, JString, required = true,
                                 default = nil)
  if valid_595127 != nil:
    section.add "resourceGroupName", valid_595127
  var valid_595128 = path.getOrDefault("subscriptionId")
  valid_595128 = validateParameter(valid_595128, JString, required = true,
                                 default = nil)
  if valid_595128 != nil:
    section.add "subscriptionId", valid_595128
  var valid_595129 = path.getOrDefault("resourceName")
  valid_595129 = validateParameter(valid_595129, JString, required = true,
                                 default = nil)
  if valid_595129 != nil:
    section.add "resourceName", valid_595129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595130 = query.getOrDefault("api-version")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "api-version", valid_595130
  var valid_595131 = query.getOrDefault("$filter")
  valid_595131 = validateParameter(valid_595131, JString, required = false,
                                 default = nil)
  if valid_595131 != nil:
    section.add "$filter", valid_595131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595132: Call_ReplicationJobsList_595124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_595132.validator(path, query, header, formData, body)
  let scheme = call_595132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595132.url(scheme.get, call_595132.host, call_595132.base,
                         call_595132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595132, url, valid)

proc call*(call_595133: Call_ReplicationJobsList_595124; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          Filter: string = ""): Recallable =
  ## replicationJobsList
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_595134 = newJObject()
  var query_595135 = newJObject()
  add(path_595134, "resourceGroupName", newJString(resourceGroupName))
  add(query_595135, "api-version", newJString(apiVersion))
  add(path_595134, "subscriptionId", newJString(subscriptionId))
  add(path_595134, "resourceName", newJString(resourceName))
  add(query_595135, "$filter", newJString(Filter))
  result = call_595133.call(path_595134, query_595135, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_595124(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_595125, base: "",
    url: url_ReplicationJobsList_595126, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_595136 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsExport_595138(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsExport_595137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595139 = path.getOrDefault("resourceGroupName")
  valid_595139 = validateParameter(valid_595139, JString, required = true,
                                 default = nil)
  if valid_595139 != nil:
    section.add "resourceGroupName", valid_595139
  var valid_595140 = path.getOrDefault("subscriptionId")
  valid_595140 = validateParameter(valid_595140, JString, required = true,
                                 default = nil)
  if valid_595140 != nil:
    section.add "subscriptionId", valid_595140
  var valid_595141 = path.getOrDefault("resourceName")
  valid_595141 = validateParameter(valid_595141, JString, required = true,
                                 default = nil)
  if valid_595141 != nil:
    section.add "resourceName", valid_595141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595142 = query.getOrDefault("api-version")
  valid_595142 = validateParameter(valid_595142, JString, required = true,
                                 default = nil)
  if valid_595142 != nil:
    section.add "api-version", valid_595142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595144: Call_ReplicationJobsExport_595136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_595144.validator(path, query, header, formData, body)
  let scheme = call_595144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595144.url(scheme.get, call_595144.host, call_595144.base,
                         call_595144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595144, url, valid)

proc call*(call_595145: Call_ReplicationJobsExport_595136;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; jobQueryParameter: JsonNode): Recallable =
  ## replicationJobsExport
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  var path_595146 = newJObject()
  var query_595147 = newJObject()
  var body_595148 = newJObject()
  add(path_595146, "resourceGroupName", newJString(resourceGroupName))
  add(query_595147, "api-version", newJString(apiVersion))
  add(path_595146, "subscriptionId", newJString(subscriptionId))
  add(path_595146, "resourceName", newJString(resourceName))
  if jobQueryParameter != nil:
    body_595148 = jobQueryParameter
  result = call_595145.call(path_595146, query_595147, nil, nil, body_595148)

var replicationJobsExport* = Call_ReplicationJobsExport_595136(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_595137, base: "",
    url: url_ReplicationJobsExport_595138, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_595149 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsGet_595151(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsGet_595150(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the details of an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595152 = path.getOrDefault("resourceGroupName")
  valid_595152 = validateParameter(valid_595152, JString, required = true,
                                 default = nil)
  if valid_595152 != nil:
    section.add "resourceGroupName", valid_595152
  var valid_595153 = path.getOrDefault("subscriptionId")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "subscriptionId", valid_595153
  var valid_595154 = path.getOrDefault("jobName")
  valid_595154 = validateParameter(valid_595154, JString, required = true,
                                 default = nil)
  if valid_595154 != nil:
    section.add "jobName", valid_595154
  var valid_595155 = path.getOrDefault("resourceName")
  valid_595155 = validateParameter(valid_595155, JString, required = true,
                                 default = nil)
  if valid_595155 != nil:
    section.add "resourceName", valid_595155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595156 = query.getOrDefault("api-version")
  valid_595156 = validateParameter(valid_595156, JString, required = true,
                                 default = nil)
  if valid_595156 != nil:
    section.add "api-version", valid_595156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595157: Call_ReplicationJobsGet_595149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_595157.validator(path, query, header, formData, body)
  let scheme = call_595157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595157.url(scheme.get, call_595157.host, call_595157.base,
                         call_595157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595157, url, valid)

proc call*(call_595158: Call_ReplicationJobsGet_595149; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          resourceName: string): Recallable =
  ## replicationJobsGet
  ## Get the details of an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595159 = newJObject()
  var query_595160 = newJObject()
  add(path_595159, "resourceGroupName", newJString(resourceGroupName))
  add(query_595160, "api-version", newJString(apiVersion))
  add(path_595159, "subscriptionId", newJString(subscriptionId))
  add(path_595159, "jobName", newJString(jobName))
  add(path_595159, "resourceName", newJString(resourceName))
  result = call_595158.call(path_595159, query_595160, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_595149(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_595150, base: "",
    url: url_ReplicationJobsGet_595151, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_595161 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsCancel_595163(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsCancel_595162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595164 = path.getOrDefault("resourceGroupName")
  valid_595164 = validateParameter(valid_595164, JString, required = true,
                                 default = nil)
  if valid_595164 != nil:
    section.add "resourceGroupName", valid_595164
  var valid_595165 = path.getOrDefault("subscriptionId")
  valid_595165 = validateParameter(valid_595165, JString, required = true,
                                 default = nil)
  if valid_595165 != nil:
    section.add "subscriptionId", valid_595165
  var valid_595166 = path.getOrDefault("jobName")
  valid_595166 = validateParameter(valid_595166, JString, required = true,
                                 default = nil)
  if valid_595166 != nil:
    section.add "jobName", valid_595166
  var valid_595167 = path.getOrDefault("resourceName")
  valid_595167 = validateParameter(valid_595167, JString, required = true,
                                 default = nil)
  if valid_595167 != nil:
    section.add "resourceName", valid_595167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595168 = query.getOrDefault("api-version")
  valid_595168 = validateParameter(valid_595168, JString, required = true,
                                 default = nil)
  if valid_595168 != nil:
    section.add "api-version", valid_595168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595169: Call_ReplicationJobsCancel_595161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_595169.validator(path, query, header, formData, body)
  let scheme = call_595169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595169.url(scheme.get, call_595169.host, call_595169.base,
                         call_595169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595169, url, valid)

proc call*(call_595170: Call_ReplicationJobsCancel_595161;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; resourceName: string): Recallable =
  ## replicationJobsCancel
  ## The operation to cancel an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595171 = newJObject()
  var query_595172 = newJObject()
  add(path_595171, "resourceGroupName", newJString(resourceGroupName))
  add(query_595172, "api-version", newJString(apiVersion))
  add(path_595171, "subscriptionId", newJString(subscriptionId))
  add(path_595171, "jobName", newJString(jobName))
  add(path_595171, "resourceName", newJString(resourceName))
  result = call_595170.call(path_595171, query_595172, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_595161(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_595162, base: "",
    url: url_ReplicationJobsCancel_595163, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_595173 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsRestart_595175(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsRestart_595174(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595176 = path.getOrDefault("resourceGroupName")
  valid_595176 = validateParameter(valid_595176, JString, required = true,
                                 default = nil)
  if valid_595176 != nil:
    section.add "resourceGroupName", valid_595176
  var valid_595177 = path.getOrDefault("subscriptionId")
  valid_595177 = validateParameter(valid_595177, JString, required = true,
                                 default = nil)
  if valid_595177 != nil:
    section.add "subscriptionId", valid_595177
  var valid_595178 = path.getOrDefault("jobName")
  valid_595178 = validateParameter(valid_595178, JString, required = true,
                                 default = nil)
  if valid_595178 != nil:
    section.add "jobName", valid_595178
  var valid_595179 = path.getOrDefault("resourceName")
  valid_595179 = validateParameter(valid_595179, JString, required = true,
                                 default = nil)
  if valid_595179 != nil:
    section.add "resourceName", valid_595179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595180 = query.getOrDefault("api-version")
  valid_595180 = validateParameter(valid_595180, JString, required = true,
                                 default = nil)
  if valid_595180 != nil:
    section.add "api-version", valid_595180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595181: Call_ReplicationJobsRestart_595173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_595181.validator(path, query, header, formData, body)
  let scheme = call_595181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595181.url(scheme.get, call_595181.host, call_595181.base,
                         call_595181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595181, url, valid)

proc call*(call_595182: Call_ReplicationJobsRestart_595173;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; resourceName: string): Recallable =
  ## replicationJobsRestart
  ## The operation to restart an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595183 = newJObject()
  var query_595184 = newJObject()
  add(path_595183, "resourceGroupName", newJString(resourceGroupName))
  add(query_595184, "api-version", newJString(apiVersion))
  add(path_595183, "subscriptionId", newJString(subscriptionId))
  add(path_595183, "jobName", newJString(jobName))
  add(path_595183, "resourceName", newJString(resourceName))
  result = call_595182.call(path_595183, query_595184, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_595173(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_595174, base: "",
    url: url_ReplicationJobsRestart_595175, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_595185 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsResume_595187(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsResume_595186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to resume an Azure Site Recovery job
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595188 = path.getOrDefault("resourceGroupName")
  valid_595188 = validateParameter(valid_595188, JString, required = true,
                                 default = nil)
  if valid_595188 != nil:
    section.add "resourceGroupName", valid_595188
  var valid_595189 = path.getOrDefault("subscriptionId")
  valid_595189 = validateParameter(valid_595189, JString, required = true,
                                 default = nil)
  if valid_595189 != nil:
    section.add "subscriptionId", valid_595189
  var valid_595190 = path.getOrDefault("jobName")
  valid_595190 = validateParameter(valid_595190, JString, required = true,
                                 default = nil)
  if valid_595190 != nil:
    section.add "jobName", valid_595190
  var valid_595191 = path.getOrDefault("resourceName")
  valid_595191 = validateParameter(valid_595191, JString, required = true,
                                 default = nil)
  if valid_595191 != nil:
    section.add "resourceName", valid_595191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595192 = query.getOrDefault("api-version")
  valid_595192 = validateParameter(valid_595192, JString, required = true,
                                 default = nil)
  if valid_595192 != nil:
    section.add "api-version", valid_595192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595194: Call_ReplicationJobsResume_595185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_595194.validator(path, query, header, formData, body)
  let scheme = call_595194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595194.url(scheme.get, call_595194.host, call_595194.base,
                         call_595194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595194, url, valid)

proc call*(call_595195: Call_ReplicationJobsResume_595185;
          resourceGroupName: string; apiVersion: string; resumeJobParams: JsonNode;
          subscriptionId: string; jobName: string; resourceName: string): Recallable =
  ## replicationJobsResume
  ## The operation to resume an Azure Site Recovery job
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595196 = newJObject()
  var query_595197 = newJObject()
  var body_595198 = newJObject()
  add(path_595196, "resourceGroupName", newJString(resourceGroupName))
  add(query_595197, "api-version", newJString(apiVersion))
  if resumeJobParams != nil:
    body_595198 = resumeJobParams
  add(path_595196, "subscriptionId", newJString(subscriptionId))
  add(path_595196, "jobName", newJString(jobName))
  add(path_595196, "resourceName", newJString(resourceName))
  result = call_595195.call(path_595196, query_595197, nil, nil, body_595198)

var replicationJobsResume* = Call_ReplicationJobsResume_595185(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_595186, base: "",
    url: url_ReplicationJobsResume_595187, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_595199 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsList_595201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationMigrationItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsList_595200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595202 = path.getOrDefault("resourceGroupName")
  valid_595202 = validateParameter(valid_595202, JString, required = true,
                                 default = nil)
  if valid_595202 != nil:
    section.add "resourceGroupName", valid_595202
  var valid_595203 = path.getOrDefault("subscriptionId")
  valid_595203 = validateParameter(valid_595203, JString, required = true,
                                 default = nil)
  if valid_595203 != nil:
    section.add "subscriptionId", valid_595203
  var valid_595204 = path.getOrDefault("resourceName")
  valid_595204 = validateParameter(valid_595204, JString, required = true,
                                 default = nil)
  if valid_595204 != nil:
    section.add "resourceName", valid_595204
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_595205 = query.getOrDefault("skipToken")
  valid_595205 = validateParameter(valid_595205, JString, required = false,
                                 default = nil)
  if valid_595205 != nil:
    section.add "skipToken", valid_595205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595206 = query.getOrDefault("api-version")
  valid_595206 = validateParameter(valid_595206, JString, required = true,
                                 default = nil)
  if valid_595206 != nil:
    section.add "api-version", valid_595206
  var valid_595207 = query.getOrDefault("$filter")
  valid_595207 = validateParameter(valid_595207, JString, required = false,
                                 default = nil)
  if valid_595207 != nil:
    section.add "$filter", valid_595207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595208: Call_ReplicationMigrationItemsList_595199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595208.validator(path, query, header, formData, body)
  let scheme = call_595208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595208.url(scheme.get, call_595208.host, call_595208.base,
                         call_595208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595208, url, valid)

proc call*(call_595209: Call_ReplicationMigrationItemsList_595199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationMigrationItemsList
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   skipToken: string
  ##            : The pagination token.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_595210 = newJObject()
  var query_595211 = newJObject()
  add(path_595210, "resourceGroupName", newJString(resourceGroupName))
  add(query_595211, "skipToken", newJString(skipToken))
  add(query_595211, "api-version", newJString(apiVersion))
  add(path_595210, "subscriptionId", newJString(subscriptionId))
  add(path_595210, "resourceName", newJString(resourceName))
  add(query_595211, "$filter", newJString(Filter))
  result = call_595209.call(path_595210, query_595211, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_595199(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_595200, base: "",
    url: url_ReplicationMigrationItemsList_595201, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_595212 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsList_595214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsList_595213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all ASR network mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595215 = path.getOrDefault("resourceGroupName")
  valid_595215 = validateParameter(valid_595215, JString, required = true,
                                 default = nil)
  if valid_595215 != nil:
    section.add "resourceGroupName", valid_595215
  var valid_595216 = path.getOrDefault("subscriptionId")
  valid_595216 = validateParameter(valid_595216, JString, required = true,
                                 default = nil)
  if valid_595216 != nil:
    section.add "subscriptionId", valid_595216
  var valid_595217 = path.getOrDefault("resourceName")
  valid_595217 = validateParameter(valid_595217, JString, required = true,
                                 default = nil)
  if valid_595217 != nil:
    section.add "resourceName", valid_595217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595218 = query.getOrDefault("api-version")
  valid_595218 = validateParameter(valid_595218, JString, required = true,
                                 default = nil)
  if valid_595218 != nil:
    section.add "api-version", valid_595218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595219: Call_ReplicationNetworkMappingsList_595212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_595219.validator(path, query, header, formData, body)
  let scheme = call_595219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595219.url(scheme.get, call_595219.host, call_595219.base,
                         call_595219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595219, url, valid)

proc call*(call_595220: Call_ReplicationNetworkMappingsList_595212;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsList
  ## Lists all ASR network mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595221 = newJObject()
  var query_595222 = newJObject()
  add(path_595221, "resourceGroupName", newJString(resourceGroupName))
  add(query_595222, "api-version", newJString(apiVersion))
  add(path_595221, "subscriptionId", newJString(subscriptionId))
  add(path_595221, "resourceName", newJString(resourceName))
  result = call_595220.call(path_595221, query_595222, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_595212(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_595213, base: "",
    url: url_ReplicationNetworkMappingsList_595214, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_595223 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworksList_595225(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksList_595224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available in a vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595226 = path.getOrDefault("resourceGroupName")
  valid_595226 = validateParameter(valid_595226, JString, required = true,
                                 default = nil)
  if valid_595226 != nil:
    section.add "resourceGroupName", valid_595226
  var valid_595227 = path.getOrDefault("subscriptionId")
  valid_595227 = validateParameter(valid_595227, JString, required = true,
                                 default = nil)
  if valid_595227 != nil:
    section.add "subscriptionId", valid_595227
  var valid_595228 = path.getOrDefault("resourceName")
  valid_595228 = validateParameter(valid_595228, JString, required = true,
                                 default = nil)
  if valid_595228 != nil:
    section.add "resourceName", valid_595228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595229 = query.getOrDefault("api-version")
  valid_595229 = validateParameter(valid_595229, JString, required = true,
                                 default = nil)
  if valid_595229 != nil:
    section.add "api-version", valid_595229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595230: Call_ReplicationNetworksList_595223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_595230.validator(path, query, header, formData, body)
  let scheme = call_595230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595230.url(scheme.get, call_595230.host, call_595230.base,
                         call_595230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595230, url, valid)

proc call*(call_595231: Call_ReplicationNetworksList_595223;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworksList
  ## Lists the networks available in a vault
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595232 = newJObject()
  var query_595233 = newJObject()
  add(path_595232, "resourceGroupName", newJString(resourceGroupName))
  add(query_595233, "api-version", newJString(apiVersion))
  add(path_595232, "subscriptionId", newJString(subscriptionId))
  add(path_595232, "resourceName", newJString(resourceName))
  result = call_595231.call(path_595232, query_595233, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_595223(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_595224, base: "",
    url: url_ReplicationNetworksList_595225, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_595234 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesList_595236(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesList_595235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the replication policies for a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595237 = path.getOrDefault("resourceGroupName")
  valid_595237 = validateParameter(valid_595237, JString, required = true,
                                 default = nil)
  if valid_595237 != nil:
    section.add "resourceGroupName", valid_595237
  var valid_595238 = path.getOrDefault("subscriptionId")
  valid_595238 = validateParameter(valid_595238, JString, required = true,
                                 default = nil)
  if valid_595238 != nil:
    section.add "subscriptionId", valid_595238
  var valid_595239 = path.getOrDefault("resourceName")
  valid_595239 = validateParameter(valid_595239, JString, required = true,
                                 default = nil)
  if valid_595239 != nil:
    section.add "resourceName", valid_595239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595240 = query.getOrDefault("api-version")
  valid_595240 = validateParameter(valid_595240, JString, required = true,
                                 default = nil)
  if valid_595240 != nil:
    section.add "api-version", valid_595240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595241: Call_ReplicationPoliciesList_595234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_595241.validator(path, query, header, formData, body)
  let scheme = call_595241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595241.url(scheme.get, call_595241.host, call_595241.base,
                         call_595241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595241, url, valid)

proc call*(call_595242: Call_ReplicationPoliciesList_595234;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationPoliciesList
  ## Lists the replication policies for a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595243 = newJObject()
  var query_595244 = newJObject()
  add(path_595243, "resourceGroupName", newJString(resourceGroupName))
  add(query_595244, "api-version", newJString(apiVersion))
  add(path_595243, "subscriptionId", newJString(subscriptionId))
  add(path_595243, "resourceName", newJString(resourceName))
  result = call_595242.call(path_595243, query_595244, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_595234(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_595235, base: "",
    url: url_ReplicationPoliciesList_595236, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_595257 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesCreate_595259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesCreate_595258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a replication policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595260 = path.getOrDefault("resourceGroupName")
  valid_595260 = validateParameter(valid_595260, JString, required = true,
                                 default = nil)
  if valid_595260 != nil:
    section.add "resourceGroupName", valid_595260
  var valid_595261 = path.getOrDefault("subscriptionId")
  valid_595261 = validateParameter(valid_595261, JString, required = true,
                                 default = nil)
  if valid_595261 != nil:
    section.add "subscriptionId", valid_595261
  var valid_595262 = path.getOrDefault("resourceName")
  valid_595262 = validateParameter(valid_595262, JString, required = true,
                                 default = nil)
  if valid_595262 != nil:
    section.add "resourceName", valid_595262
  var valid_595263 = path.getOrDefault("policyName")
  valid_595263 = validateParameter(valid_595263, JString, required = true,
                                 default = nil)
  if valid_595263 != nil:
    section.add "policyName", valid_595263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595264 = query.getOrDefault("api-version")
  valid_595264 = validateParameter(valid_595264, JString, required = true,
                                 default = nil)
  if valid_595264 != nil:
    section.add "api-version", valid_595264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Create policy input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595266: Call_ReplicationPoliciesCreate_595257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_595266.validator(path, query, header, formData, body)
  let scheme = call_595266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595266.url(scheme.get, call_595266.host, call_595266.base,
                         call_595266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595266, url, valid)

proc call*(call_595267: Call_ReplicationPoliciesCreate_595257;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesCreate
  ## The operation to create a replication policy
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Create policy input
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name
  var path_595268 = newJObject()
  var query_595269 = newJObject()
  var body_595270 = newJObject()
  add(path_595268, "resourceGroupName", newJString(resourceGroupName))
  add(query_595269, "api-version", newJString(apiVersion))
  add(path_595268, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595270 = input
  add(path_595268, "resourceName", newJString(resourceName))
  add(path_595268, "policyName", newJString(policyName))
  result = call_595267.call(path_595268, query_595269, nil, nil, body_595270)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_595257(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_595258, base: "",
    url: url_ReplicationPoliciesCreate_595259, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_595245 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesGet_595247(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesGet_595246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595248 = path.getOrDefault("resourceGroupName")
  valid_595248 = validateParameter(valid_595248, JString, required = true,
                                 default = nil)
  if valid_595248 != nil:
    section.add "resourceGroupName", valid_595248
  var valid_595249 = path.getOrDefault("subscriptionId")
  valid_595249 = validateParameter(valid_595249, JString, required = true,
                                 default = nil)
  if valid_595249 != nil:
    section.add "subscriptionId", valid_595249
  var valid_595250 = path.getOrDefault("resourceName")
  valid_595250 = validateParameter(valid_595250, JString, required = true,
                                 default = nil)
  if valid_595250 != nil:
    section.add "resourceName", valid_595250
  var valid_595251 = path.getOrDefault("policyName")
  valid_595251 = validateParameter(valid_595251, JString, required = true,
                                 default = nil)
  if valid_595251 != nil:
    section.add "policyName", valid_595251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595252 = query.getOrDefault("api-version")
  valid_595252 = validateParameter(valid_595252, JString, required = true,
                                 default = nil)
  if valid_595252 != nil:
    section.add "api-version", valid_595252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595253: Call_ReplicationPoliciesGet_595245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_595253.validator(path, query, header, formData, body)
  let scheme = call_595253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595253.url(scheme.get, call_595253.host, call_595253.base,
                         call_595253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595253, url, valid)

proc call*(call_595254: Call_ReplicationPoliciesGet_595245;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesGet
  ## Gets the details of a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name.
  var path_595255 = newJObject()
  var query_595256 = newJObject()
  add(path_595255, "resourceGroupName", newJString(resourceGroupName))
  add(query_595256, "api-version", newJString(apiVersion))
  add(path_595255, "subscriptionId", newJString(subscriptionId))
  add(path_595255, "resourceName", newJString(resourceName))
  add(path_595255, "policyName", newJString(policyName))
  result = call_595254.call(path_595255, query_595256, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_595245(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_595246, base: "",
    url: url_ReplicationPoliciesGet_595247, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_595283 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesUpdate_595285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesUpdate_595284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Policy Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595286 = path.getOrDefault("resourceGroupName")
  valid_595286 = validateParameter(valid_595286, JString, required = true,
                                 default = nil)
  if valid_595286 != nil:
    section.add "resourceGroupName", valid_595286
  var valid_595287 = path.getOrDefault("subscriptionId")
  valid_595287 = validateParameter(valid_595287, JString, required = true,
                                 default = nil)
  if valid_595287 != nil:
    section.add "subscriptionId", valid_595287
  var valid_595288 = path.getOrDefault("resourceName")
  valid_595288 = validateParameter(valid_595288, JString, required = true,
                                 default = nil)
  if valid_595288 != nil:
    section.add "resourceName", valid_595288
  var valid_595289 = path.getOrDefault("policyName")
  valid_595289 = validateParameter(valid_595289, JString, required = true,
                                 default = nil)
  if valid_595289 != nil:
    section.add "policyName", valid_595289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595290 = query.getOrDefault("api-version")
  valid_595290 = validateParameter(valid_595290, JString, required = true,
                                 default = nil)
  if valid_595290 != nil:
    section.add "api-version", valid_595290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Policy Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595292: Call_ReplicationPoliciesUpdate_595283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_595292.validator(path, query, header, formData, body)
  let scheme = call_595292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595292.url(scheme.get, call_595292.host, call_595292.base,
                         call_595292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595292, url, valid)

proc call*(call_595293: Call_ReplicationPoliciesUpdate_595283;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesUpdate
  ## The operation to update a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update Policy Input
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Policy Id.
  var path_595294 = newJObject()
  var query_595295 = newJObject()
  var body_595296 = newJObject()
  add(path_595294, "resourceGroupName", newJString(resourceGroupName))
  add(query_595295, "api-version", newJString(apiVersion))
  add(path_595294, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595296 = input
  add(path_595294, "resourceName", newJString(resourceName))
  add(path_595294, "policyName", newJString(policyName))
  result = call_595293.call(path_595294, query_595295, nil, nil, body_595296)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_595283(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_595284, base: "",
    url: url_ReplicationPoliciesUpdate_595285, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_595271 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesDelete_595273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesDelete_595272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595274 = path.getOrDefault("resourceGroupName")
  valid_595274 = validateParameter(valid_595274, JString, required = true,
                                 default = nil)
  if valid_595274 != nil:
    section.add "resourceGroupName", valid_595274
  var valid_595275 = path.getOrDefault("subscriptionId")
  valid_595275 = validateParameter(valid_595275, JString, required = true,
                                 default = nil)
  if valid_595275 != nil:
    section.add "subscriptionId", valid_595275
  var valid_595276 = path.getOrDefault("resourceName")
  valid_595276 = validateParameter(valid_595276, JString, required = true,
                                 default = nil)
  if valid_595276 != nil:
    section.add "resourceName", valid_595276
  var valid_595277 = path.getOrDefault("policyName")
  valid_595277 = validateParameter(valid_595277, JString, required = true,
                                 default = nil)
  if valid_595277 != nil:
    section.add "policyName", valid_595277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595278 = query.getOrDefault("api-version")
  valid_595278 = validateParameter(valid_595278, JString, required = true,
                                 default = nil)
  if valid_595278 != nil:
    section.add "api-version", valid_595278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595279: Call_ReplicationPoliciesDelete_595271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_595279.validator(path, query, header, formData, body)
  let scheme = call_595279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595279.url(scheme.get, call_595279.host, call_595279.base,
                         call_595279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595279, url, valid)

proc call*(call_595280: Call_ReplicationPoliciesDelete_595271;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesDelete
  ## The operation to delete a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name.
  var path_595281 = newJObject()
  var query_595282 = newJObject()
  add(path_595281, "resourceGroupName", newJString(resourceGroupName))
  add(query_595282, "api-version", newJString(apiVersion))
  add(path_595281, "subscriptionId", newJString(subscriptionId))
  add(path_595281, "resourceName", newJString(resourceName))
  add(path_595281, "policyName", newJString(policyName))
  result = call_595280.call(path_595281, query_595282, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_595271(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_595272, base: "",
    url: url_ReplicationPoliciesDelete_595273, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_595297 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsList_595299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsList_595298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595300 = path.getOrDefault("resourceGroupName")
  valid_595300 = validateParameter(valid_595300, JString, required = true,
                                 default = nil)
  if valid_595300 != nil:
    section.add "resourceGroupName", valid_595300
  var valid_595301 = path.getOrDefault("subscriptionId")
  valid_595301 = validateParameter(valid_595301, JString, required = true,
                                 default = nil)
  if valid_595301 != nil:
    section.add "subscriptionId", valid_595301
  var valid_595302 = path.getOrDefault("resourceName")
  valid_595302 = validateParameter(valid_595302, JString, required = true,
                                 default = nil)
  if valid_595302 != nil:
    section.add "resourceName", valid_595302
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_595303 = query.getOrDefault("skipToken")
  valid_595303 = validateParameter(valid_595303, JString, required = false,
                                 default = nil)
  if valid_595303 != nil:
    section.add "skipToken", valid_595303
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595304 = query.getOrDefault("api-version")
  valid_595304 = validateParameter(valid_595304, JString, required = true,
                                 default = nil)
  if valid_595304 != nil:
    section.add "api-version", valid_595304
  var valid_595305 = query.getOrDefault("$filter")
  valid_595305 = validateParameter(valid_595305, JString, required = false,
                                 default = nil)
  if valid_595305 != nil:
    section.add "$filter", valid_595305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595306: Call_ReplicationProtectedItemsList_595297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_595306.validator(path, query, header, formData, body)
  let scheme = call_595306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595306.url(scheme.get, call_595306.host, call_595306.base,
                         call_595306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595306, url, valid)

proc call*(call_595307: Call_ReplicationProtectedItemsList_595297;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationProtectedItemsList
  ## Gets the list of ASR replication protected items in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   skipToken: string
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_595308 = newJObject()
  var query_595309 = newJObject()
  add(path_595308, "resourceGroupName", newJString(resourceGroupName))
  add(query_595309, "skipToken", newJString(skipToken))
  add(query_595309, "api-version", newJString(apiVersion))
  add(path_595308, "subscriptionId", newJString(subscriptionId))
  add(path_595308, "resourceName", newJString(resourceName))
  add(query_595309, "$filter", newJString(Filter))
  result = call_595307.call(path_595308, query_595309, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_595297(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_595298, base: "",
    url: url_ReplicationProtectedItemsList_595299, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_595310 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsList_595312(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsList_595311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection container mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595313 = path.getOrDefault("resourceGroupName")
  valid_595313 = validateParameter(valid_595313, JString, required = true,
                                 default = nil)
  if valid_595313 != nil:
    section.add "resourceGroupName", valid_595313
  var valid_595314 = path.getOrDefault("subscriptionId")
  valid_595314 = validateParameter(valid_595314, JString, required = true,
                                 default = nil)
  if valid_595314 != nil:
    section.add "subscriptionId", valid_595314
  var valid_595315 = path.getOrDefault("resourceName")
  valid_595315 = validateParameter(valid_595315, JString, required = true,
                                 default = nil)
  if valid_595315 != nil:
    section.add "resourceName", valid_595315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595316 = query.getOrDefault("api-version")
  valid_595316 = validateParameter(valid_595316, JString, required = true,
                                 default = nil)
  if valid_595316 != nil:
    section.add "api-version", valid_595316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595317: Call_ReplicationProtectionContainerMappingsList_595310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_595317.validator(path, query, header, formData, body)
  let scheme = call_595317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595317.url(scheme.get, call_595317.host, call_595317.base,
                         call_595317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595317, url, valid)

proc call*(call_595318: Call_ReplicationProtectionContainerMappingsList_595310;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsList
  ## Lists the protection container mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595319 = newJObject()
  var query_595320 = newJObject()
  add(path_595319, "resourceGroupName", newJString(resourceGroupName))
  add(query_595320, "api-version", newJString(apiVersion))
  add(path_595319, "subscriptionId", newJString(subscriptionId))
  add(path_595319, "resourceName", newJString(resourceName))
  result = call_595318.call(path_595319, query_595320, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_595310(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_595311,
    base: "", url: url_ReplicationProtectionContainerMappingsList_595312,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_595321 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersList_595323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersList_595322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection containers in a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595324 = path.getOrDefault("resourceGroupName")
  valid_595324 = validateParameter(valid_595324, JString, required = true,
                                 default = nil)
  if valid_595324 != nil:
    section.add "resourceGroupName", valid_595324
  var valid_595325 = path.getOrDefault("subscriptionId")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = nil)
  if valid_595325 != nil:
    section.add "subscriptionId", valid_595325
  var valid_595326 = path.getOrDefault("resourceName")
  valid_595326 = validateParameter(valid_595326, JString, required = true,
                                 default = nil)
  if valid_595326 != nil:
    section.add "resourceName", valid_595326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595327 = query.getOrDefault("api-version")
  valid_595327 = validateParameter(valid_595327, JString, required = true,
                                 default = nil)
  if valid_595327 != nil:
    section.add "api-version", valid_595327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595328: Call_ReplicationProtectionContainersList_595321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_595328.validator(path, query, header, formData, body)
  let scheme = call_595328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595328.url(scheme.get, call_595328.host, call_595328.base,
                         call_595328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595328, url, valid)

proc call*(call_595329: Call_ReplicationProtectionContainersList_595321;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainersList
  ## Lists the protection containers in a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595330 = newJObject()
  var query_595331 = newJObject()
  add(path_595330, "resourceGroupName", newJString(resourceGroupName))
  add(query_595331, "api-version", newJString(apiVersion))
  add(path_595330, "subscriptionId", newJString(subscriptionId))
  add(path_595330, "resourceName", newJString(resourceName))
  result = call_595329.call(path_595330, query_595331, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_595321(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_595322, base: "",
    url: url_ReplicationProtectionContainersList_595323, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_595332 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansList_595334(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansList_595333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the recovery plans in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595335 = path.getOrDefault("resourceGroupName")
  valid_595335 = validateParameter(valid_595335, JString, required = true,
                                 default = nil)
  if valid_595335 != nil:
    section.add "resourceGroupName", valid_595335
  var valid_595336 = path.getOrDefault("subscriptionId")
  valid_595336 = validateParameter(valid_595336, JString, required = true,
                                 default = nil)
  if valid_595336 != nil:
    section.add "subscriptionId", valid_595336
  var valid_595337 = path.getOrDefault("resourceName")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "resourceName", valid_595337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595338 = query.getOrDefault("api-version")
  valid_595338 = validateParameter(valid_595338, JString, required = true,
                                 default = nil)
  if valid_595338 != nil:
    section.add "api-version", valid_595338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595339: Call_ReplicationRecoveryPlansList_595332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_595339.validator(path, query, header, formData, body)
  let scheme = call_595339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595339.url(scheme.get, call_595339.host, call_595339.base,
                         call_595339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595339, url, valid)

proc call*(call_595340: Call_ReplicationRecoveryPlansList_595332;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationRecoveryPlansList
  ## Lists the recovery plans in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595341 = newJObject()
  var query_595342 = newJObject()
  add(path_595341, "resourceGroupName", newJString(resourceGroupName))
  add(query_595342, "api-version", newJString(apiVersion))
  add(path_595341, "subscriptionId", newJString(subscriptionId))
  add(path_595341, "resourceName", newJString(resourceName))
  result = call_595340.call(path_595341, query_595342, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_595332(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_595333, base: "",
    url: url_ReplicationRecoveryPlansList_595334, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_595355 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansCreate_595357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansCreate_595356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595358 = path.getOrDefault("resourceGroupName")
  valid_595358 = validateParameter(valid_595358, JString, required = true,
                                 default = nil)
  if valid_595358 != nil:
    section.add "resourceGroupName", valid_595358
  var valid_595359 = path.getOrDefault("subscriptionId")
  valid_595359 = validateParameter(valid_595359, JString, required = true,
                                 default = nil)
  if valid_595359 != nil:
    section.add "subscriptionId", valid_595359
  var valid_595360 = path.getOrDefault("recoveryPlanName")
  valid_595360 = validateParameter(valid_595360, JString, required = true,
                                 default = nil)
  if valid_595360 != nil:
    section.add "recoveryPlanName", valid_595360
  var valid_595361 = path.getOrDefault("resourceName")
  valid_595361 = validateParameter(valid_595361, JString, required = true,
                                 default = nil)
  if valid_595361 != nil:
    section.add "resourceName", valid_595361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595362 = query.getOrDefault("api-version")
  valid_595362 = validateParameter(valid_595362, JString, required = true,
                                 default = nil)
  if valid_595362 != nil:
    section.add "api-version", valid_595362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Recovery Plan creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595364: Call_ReplicationRecoveryPlansCreate_595355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_595364.validator(path, query, header, formData, body)
  let scheme = call_595364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595364.url(scheme.get, call_595364.host, call_595364.base,
                         call_595364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595364, url, valid)

proc call*(call_595365: Call_ReplicationRecoveryPlansCreate_595355;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansCreate
  ## The operation to create a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Recovery Plan creation input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595366 = newJObject()
  var query_595367 = newJObject()
  var body_595368 = newJObject()
  add(path_595366, "resourceGroupName", newJString(resourceGroupName))
  add(query_595367, "api-version", newJString(apiVersion))
  add(path_595366, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595368 = input
  add(path_595366, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595366, "resourceName", newJString(resourceName))
  result = call_595365.call(path_595366, query_595367, nil, nil, body_595368)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_595355(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_595356, base: "",
    url: url_ReplicationRecoveryPlansCreate_595357, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_595343 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansGet_595345(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansGet_595344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Name of the recovery plan.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595346 = path.getOrDefault("resourceGroupName")
  valid_595346 = validateParameter(valid_595346, JString, required = true,
                                 default = nil)
  if valid_595346 != nil:
    section.add "resourceGroupName", valid_595346
  var valid_595347 = path.getOrDefault("subscriptionId")
  valid_595347 = validateParameter(valid_595347, JString, required = true,
                                 default = nil)
  if valid_595347 != nil:
    section.add "subscriptionId", valid_595347
  var valid_595348 = path.getOrDefault("recoveryPlanName")
  valid_595348 = validateParameter(valid_595348, JString, required = true,
                                 default = nil)
  if valid_595348 != nil:
    section.add "recoveryPlanName", valid_595348
  var valid_595349 = path.getOrDefault("resourceName")
  valid_595349 = validateParameter(valid_595349, JString, required = true,
                                 default = nil)
  if valid_595349 != nil:
    section.add "resourceName", valid_595349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595350 = query.getOrDefault("api-version")
  valid_595350 = validateParameter(valid_595350, JString, required = true,
                                 default = nil)
  if valid_595350 != nil:
    section.add "api-version", valid_595350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595351: Call_ReplicationRecoveryPlansGet_595343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_595351.validator(path, query, header, formData, body)
  let scheme = call_595351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595351.url(scheme.get, call_595351.host, call_595351.base,
                         call_595351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595351, url, valid)

proc call*(call_595352: Call_ReplicationRecoveryPlansGet_595343;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansGet
  ## Gets the details of the recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Name of the recovery plan.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595353 = newJObject()
  var query_595354 = newJObject()
  add(path_595353, "resourceGroupName", newJString(resourceGroupName))
  add(query_595354, "api-version", newJString(apiVersion))
  add(path_595353, "subscriptionId", newJString(subscriptionId))
  add(path_595353, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595353, "resourceName", newJString(resourceName))
  result = call_595352.call(path_595353, query_595354, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_595343(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_595344, base: "",
    url: url_ReplicationRecoveryPlansGet_595345, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_595381 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansUpdate_595383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansUpdate_595382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595384 = path.getOrDefault("resourceGroupName")
  valid_595384 = validateParameter(valid_595384, JString, required = true,
                                 default = nil)
  if valid_595384 != nil:
    section.add "resourceGroupName", valid_595384
  var valid_595385 = path.getOrDefault("subscriptionId")
  valid_595385 = validateParameter(valid_595385, JString, required = true,
                                 default = nil)
  if valid_595385 != nil:
    section.add "subscriptionId", valid_595385
  var valid_595386 = path.getOrDefault("recoveryPlanName")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "recoveryPlanName", valid_595386
  var valid_595387 = path.getOrDefault("resourceName")
  valid_595387 = validateParameter(valid_595387, JString, required = true,
                                 default = nil)
  if valid_595387 != nil:
    section.add "resourceName", valid_595387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595388 = query.getOrDefault("api-version")
  valid_595388 = validateParameter(valid_595388, JString, required = true,
                                 default = nil)
  if valid_595388 != nil:
    section.add "api-version", valid_595388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update recovery plan input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595390: Call_ReplicationRecoveryPlansUpdate_595381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_595390.validator(path, query, header, formData, body)
  let scheme = call_595390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595390.url(scheme.get, call_595390.host, call_595390.base,
                         call_595390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595390, url, valid)

proc call*(call_595391: Call_ReplicationRecoveryPlansUpdate_595381;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUpdate
  ## The operation to update a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update recovery plan input
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595392 = newJObject()
  var query_595393 = newJObject()
  var body_595394 = newJObject()
  add(path_595392, "resourceGroupName", newJString(resourceGroupName))
  add(query_595393, "api-version", newJString(apiVersion))
  add(path_595392, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595394 = input
  add(path_595392, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595392, "resourceName", newJString(resourceName))
  result = call_595391.call(path_595392, query_595393, nil, nil, body_595394)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_595381(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_595382, base: "",
    url: url_ReplicationRecoveryPlansUpdate_595383, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_595369 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansDelete_595371(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansDelete_595370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595372 = path.getOrDefault("resourceGroupName")
  valid_595372 = validateParameter(valid_595372, JString, required = true,
                                 default = nil)
  if valid_595372 != nil:
    section.add "resourceGroupName", valid_595372
  var valid_595373 = path.getOrDefault("subscriptionId")
  valid_595373 = validateParameter(valid_595373, JString, required = true,
                                 default = nil)
  if valid_595373 != nil:
    section.add "subscriptionId", valid_595373
  var valid_595374 = path.getOrDefault("recoveryPlanName")
  valid_595374 = validateParameter(valid_595374, JString, required = true,
                                 default = nil)
  if valid_595374 != nil:
    section.add "recoveryPlanName", valid_595374
  var valid_595375 = path.getOrDefault("resourceName")
  valid_595375 = validateParameter(valid_595375, JString, required = true,
                                 default = nil)
  if valid_595375 != nil:
    section.add "resourceName", valid_595375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595376 = query.getOrDefault("api-version")
  valid_595376 = validateParameter(valid_595376, JString, required = true,
                                 default = nil)
  if valid_595376 != nil:
    section.add "api-version", valid_595376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595377: Call_ReplicationRecoveryPlansDelete_595369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_595377.validator(path, query, header, formData, body)
  let scheme = call_595377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595377.url(scheme.get, call_595377.host, call_595377.base,
                         call_595377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595377, url, valid)

proc call*(call_595378: Call_ReplicationRecoveryPlansDelete_595369;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansDelete
  ## Delete a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595379 = newJObject()
  var query_595380 = newJObject()
  add(path_595379, "resourceGroupName", newJString(resourceGroupName))
  add(query_595380, "api-version", newJString(apiVersion))
  add(path_595379, "subscriptionId", newJString(subscriptionId))
  add(path_595379, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595379, "resourceName", newJString(resourceName))
  result = call_595378.call(path_595379, query_595380, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_595369(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_595370, base: "",
    url: url_ReplicationRecoveryPlansDelete_595371, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_595395 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansFailoverCommit_595397(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/failoverCommit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansFailoverCommit_595396(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595398 = path.getOrDefault("resourceGroupName")
  valid_595398 = validateParameter(valid_595398, JString, required = true,
                                 default = nil)
  if valid_595398 != nil:
    section.add "resourceGroupName", valid_595398
  var valid_595399 = path.getOrDefault("subscriptionId")
  valid_595399 = validateParameter(valid_595399, JString, required = true,
                                 default = nil)
  if valid_595399 != nil:
    section.add "subscriptionId", valid_595399
  var valid_595400 = path.getOrDefault("recoveryPlanName")
  valid_595400 = validateParameter(valid_595400, JString, required = true,
                                 default = nil)
  if valid_595400 != nil:
    section.add "recoveryPlanName", valid_595400
  var valid_595401 = path.getOrDefault("resourceName")
  valid_595401 = validateParameter(valid_595401, JString, required = true,
                                 default = nil)
  if valid_595401 != nil:
    section.add "resourceName", valid_595401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595402 = query.getOrDefault("api-version")
  valid_595402 = validateParameter(valid_595402, JString, required = true,
                                 default = nil)
  if valid_595402 != nil:
    section.add "api-version", valid_595402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595403: Call_ReplicationRecoveryPlansFailoverCommit_595395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_595403.validator(path, query, header, formData, body)
  let scheme = call_595403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595403.url(scheme.get, call_595403.host, call_595403.base,
                         call_595403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595403, url, valid)

proc call*(call_595404: Call_ReplicationRecoveryPlansFailoverCommit_595395;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansFailoverCommit
  ## The operation to commit the fail over of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595405 = newJObject()
  var query_595406 = newJObject()
  add(path_595405, "resourceGroupName", newJString(resourceGroupName))
  add(query_595406, "api-version", newJString(apiVersion))
  add(path_595405, "subscriptionId", newJString(subscriptionId))
  add(path_595405, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595405, "resourceName", newJString(resourceName))
  result = call_595404.call(path_595405, query_595406, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_595395(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_595396, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_595397,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_595407 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansPlannedFailover_595409(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/plannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansPlannedFailover_595408(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595410 = path.getOrDefault("resourceGroupName")
  valid_595410 = validateParameter(valid_595410, JString, required = true,
                                 default = nil)
  if valid_595410 != nil:
    section.add "resourceGroupName", valid_595410
  var valid_595411 = path.getOrDefault("subscriptionId")
  valid_595411 = validateParameter(valid_595411, JString, required = true,
                                 default = nil)
  if valid_595411 != nil:
    section.add "subscriptionId", valid_595411
  var valid_595412 = path.getOrDefault("recoveryPlanName")
  valid_595412 = validateParameter(valid_595412, JString, required = true,
                                 default = nil)
  if valid_595412 != nil:
    section.add "recoveryPlanName", valid_595412
  var valid_595413 = path.getOrDefault("resourceName")
  valid_595413 = validateParameter(valid_595413, JString, required = true,
                                 default = nil)
  if valid_595413 != nil:
    section.add "resourceName", valid_595413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595414 = query.getOrDefault("api-version")
  valid_595414 = validateParameter(valid_595414, JString, required = true,
                                 default = nil)
  if valid_595414 != nil:
    section.add "api-version", valid_595414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595416: Call_ReplicationRecoveryPlansPlannedFailover_595407;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_595416.validator(path, query, header, formData, body)
  let scheme = call_595416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595416.url(scheme.get, call_595416.host, call_595416.base,
                         call_595416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595416, url, valid)

proc call*(call_595417: Call_ReplicationRecoveryPlansPlannedFailover_595407;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansPlannedFailover
  ## The operation to start the planned failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595418 = newJObject()
  var query_595419 = newJObject()
  var body_595420 = newJObject()
  add(path_595418, "resourceGroupName", newJString(resourceGroupName))
  add(query_595419, "api-version", newJString(apiVersion))
  add(path_595418, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595420 = input
  add(path_595418, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595418, "resourceName", newJString(resourceName))
  result = call_595417.call(path_595418, query_595419, nil, nil, body_595420)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_595407(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_595408, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_595409,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_595421 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansReprotect_595423(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/reProtect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansReprotect_595422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595424 = path.getOrDefault("resourceGroupName")
  valid_595424 = validateParameter(valid_595424, JString, required = true,
                                 default = nil)
  if valid_595424 != nil:
    section.add "resourceGroupName", valid_595424
  var valid_595425 = path.getOrDefault("subscriptionId")
  valid_595425 = validateParameter(valid_595425, JString, required = true,
                                 default = nil)
  if valid_595425 != nil:
    section.add "subscriptionId", valid_595425
  var valid_595426 = path.getOrDefault("recoveryPlanName")
  valid_595426 = validateParameter(valid_595426, JString, required = true,
                                 default = nil)
  if valid_595426 != nil:
    section.add "recoveryPlanName", valid_595426
  var valid_595427 = path.getOrDefault("resourceName")
  valid_595427 = validateParameter(valid_595427, JString, required = true,
                                 default = nil)
  if valid_595427 != nil:
    section.add "resourceName", valid_595427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595428 = query.getOrDefault("api-version")
  valid_595428 = validateParameter(valid_595428, JString, required = true,
                                 default = nil)
  if valid_595428 != nil:
    section.add "api-version", valid_595428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595429: Call_ReplicationRecoveryPlansReprotect_595421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_595429.validator(path, query, header, formData, body)
  let scheme = call_595429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595429.url(scheme.get, call_595429.host, call_595429.base,
                         call_595429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595429, url, valid)

proc call*(call_595430: Call_ReplicationRecoveryPlansReprotect_595421;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansReprotect
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595431 = newJObject()
  var query_595432 = newJObject()
  add(path_595431, "resourceGroupName", newJString(resourceGroupName))
  add(query_595432, "api-version", newJString(apiVersion))
  add(path_595431, "subscriptionId", newJString(subscriptionId))
  add(path_595431, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595431, "resourceName", newJString(resourceName))
  result = call_595430.call(path_595431, query_595432, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_595421(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_595422, base: "",
    url: url_ReplicationRecoveryPlansReprotect_595423, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_595433 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansTestFailover_595435(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/testFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansTestFailover_595434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595436 = path.getOrDefault("resourceGroupName")
  valid_595436 = validateParameter(valid_595436, JString, required = true,
                                 default = nil)
  if valid_595436 != nil:
    section.add "resourceGroupName", valid_595436
  var valid_595437 = path.getOrDefault("subscriptionId")
  valid_595437 = validateParameter(valid_595437, JString, required = true,
                                 default = nil)
  if valid_595437 != nil:
    section.add "subscriptionId", valid_595437
  var valid_595438 = path.getOrDefault("recoveryPlanName")
  valid_595438 = validateParameter(valid_595438, JString, required = true,
                                 default = nil)
  if valid_595438 != nil:
    section.add "recoveryPlanName", valid_595438
  var valid_595439 = path.getOrDefault("resourceName")
  valid_595439 = validateParameter(valid_595439, JString, required = true,
                                 default = nil)
  if valid_595439 != nil:
    section.add "resourceName", valid_595439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595440 = query.getOrDefault("api-version")
  valid_595440 = validateParameter(valid_595440, JString, required = true,
                                 default = nil)
  if valid_595440 != nil:
    section.add "api-version", valid_595440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595442: Call_ReplicationRecoveryPlansTestFailover_595433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_595442.validator(path, query, header, formData, body)
  let scheme = call_595442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595442.url(scheme.get, call_595442.host, call_595442.base,
                         call_595442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595442, url, valid)

proc call*(call_595443: Call_ReplicationRecoveryPlansTestFailover_595433;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailover
  ## The operation to start the test failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595444 = newJObject()
  var query_595445 = newJObject()
  var body_595446 = newJObject()
  add(path_595444, "resourceGroupName", newJString(resourceGroupName))
  add(query_595445, "api-version", newJString(apiVersion))
  add(path_595444, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595446 = input
  add(path_595444, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595444, "resourceName", newJString(resourceName))
  result = call_595443.call(path_595444, query_595445, nil, nil, body_595446)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_595433(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_595434, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_595435, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_595447 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansTestFailoverCleanup_595449(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/testFailoverCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_595448(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595450 = path.getOrDefault("resourceGroupName")
  valid_595450 = validateParameter(valid_595450, JString, required = true,
                                 default = nil)
  if valid_595450 != nil:
    section.add "resourceGroupName", valid_595450
  var valid_595451 = path.getOrDefault("subscriptionId")
  valid_595451 = validateParameter(valid_595451, JString, required = true,
                                 default = nil)
  if valid_595451 != nil:
    section.add "subscriptionId", valid_595451
  var valid_595452 = path.getOrDefault("recoveryPlanName")
  valid_595452 = validateParameter(valid_595452, JString, required = true,
                                 default = nil)
  if valid_595452 != nil:
    section.add "recoveryPlanName", valid_595452
  var valid_595453 = path.getOrDefault("resourceName")
  valid_595453 = validateParameter(valid_595453, JString, required = true,
                                 default = nil)
  if valid_595453 != nil:
    section.add "resourceName", valid_595453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595454 = query.getOrDefault("api-version")
  valid_595454 = validateParameter(valid_595454, JString, required = true,
                                 default = nil)
  if valid_595454 != nil:
    section.add "api-version", valid_595454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Test failover cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595456: Call_ReplicationRecoveryPlansTestFailoverCleanup_595447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_595456.validator(path, query, header, formData, body)
  let scheme = call_595456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595456.url(scheme.get, call_595456.host, call_595456.base,
                         call_595456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595456, url, valid)

proc call*(call_595457: Call_ReplicationRecoveryPlansTestFailoverCleanup_595447;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailoverCleanup
  ## The operation to cleanup test failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Test failover cleanup input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595458 = newJObject()
  var query_595459 = newJObject()
  var body_595460 = newJObject()
  add(path_595458, "resourceGroupName", newJString(resourceGroupName))
  add(query_595459, "api-version", newJString(apiVersion))
  add(path_595458, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595460 = input
  add(path_595458, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595458, "resourceName", newJString(resourceName))
  result = call_595457.call(path_595458, query_595459, nil, nil, body_595460)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_595447(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_595448,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_595449,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_595461 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansUnplannedFailover_595463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/unplannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansUnplannedFailover_595462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595464 = path.getOrDefault("resourceGroupName")
  valid_595464 = validateParameter(valid_595464, JString, required = true,
                                 default = nil)
  if valid_595464 != nil:
    section.add "resourceGroupName", valid_595464
  var valid_595465 = path.getOrDefault("subscriptionId")
  valid_595465 = validateParameter(valid_595465, JString, required = true,
                                 default = nil)
  if valid_595465 != nil:
    section.add "subscriptionId", valid_595465
  var valid_595466 = path.getOrDefault("recoveryPlanName")
  valid_595466 = validateParameter(valid_595466, JString, required = true,
                                 default = nil)
  if valid_595466 != nil:
    section.add "recoveryPlanName", valid_595466
  var valid_595467 = path.getOrDefault("resourceName")
  valid_595467 = validateParameter(valid_595467, JString, required = true,
                                 default = nil)
  if valid_595467 != nil:
    section.add "resourceName", valid_595467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595468 = query.getOrDefault("api-version")
  valid_595468 = validateParameter(valid_595468, JString, required = true,
                                 default = nil)
  if valid_595468 != nil:
    section.add "api-version", valid_595468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595470: Call_ReplicationRecoveryPlansUnplannedFailover_595461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_595470.validator(path, query, header, formData, body)
  let scheme = call_595470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595470.url(scheme.get, call_595470.host, call_595470.base,
                         call_595470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595470, url, valid)

proc call*(call_595471: Call_ReplicationRecoveryPlansUnplannedFailover_595461;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUnplannedFailover
  ## The operation to start the failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595472 = newJObject()
  var query_595473 = newJObject()
  var body_595474 = newJObject()
  add(path_595472, "resourceGroupName", newJString(resourceGroupName))
  add(query_595473, "api-version", newJString(apiVersion))
  add(path_595472, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595474 = input
  add(path_595472, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595472, "resourceName", newJString(resourceName))
  result = call_595471.call(path_595472, query_595473, nil, nil, body_595474)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_595461(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_595462,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_595463,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_595475 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersList_595477(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationRecoveryServicesProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersList_595476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers in the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595478 = path.getOrDefault("resourceGroupName")
  valid_595478 = validateParameter(valid_595478, JString, required = true,
                                 default = nil)
  if valid_595478 != nil:
    section.add "resourceGroupName", valid_595478
  var valid_595479 = path.getOrDefault("subscriptionId")
  valid_595479 = validateParameter(valid_595479, JString, required = true,
                                 default = nil)
  if valid_595479 != nil:
    section.add "subscriptionId", valid_595479
  var valid_595480 = path.getOrDefault("resourceName")
  valid_595480 = validateParameter(valid_595480, JString, required = true,
                                 default = nil)
  if valid_595480 != nil:
    section.add "resourceName", valid_595480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595481 = query.getOrDefault("api-version")
  valid_595481 = validateParameter(valid_595481, JString, required = true,
                                 default = nil)
  if valid_595481 != nil:
    section.add "api-version", valid_595481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595482: Call_ReplicationRecoveryServicesProvidersList_595475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_595482.validator(path, query, header, formData, body)
  let scheme = call_595482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595482.url(scheme.get, call_595482.host, call_595482.base,
                         call_595482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595482, url, valid)

proc call*(call_595483: Call_ReplicationRecoveryServicesProvidersList_595475;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersList
  ## Lists the registered recovery services providers in the vault
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595484 = newJObject()
  var query_595485 = newJObject()
  add(path_595484, "resourceGroupName", newJString(resourceGroupName))
  add(query_595485, "api-version", newJString(apiVersion))
  add(path_595484, "subscriptionId", newJString(subscriptionId))
  add(path_595484, "resourceName", newJString(resourceName))
  result = call_595483.call(path_595484, query_595485, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_595475(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_595476, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_595477,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_595486 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsList_595488(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsList_595487(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classification mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595489 = path.getOrDefault("resourceGroupName")
  valid_595489 = validateParameter(valid_595489, JString, required = true,
                                 default = nil)
  if valid_595489 != nil:
    section.add "resourceGroupName", valid_595489
  var valid_595490 = path.getOrDefault("subscriptionId")
  valid_595490 = validateParameter(valid_595490, JString, required = true,
                                 default = nil)
  if valid_595490 != nil:
    section.add "subscriptionId", valid_595490
  var valid_595491 = path.getOrDefault("resourceName")
  valid_595491 = validateParameter(valid_595491, JString, required = true,
                                 default = nil)
  if valid_595491 != nil:
    section.add "resourceName", valid_595491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595492 = query.getOrDefault("api-version")
  valid_595492 = validateParameter(valid_595492, JString, required = true,
                                 default = nil)
  if valid_595492 != nil:
    section.add "api-version", valid_595492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595493: Call_ReplicationStorageClassificationMappingsList_595486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_595493.validator(path, query, header, formData, body)
  let scheme = call_595493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595493.url(scheme.get, call_595493.host, call_595493.base,
                         call_595493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595493, url, valid)

proc call*(call_595494: Call_ReplicationStorageClassificationMappingsList_595486;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationMappingsList
  ## Lists the storage classification mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595495 = newJObject()
  var query_595496 = newJObject()
  add(path_595495, "resourceGroupName", newJString(resourceGroupName))
  add(query_595496, "api-version", newJString(apiVersion))
  add(path_595495, "subscriptionId", newJString(subscriptionId))
  add(path_595495, "resourceName", newJString(resourceName))
  result = call_595494.call(path_595495, query_595496, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_595486(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_595487,
    base: "", url: url_ReplicationStorageClassificationMappingsList_595488,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_595497 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsList_595499(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationStorageClassifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsList_595498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classifications in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595500 = path.getOrDefault("resourceGroupName")
  valid_595500 = validateParameter(valid_595500, JString, required = true,
                                 default = nil)
  if valid_595500 != nil:
    section.add "resourceGroupName", valid_595500
  var valid_595501 = path.getOrDefault("subscriptionId")
  valid_595501 = validateParameter(valid_595501, JString, required = true,
                                 default = nil)
  if valid_595501 != nil:
    section.add "subscriptionId", valid_595501
  var valid_595502 = path.getOrDefault("resourceName")
  valid_595502 = validateParameter(valid_595502, JString, required = true,
                                 default = nil)
  if valid_595502 != nil:
    section.add "resourceName", valid_595502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595503 = query.getOrDefault("api-version")
  valid_595503 = validateParameter(valid_595503, JString, required = true,
                                 default = nil)
  if valid_595503 != nil:
    section.add "api-version", valid_595503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595504: Call_ReplicationStorageClassificationsList_595497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_595504.validator(path, query, header, formData, body)
  let scheme = call_595504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595504.url(scheme.get, call_595504.host, call_595504.base,
                         call_595504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595504, url, valid)

proc call*(call_595505: Call_ReplicationStorageClassificationsList_595497;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationsList
  ## Lists the storage classifications in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595506 = newJObject()
  var query_595507 = newJObject()
  add(path_595506, "resourceGroupName", newJString(resourceGroupName))
  add(query_595507, "api-version", newJString(apiVersion))
  add(path_595506, "subscriptionId", newJString(subscriptionId))
  add(path_595506, "resourceName", newJString(resourceName))
  result = call_595505.call(path_595506, query_595507, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_595497(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_595498, base: "",
    url: url_ReplicationStorageClassificationsList_595499, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_595508 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultHealthGet_595510(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultHealthGet_595509(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health details of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595511 = path.getOrDefault("resourceGroupName")
  valid_595511 = validateParameter(valid_595511, JString, required = true,
                                 default = nil)
  if valid_595511 != nil:
    section.add "resourceGroupName", valid_595511
  var valid_595512 = path.getOrDefault("subscriptionId")
  valid_595512 = validateParameter(valid_595512, JString, required = true,
                                 default = nil)
  if valid_595512 != nil:
    section.add "subscriptionId", valid_595512
  var valid_595513 = path.getOrDefault("resourceName")
  valid_595513 = validateParameter(valid_595513, JString, required = true,
                                 default = nil)
  if valid_595513 != nil:
    section.add "resourceName", valid_595513
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595514 = query.getOrDefault("api-version")
  valid_595514 = validateParameter(valid_595514, JString, required = true,
                                 default = nil)
  if valid_595514 != nil:
    section.add "api-version", valid_595514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595515: Call_ReplicationVaultHealthGet_595508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_595515.validator(path, query, header, formData, body)
  let scheme = call_595515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595515.url(scheme.get, call_595515.host, call_595515.base,
                         call_595515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595515, url, valid)

proc call*(call_595516: Call_ReplicationVaultHealthGet_595508;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultHealthGet
  ## Gets the health details of the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595517 = newJObject()
  var query_595518 = newJObject()
  add(path_595517, "resourceGroupName", newJString(resourceGroupName))
  add(query_595518, "api-version", newJString(apiVersion))
  add(path_595517, "subscriptionId", newJString(subscriptionId))
  add(path_595517, "resourceName", newJString(resourceName))
  result = call_595516.call(path_595517, query_595518, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_595508(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_595509, base: "",
    url: url_ReplicationVaultHealthGet_595510, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_595519 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultHealthRefresh_595521(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationVaultHealth/default/refresh")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultHealthRefresh_595520(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595522 = path.getOrDefault("resourceGroupName")
  valid_595522 = validateParameter(valid_595522, JString, required = true,
                                 default = nil)
  if valid_595522 != nil:
    section.add "resourceGroupName", valid_595522
  var valid_595523 = path.getOrDefault("subscriptionId")
  valid_595523 = validateParameter(valid_595523, JString, required = true,
                                 default = nil)
  if valid_595523 != nil:
    section.add "subscriptionId", valid_595523
  var valid_595524 = path.getOrDefault("resourceName")
  valid_595524 = validateParameter(valid_595524, JString, required = true,
                                 default = nil)
  if valid_595524 != nil:
    section.add "resourceName", valid_595524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595525 = query.getOrDefault("api-version")
  valid_595525 = validateParameter(valid_595525, JString, required = true,
                                 default = nil)
  if valid_595525 != nil:
    section.add "api-version", valid_595525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595526: Call_ReplicationVaultHealthRefresh_595519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595526.validator(path, query, header, formData, body)
  let scheme = call_595526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595526.url(scheme.get, call_595526.host, call_595526.base,
                         call_595526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595526, url, valid)

proc call*(call_595527: Call_ReplicationVaultHealthRefresh_595519;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultHealthRefresh
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595528 = newJObject()
  var query_595529 = newJObject()
  add(path_595528, "resourceGroupName", newJString(resourceGroupName))
  add(query_595529, "api-version", newJString(apiVersion))
  add(path_595528, "subscriptionId", newJString(subscriptionId))
  add(path_595528, "resourceName", newJString(resourceName))
  result = call_595527.call(path_595528, query_595529, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_595519(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_595520, base: "",
    url: url_ReplicationVaultHealthRefresh_595521, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_595530 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersList_595532(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationvCenters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersList_595531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595533 = path.getOrDefault("resourceGroupName")
  valid_595533 = validateParameter(valid_595533, JString, required = true,
                                 default = nil)
  if valid_595533 != nil:
    section.add "resourceGroupName", valid_595533
  var valid_595534 = path.getOrDefault("subscriptionId")
  valid_595534 = validateParameter(valid_595534, JString, required = true,
                                 default = nil)
  if valid_595534 != nil:
    section.add "subscriptionId", valid_595534
  var valid_595535 = path.getOrDefault("resourceName")
  valid_595535 = validateParameter(valid_595535, JString, required = true,
                                 default = nil)
  if valid_595535 != nil:
    section.add "resourceName", valid_595535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595536 = query.getOrDefault("api-version")
  valid_595536 = validateParameter(valid_595536, JString, required = true,
                                 default = nil)
  if valid_595536 != nil:
    section.add "api-version", valid_595536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595537: Call_ReplicationvCentersList_595530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_595537.validator(path, query, header, formData, body)
  let scheme = call_595537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595537.url(scheme.get, call_595537.host, call_595537.base,
                         call_595537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595537, url, valid)

proc call*(call_595538: Call_ReplicationvCentersList_595530;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationvCentersList
  ## Lists the vCenter servers registered in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595539 = newJObject()
  var query_595540 = newJObject()
  add(path_595539, "resourceGroupName", newJString(resourceGroupName))
  add(query_595540, "api-version", newJString(apiVersion))
  add(path_595539, "subscriptionId", newJString(subscriptionId))
  add(path_595539, "resourceName", newJString(resourceName))
  result = call_595538.call(path_595539, query_595540, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_595530(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_595531, base: "",
    url: url_ReplicationvCentersList_595532, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
