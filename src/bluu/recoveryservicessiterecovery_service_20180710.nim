
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SiteRecoveryManagementClient
## version: 2018-07-10
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
  Call_ReplicationProtectedItemsResolveHealthErrors_594592 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsResolveHealthErrors_594594(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/ResolveHealthErrors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsResolveHealthErrors_594593(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to resolve health issues of the replication protected item.
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
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_ReplicationProtectedItemsResolveHealthErrors_594592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to resolve health issues of the replication protected item.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_ReplicationProtectedItemsResolveHealthErrors_594592;
          fabricName: string; resourceGroupName: string;
          resolveHealthInput: JsonNode; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsResolveHealthErrors
  ## Operation to resolve health issues of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
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
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  var body_594607 = newJObject()
  add(path_594605, "fabricName", newJString(fabricName))
  add(path_594605, "resourceGroupName", newJString(resourceGroupName))
  if resolveHealthInput != nil:
    body_594607 = resolveHealthInput
  add(query_594606, "api-version", newJString(apiVersion))
  add(path_594605, "subscriptionId", newJString(subscriptionId))
  add(path_594605, "resourceName", newJString(resourceName))
  add(path_594605, "protectionContainerName", newJString(protectionContainerName))
  add(path_594605, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594604.call(path_594605, query_594606, nil, nil, body_594607)

var replicationProtectedItemsResolveHealthErrors* = Call_ReplicationProtectedItemsResolveHealthErrors_594592(
    name: "replicationProtectedItemsResolveHealthErrors",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/ResolveHealthErrors",
    validator: validate_ReplicationProtectedItemsResolveHealthErrors_594593,
    base: "", url: url_ReplicationProtectedItemsResolveHealthErrors_594594,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsAddDisks_594608 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsAddDisks_594610(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/addDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsAddDisks_594609(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to add disks(s) to the replication protected item.
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
  ## parameters in `body` object:
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594619: Call_ReplicationProtectedItemsAddDisks_594608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to add disks(s) to the replication protected item.
  ## 
  let valid = call_594619.validator(path, query, header, formData, body)
  let scheme = call_594619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594619.url(scheme.get, call_594619.host, call_594619.base,
                         call_594619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594619, url, valid)

proc call*(call_594620: Call_ReplicationProtectedItemsAddDisks_594608;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          addDisksInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsAddDisks
  ## Operation to add disks(s) to the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594621 = newJObject()
  var query_594622 = newJObject()
  var body_594623 = newJObject()
  add(path_594621, "fabricName", newJString(fabricName))
  add(path_594621, "resourceGroupName", newJString(resourceGroupName))
  add(query_594622, "api-version", newJString(apiVersion))
  if addDisksInput != nil:
    body_594623 = addDisksInput
  add(path_594621, "subscriptionId", newJString(subscriptionId))
  add(path_594621, "resourceName", newJString(resourceName))
  add(path_594621, "protectionContainerName", newJString(protectionContainerName))
  add(path_594621, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594620.call(path_594621, query_594622, nil, nil, body_594623)

var replicationProtectedItemsAddDisks* = Call_ReplicationProtectedItemsAddDisks_594608(
    name: "replicationProtectedItemsAddDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/addDisks",
    validator: validate_ReplicationProtectedItemsAddDisks_594609, base: "",
    url: url_ReplicationProtectedItemsAddDisks_594610, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_594624 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsApplyRecoveryPoint_594626(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_594625(path: JsonNode;
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
  var valid_594627 = path.getOrDefault("fabricName")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "fabricName", valid_594627
  var valid_594628 = path.getOrDefault("resourceGroupName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "resourceGroupName", valid_594628
  var valid_594629 = path.getOrDefault("subscriptionId")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "subscriptionId", valid_594629
  var valid_594630 = path.getOrDefault("resourceName")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "resourceName", valid_594630
  var valid_594631 = path.getOrDefault("protectionContainerName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "protectionContainerName", valid_594631
  var valid_594632 = path.getOrDefault("replicatedProtectedItemName")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "replicatedProtectedItemName", valid_594632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594633 = query.getOrDefault("api-version")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "api-version", valid_594633
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

proc call*(call_594635: Call_ReplicationProtectedItemsApplyRecoveryPoint_594624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_ReplicationProtectedItemsApplyRecoveryPoint_594624;
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
  var path_594637 = newJObject()
  var query_594638 = newJObject()
  var body_594639 = newJObject()
  add(path_594637, "fabricName", newJString(fabricName))
  add(path_594637, "resourceGroupName", newJString(resourceGroupName))
  add(query_594638, "api-version", newJString(apiVersion))
  if applyRecoveryPointInput != nil:
    body_594639 = applyRecoveryPointInput
  add(path_594637, "subscriptionId", newJString(subscriptionId))
  add(path_594637, "resourceName", newJString(resourceName))
  add(path_594637, "protectionContainerName", newJString(protectionContainerName))
  add(path_594637, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594636.call(path_594637, query_594638, nil, nil, body_594639)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_594624(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_594625,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_594626,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_594640 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsFailoverCommit_594642(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_594641(path: JsonNode;
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
  var valid_594643 = path.getOrDefault("fabricName")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "fabricName", valid_594643
  var valid_594644 = path.getOrDefault("resourceGroupName")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "resourceGroupName", valid_594644
  var valid_594645 = path.getOrDefault("subscriptionId")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "subscriptionId", valid_594645
  var valid_594646 = path.getOrDefault("resourceName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "resourceName", valid_594646
  var valid_594647 = path.getOrDefault("protectionContainerName")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "protectionContainerName", valid_594647
  var valid_594648 = path.getOrDefault("replicatedProtectedItemName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "replicatedProtectedItemName", valid_594648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594649 = query.getOrDefault("api-version")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "api-version", valid_594649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594650: Call_ReplicationProtectedItemsFailoverCommit_594640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_594650.validator(path, query, header, formData, body)
  let scheme = call_594650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594650.url(scheme.get, call_594650.host, call_594650.base,
                         call_594650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594650, url, valid)

proc call*(call_594651: Call_ReplicationProtectedItemsFailoverCommit_594640;
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
  var path_594652 = newJObject()
  var query_594653 = newJObject()
  add(path_594652, "fabricName", newJString(fabricName))
  add(path_594652, "resourceGroupName", newJString(resourceGroupName))
  add(query_594653, "api-version", newJString(apiVersion))
  add(path_594652, "subscriptionId", newJString(subscriptionId))
  add(path_594652, "resourceName", newJString(resourceName))
  add(path_594652, "protectionContainerName", newJString(protectionContainerName))
  add(path_594652, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594651.call(path_594652, query_594653, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_594640(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_594641, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_594642,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_594654 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsPlannedFailover_594656(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_594655(path: JsonNode;
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
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594665: Call_ReplicationProtectedItemsPlannedFailover_594654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_594665.validator(path, query, header, formData, body)
  let scheme = call_594665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594665.url(scheme.get, call_594665.host, call_594665.base,
                         call_594665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594665, url, valid)

proc call*(call_594666: Call_ReplicationProtectedItemsPlannedFailover_594654;
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
  var path_594667 = newJObject()
  var query_594668 = newJObject()
  var body_594669 = newJObject()
  add(path_594667, "fabricName", newJString(fabricName))
  add(path_594667, "resourceGroupName", newJString(resourceGroupName))
  add(query_594668, "api-version", newJString(apiVersion))
  add(path_594667, "subscriptionId", newJString(subscriptionId))
  add(path_594667, "resourceName", newJString(resourceName))
  add(path_594667, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594669 = failoverInput
  add(path_594667, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594666.call(path_594667, query_594668, nil, nil, body_594669)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_594654(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_594655, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_594656,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_594670 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsReprotect_594672(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_594671(path: JsonNode;
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
  var valid_594673 = path.getOrDefault("fabricName")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "fabricName", valid_594673
  var valid_594674 = path.getOrDefault("resourceGroupName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "resourceGroupName", valid_594674
  var valid_594675 = path.getOrDefault("subscriptionId")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "subscriptionId", valid_594675
  var valid_594676 = path.getOrDefault("resourceName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "resourceName", valid_594676
  var valid_594677 = path.getOrDefault("protectionContainerName")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "protectionContainerName", valid_594677
  var valid_594678 = path.getOrDefault("replicatedProtectedItemName")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "replicatedProtectedItemName", valid_594678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594679 = query.getOrDefault("api-version")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "api-version", valid_594679
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

proc call*(call_594681: Call_ReplicationProtectedItemsReprotect_594670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_594681.validator(path, query, header, formData, body)
  let scheme = call_594681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594681.url(scheme.get, call_594681.host, call_594681.base,
                         call_594681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594681, url, valid)

proc call*(call_594682: Call_ReplicationProtectedItemsReprotect_594670;
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
  var path_594683 = newJObject()
  var query_594684 = newJObject()
  var body_594685 = newJObject()
  add(path_594683, "fabricName", newJString(fabricName))
  add(path_594683, "resourceGroupName", newJString(resourceGroupName))
  add(query_594684, "api-version", newJString(apiVersion))
  add(path_594683, "subscriptionId", newJString(subscriptionId))
  add(path_594683, "resourceName", newJString(resourceName))
  add(path_594683, "protectionContainerName", newJString(protectionContainerName))
  if rrInput != nil:
    body_594685 = rrInput
  add(path_594683, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594682.call(path_594683, query_594684, nil, nil, body_594685)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_594670(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_594671, base: "",
    url: url_ReplicationProtectedItemsReprotect_594672, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_594686 = ref object of OpenApiRestCall_593439
proc url_RecoveryPointsListByReplicationProtectedItems_594688(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_594687(
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
  var valid_594689 = path.getOrDefault("fabricName")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "fabricName", valid_594689
  var valid_594690 = path.getOrDefault("resourceGroupName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "resourceGroupName", valid_594690
  var valid_594691 = path.getOrDefault("subscriptionId")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "subscriptionId", valid_594691
  var valid_594692 = path.getOrDefault("resourceName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "resourceName", valid_594692
  var valid_594693 = path.getOrDefault("protectionContainerName")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "protectionContainerName", valid_594693
  var valid_594694 = path.getOrDefault("replicatedProtectedItemName")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "replicatedProtectedItemName", valid_594694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594695 = query.getOrDefault("api-version")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "api-version", valid_594695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594696: Call_RecoveryPointsListByReplicationProtectedItems_594686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_594696.validator(path, query, header, formData, body)
  let scheme = call_594696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594696.url(scheme.get, call_594696.host, call_594696.base,
                         call_594696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594696, url, valid)

proc call*(call_594697: Call_RecoveryPointsListByReplicationProtectedItems_594686;
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
  var path_594698 = newJObject()
  var query_594699 = newJObject()
  add(path_594698, "fabricName", newJString(fabricName))
  add(path_594698, "resourceGroupName", newJString(resourceGroupName))
  add(query_594699, "api-version", newJString(apiVersion))
  add(path_594698, "subscriptionId", newJString(subscriptionId))
  add(path_594698, "resourceName", newJString(resourceName))
  add(path_594698, "protectionContainerName", newJString(protectionContainerName))
  add(path_594698, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594697.call(path_594698, query_594699, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_594686(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_594687,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_594688,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_594700 = ref object of OpenApiRestCall_593439
proc url_RecoveryPointsGet_594702(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_594701(path: JsonNode; query: JsonNode;
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
  var valid_594703 = path.getOrDefault("fabricName")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "fabricName", valid_594703
  var valid_594704 = path.getOrDefault("resourceGroupName")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "resourceGroupName", valid_594704
  var valid_594705 = path.getOrDefault("subscriptionId")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "subscriptionId", valid_594705
  var valid_594706 = path.getOrDefault("resourceName")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "resourceName", valid_594706
  var valid_594707 = path.getOrDefault("recoveryPointName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "recoveryPointName", valid_594707
  var valid_594708 = path.getOrDefault("protectionContainerName")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "protectionContainerName", valid_594708
  var valid_594709 = path.getOrDefault("replicatedProtectedItemName")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "replicatedProtectedItemName", valid_594709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594710 = query.getOrDefault("api-version")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "api-version", valid_594710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594711: Call_RecoveryPointsGet_594700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_594711.validator(path, query, header, formData, body)
  let scheme = call_594711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594711.url(scheme.get, call_594711.host, call_594711.base,
                         call_594711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594711, url, valid)

proc call*(call_594712: Call_RecoveryPointsGet_594700; fabricName: string;
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
  var path_594713 = newJObject()
  var query_594714 = newJObject()
  add(path_594713, "fabricName", newJString(fabricName))
  add(path_594713, "resourceGroupName", newJString(resourceGroupName))
  add(query_594714, "api-version", newJString(apiVersion))
  add(path_594713, "subscriptionId", newJString(subscriptionId))
  add(path_594713, "resourceName", newJString(resourceName))
  add(path_594713, "recoveryPointName", newJString(recoveryPointName))
  add(path_594713, "protectionContainerName", newJString(protectionContainerName))
  add(path_594713, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594712.call(path_594713, query_594714, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_594700(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_594701, base: "",
    url: url_RecoveryPointsGet_594702, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_594715 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsDelete_594717(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_594716(path: JsonNode;
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
  var valid_594718 = path.getOrDefault("fabricName")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "fabricName", valid_594718
  var valid_594719 = path.getOrDefault("resourceGroupName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "resourceGroupName", valid_594719
  var valid_594720 = path.getOrDefault("subscriptionId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "subscriptionId", valid_594720
  var valid_594721 = path.getOrDefault("resourceName")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "resourceName", valid_594721
  var valid_594722 = path.getOrDefault("protectionContainerName")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "protectionContainerName", valid_594722
  var valid_594723 = path.getOrDefault("replicatedProtectedItemName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "replicatedProtectedItemName", valid_594723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594724 = query.getOrDefault("api-version")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "api-version", valid_594724
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

proc call*(call_594726: Call_ReplicationProtectedItemsDelete_594715;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_594726.validator(path, query, header, formData, body)
  let scheme = call_594726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594726.url(scheme.get, call_594726.host, call_594726.base,
                         call_594726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594726, url, valid)

proc call*(call_594727: Call_ReplicationProtectedItemsDelete_594715;
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
  var path_594728 = newJObject()
  var query_594729 = newJObject()
  var body_594730 = newJObject()
  add(path_594728, "fabricName", newJString(fabricName))
  add(path_594728, "resourceGroupName", newJString(resourceGroupName))
  add(query_594729, "api-version", newJString(apiVersion))
  add(path_594728, "subscriptionId", newJString(subscriptionId))
  add(path_594728, "resourceName", newJString(resourceName))
  add(path_594728, "protectionContainerName", newJString(protectionContainerName))
  if disableProtectionInput != nil:
    body_594730 = disableProtectionInput
  add(path_594728, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594727.call(path_594728, query_594729, nil, nil, body_594730)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_594715(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_594716, base: "",
    url: url_ReplicationProtectedItemsDelete_594717, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRemoveDisks_594731 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsRemoveDisks_594733(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/removeDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsRemoveDisks_594732(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove disk(s) from the replication protected item.
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
  var valid_594734 = path.getOrDefault("fabricName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "fabricName", valid_594734
  var valid_594735 = path.getOrDefault("resourceGroupName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "resourceGroupName", valid_594735
  var valid_594736 = path.getOrDefault("subscriptionId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "subscriptionId", valid_594736
  var valid_594737 = path.getOrDefault("resourceName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "resourceName", valid_594737
  var valid_594738 = path.getOrDefault("protectionContainerName")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "protectionContainerName", valid_594738
  var valid_594739 = path.getOrDefault("replicatedProtectedItemName")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "replicatedProtectedItemName", valid_594739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594740 = query.getOrDefault("api-version")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "api-version", valid_594740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removeDisksInput: JObject (required)
  ##                   : Remove disks input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594742: Call_ReplicationProtectedItemsRemoveDisks_594731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove disk(s) from the replication protected item.
  ## 
  let valid = call_594742.validator(path, query, header, formData, body)
  let scheme = call_594742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594742.url(scheme.get, call_594742.host, call_594742.base,
                         call_594742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594742, url, valid)

proc call*(call_594743: Call_ReplicationProtectedItemsRemoveDisks_594731;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; removeDisksInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsRemoveDisks
  ## Operation to remove disk(s) from the replication protected item.
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
  ##   removeDisksInput: JObject (required)
  ##                   : Remove disks input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_594744 = newJObject()
  var query_594745 = newJObject()
  var body_594746 = newJObject()
  add(path_594744, "fabricName", newJString(fabricName))
  add(path_594744, "resourceGroupName", newJString(resourceGroupName))
  add(query_594745, "api-version", newJString(apiVersion))
  add(path_594744, "subscriptionId", newJString(subscriptionId))
  add(path_594744, "resourceName", newJString(resourceName))
  add(path_594744, "protectionContainerName", newJString(protectionContainerName))
  if removeDisksInput != nil:
    body_594746 = removeDisksInput
  add(path_594744, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594743.call(path_594744, query_594745, nil, nil, body_594746)

var replicationProtectedItemsRemoveDisks* = Call_ReplicationProtectedItemsRemoveDisks_594731(
    name: "replicationProtectedItemsRemoveDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/removeDisks",
    validator: validate_ReplicationProtectedItemsRemoveDisks_594732, base: "",
    url: url_ReplicationProtectedItemsRemoveDisks_594733, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_594747 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsRepairReplication_594749(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_594748(path: JsonNode;
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
  var valid_594750 = path.getOrDefault("fabricName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "fabricName", valid_594750
  var valid_594751 = path.getOrDefault("resourceGroupName")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "resourceGroupName", valid_594751
  var valid_594752 = path.getOrDefault("subscriptionId")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "subscriptionId", valid_594752
  var valid_594753 = path.getOrDefault("resourceName")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "resourceName", valid_594753
  var valid_594754 = path.getOrDefault("protectionContainerName")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "protectionContainerName", valid_594754
  var valid_594755 = path.getOrDefault("replicatedProtectedItemName")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "replicatedProtectedItemName", valid_594755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594756 = query.getOrDefault("api-version")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "api-version", valid_594756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594757: Call_ReplicationProtectedItemsRepairReplication_594747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_594757.validator(path, query, header, formData, body)
  let scheme = call_594757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594757.url(scheme.get, call_594757.host, call_594757.base,
                         call_594757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594757, url, valid)

proc call*(call_594758: Call_ReplicationProtectedItemsRepairReplication_594747;
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
  var path_594759 = newJObject()
  var query_594760 = newJObject()
  add(path_594759, "fabricName", newJString(fabricName))
  add(path_594759, "resourceGroupName", newJString(resourceGroupName))
  add(query_594760, "api-version", newJString(apiVersion))
  add(path_594759, "subscriptionId", newJString(subscriptionId))
  add(path_594759, "resourceName", newJString(resourceName))
  add(path_594759, "protectionContainerName", newJString(protectionContainerName))
  add(path_594759, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594758.call(path_594759, query_594760, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_594747(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_594748,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_594749,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_594761 = ref object of OpenApiRestCall_593439
proc url_TargetComputeSizesListByReplicationProtectedItems_594763(
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

proc validate_TargetComputeSizesListByReplicationProtectedItems_594762(
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
  var valid_594764 = path.getOrDefault("fabricName")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "fabricName", valid_594764
  var valid_594765 = path.getOrDefault("resourceGroupName")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "resourceGroupName", valid_594765
  var valid_594766 = path.getOrDefault("subscriptionId")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "subscriptionId", valid_594766
  var valid_594767 = path.getOrDefault("resourceName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "resourceName", valid_594767
  var valid_594768 = path.getOrDefault("protectionContainerName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "protectionContainerName", valid_594768
  var valid_594769 = path.getOrDefault("replicatedProtectedItemName")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "replicatedProtectedItemName", valid_594769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594770 = query.getOrDefault("api-version")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "api-version", valid_594770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594771: Call_TargetComputeSizesListByReplicationProtectedItems_594761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_594771.validator(path, query, header, formData, body)
  let scheme = call_594771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594771.url(scheme.get, call_594771.host, call_594771.base,
                         call_594771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594771, url, valid)

proc call*(call_594772: Call_TargetComputeSizesListByReplicationProtectedItems_594761;
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
  var path_594773 = newJObject()
  var query_594774 = newJObject()
  add(path_594773, "fabricName", newJString(fabricName))
  add(path_594773, "resourceGroupName", newJString(resourceGroupName))
  add(query_594774, "api-version", newJString(apiVersion))
  add(path_594773, "subscriptionId", newJString(subscriptionId))
  add(path_594773, "resourceName", newJString(resourceName))
  add(path_594773, "protectionContainerName", newJString(protectionContainerName))
  add(path_594773, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594772.call(path_594773, query_594774, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_594761(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_594762,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_594763,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_594775 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsTestFailover_594777(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_594776(path: JsonNode;
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
  var valid_594783 = path.getOrDefault("replicatedProtectedItemName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "replicatedProtectedItemName", valid_594783
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
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594786: Call_ReplicationProtectedItemsTestFailover_594775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_594786.validator(path, query, header, formData, body)
  let scheme = call_594786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594786.url(scheme.get, call_594786.host, call_594786.base,
                         call_594786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594786, url, valid)

proc call*(call_594787: Call_ReplicationProtectedItemsTestFailover_594775;
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
  var path_594788 = newJObject()
  var query_594789 = newJObject()
  var body_594790 = newJObject()
  add(path_594788, "fabricName", newJString(fabricName))
  add(path_594788, "resourceGroupName", newJString(resourceGroupName))
  add(query_594789, "api-version", newJString(apiVersion))
  add(path_594788, "subscriptionId", newJString(subscriptionId))
  add(path_594788, "resourceName", newJString(resourceName))
  add(path_594788, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594790 = failoverInput
  add(path_594788, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594787.call(path_594788, query_594789, nil, nil, body_594790)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_594775(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_594776, base: "",
    url: url_ReplicationProtectedItemsTestFailover_594777, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_594791 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsTestFailoverCleanup_594793(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_594792(path: JsonNode;
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
  var valid_594799 = path.getOrDefault("replicatedProtectedItemName")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "replicatedProtectedItemName", valid_594799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594800 = query.getOrDefault("api-version")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "api-version", valid_594800
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

proc call*(call_594802: Call_ReplicationProtectedItemsTestFailoverCleanup_594791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_594802.validator(path, query, header, formData, body)
  let scheme = call_594802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594802.url(scheme.get, call_594802.host, call_594802.base,
                         call_594802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594802, url, valid)

proc call*(call_594803: Call_ReplicationProtectedItemsTestFailoverCleanup_594791;
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
  var path_594804 = newJObject()
  var query_594805 = newJObject()
  var body_594806 = newJObject()
  add(path_594804, "fabricName", newJString(fabricName))
  add(path_594804, "resourceGroupName", newJString(resourceGroupName))
  add(query_594805, "api-version", newJString(apiVersion))
  if cleanupInput != nil:
    body_594806 = cleanupInput
  add(path_594804, "subscriptionId", newJString(subscriptionId))
  add(path_594804, "resourceName", newJString(resourceName))
  add(path_594804, "protectionContainerName", newJString(protectionContainerName))
  add(path_594804, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594803.call(path_594804, query_594805, nil, nil, body_594806)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_594791(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_594792,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_594793,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_594807 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsUnplannedFailover_594809(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_594808(path: JsonNode;
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
  var valid_594810 = path.getOrDefault("fabricName")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "fabricName", valid_594810
  var valid_594811 = path.getOrDefault("resourceGroupName")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "resourceGroupName", valid_594811
  var valid_594812 = path.getOrDefault("subscriptionId")
  valid_594812 = validateParameter(valid_594812, JString, required = true,
                                 default = nil)
  if valid_594812 != nil:
    section.add "subscriptionId", valid_594812
  var valid_594813 = path.getOrDefault("resourceName")
  valid_594813 = validateParameter(valid_594813, JString, required = true,
                                 default = nil)
  if valid_594813 != nil:
    section.add "resourceName", valid_594813
  var valid_594814 = path.getOrDefault("protectionContainerName")
  valid_594814 = validateParameter(valid_594814, JString, required = true,
                                 default = nil)
  if valid_594814 != nil:
    section.add "protectionContainerName", valid_594814
  var valid_594815 = path.getOrDefault("replicatedProtectedItemName")
  valid_594815 = validateParameter(valid_594815, JString, required = true,
                                 default = nil)
  if valid_594815 != nil:
    section.add "replicatedProtectedItemName", valid_594815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594816 = query.getOrDefault("api-version")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "api-version", valid_594816
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

proc call*(call_594818: Call_ReplicationProtectedItemsUnplannedFailover_594807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_594818.validator(path, query, header, formData, body)
  let scheme = call_594818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594818.url(scheme.get, call_594818.host, call_594818.base,
                         call_594818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594818, url, valid)

proc call*(call_594819: Call_ReplicationProtectedItemsUnplannedFailover_594807;
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
  var path_594820 = newJObject()
  var query_594821 = newJObject()
  var body_594822 = newJObject()
  add(path_594820, "fabricName", newJString(fabricName))
  add(path_594820, "resourceGroupName", newJString(resourceGroupName))
  add(query_594821, "api-version", newJString(apiVersion))
  add(path_594820, "subscriptionId", newJString(subscriptionId))
  add(path_594820, "resourceName", newJString(resourceName))
  add(path_594820, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_594822 = failoverInput
  add(path_594820, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_594819.call(path_594820, query_594821, nil, nil, body_594822)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_594807(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_594808,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_594809,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_594823 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsUpdateMobilityService_594825(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_594824(
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
  var valid_594826 = path.getOrDefault("fabricName")
  valid_594826 = validateParameter(valid_594826, JString, required = true,
                                 default = nil)
  if valid_594826 != nil:
    section.add "fabricName", valid_594826
  var valid_594827 = path.getOrDefault("resourceGroupName")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "resourceGroupName", valid_594827
  var valid_594828 = path.getOrDefault("subscriptionId")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "subscriptionId", valid_594828
  var valid_594829 = path.getOrDefault("resourceName")
  valid_594829 = validateParameter(valid_594829, JString, required = true,
                                 default = nil)
  if valid_594829 != nil:
    section.add "resourceName", valid_594829
  var valid_594830 = path.getOrDefault("protectionContainerName")
  valid_594830 = validateParameter(valid_594830, JString, required = true,
                                 default = nil)
  if valid_594830 != nil:
    section.add "protectionContainerName", valid_594830
  var valid_594831 = path.getOrDefault("replicationProtectedItemName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "replicationProtectedItemName", valid_594831
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594832 = query.getOrDefault("api-version")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "api-version", valid_594832
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

proc call*(call_594834: Call_ReplicationProtectedItemsUpdateMobilityService_594823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_594834.validator(path, query, header, formData, body)
  let scheme = call_594834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594834.url(scheme.get, call_594834.host, call_594834.base,
                         call_594834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594834, url, valid)

proc call*(call_594835: Call_ReplicationProtectedItemsUpdateMobilityService_594823;
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
  var path_594836 = newJObject()
  var query_594837 = newJObject()
  var body_594838 = newJObject()
  add(path_594836, "fabricName", newJString(fabricName))
  add(path_594836, "resourceGroupName", newJString(resourceGroupName))
  add(query_594837, "api-version", newJString(apiVersion))
  if updateMobilityServiceRequest != nil:
    body_594838 = updateMobilityServiceRequest
  add(path_594836, "subscriptionId", newJString(subscriptionId))
  add(path_594836, "resourceName", newJString(resourceName))
  add(path_594836, "protectionContainerName", newJString(protectionContainerName))
  add(path_594836, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  result = call_594835.call(path_594836, query_594837, nil, nil, body_594838)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_594823(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_594824,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_594825,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594839 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594841(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594840(
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
  var valid_594842 = path.getOrDefault("fabricName")
  valid_594842 = validateParameter(valid_594842, JString, required = true,
                                 default = nil)
  if valid_594842 != nil:
    section.add "fabricName", valid_594842
  var valid_594843 = path.getOrDefault("resourceGroupName")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "resourceGroupName", valid_594843
  var valid_594844 = path.getOrDefault("subscriptionId")
  valid_594844 = validateParameter(valid_594844, JString, required = true,
                                 default = nil)
  if valid_594844 != nil:
    section.add "subscriptionId", valid_594844
  var valid_594845 = path.getOrDefault("resourceName")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "resourceName", valid_594845
  var valid_594846 = path.getOrDefault("protectionContainerName")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "protectionContainerName", valid_594846
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594847 = query.getOrDefault("api-version")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "api-version", valid_594847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594848: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594839;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_594848.validator(path, query, header, formData, body)
  let scheme = call_594848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594848.url(scheme.get, call_594848.host, call_594848.base,
                         call_594848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594848, url, valid)

proc call*(call_594849: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594839;
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
  var path_594850 = newJObject()
  var query_594851 = newJObject()
  add(path_594850, "fabricName", newJString(fabricName))
  add(path_594850, "resourceGroupName", newJString(resourceGroupName))
  add(query_594851, "api-version", newJString(apiVersion))
  add(path_594850, "subscriptionId", newJString(subscriptionId))
  add(path_594850, "resourceName", newJString(resourceName))
  add(path_594850, "protectionContainerName", newJString(protectionContainerName))
  result = call_594849.call(path_594850, query_594851, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594839(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594840,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_594841,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_594866 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsCreate_594868(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_594867(path: JsonNode;
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
  var valid_594869 = path.getOrDefault("fabricName")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "fabricName", valid_594869
  var valid_594870 = path.getOrDefault("resourceGroupName")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "resourceGroupName", valid_594870
  var valid_594871 = path.getOrDefault("mappingName")
  valid_594871 = validateParameter(valid_594871, JString, required = true,
                                 default = nil)
  if valid_594871 != nil:
    section.add "mappingName", valid_594871
  var valid_594872 = path.getOrDefault("subscriptionId")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = nil)
  if valid_594872 != nil:
    section.add "subscriptionId", valid_594872
  var valid_594873 = path.getOrDefault("resourceName")
  valid_594873 = validateParameter(valid_594873, JString, required = true,
                                 default = nil)
  if valid_594873 != nil:
    section.add "resourceName", valid_594873
  var valid_594874 = path.getOrDefault("protectionContainerName")
  valid_594874 = validateParameter(valid_594874, JString, required = true,
                                 default = nil)
  if valid_594874 != nil:
    section.add "protectionContainerName", valid_594874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594875 = query.getOrDefault("api-version")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "api-version", valid_594875
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

proc call*(call_594877: Call_ReplicationProtectionContainerMappingsCreate_594866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_594877.validator(path, query, header, formData, body)
  let scheme = call_594877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594877.url(scheme.get, call_594877.host, call_594877.base,
                         call_594877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594877, url, valid)

proc call*(call_594878: Call_ReplicationProtectionContainerMappingsCreate_594866;
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
  var path_594879 = newJObject()
  var query_594880 = newJObject()
  var body_594881 = newJObject()
  add(path_594879, "fabricName", newJString(fabricName))
  add(path_594879, "resourceGroupName", newJString(resourceGroupName))
  add(query_594880, "api-version", newJString(apiVersion))
  add(path_594879, "mappingName", newJString(mappingName))
  if creationInput != nil:
    body_594881 = creationInput
  add(path_594879, "subscriptionId", newJString(subscriptionId))
  add(path_594879, "resourceName", newJString(resourceName))
  add(path_594879, "protectionContainerName", newJString(protectionContainerName))
  result = call_594878.call(path_594879, query_594880, nil, nil, body_594881)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_594866(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_594867,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_594868,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_594852 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsGet_594854(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_594853(path: JsonNode;
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
  var valid_594855 = path.getOrDefault("fabricName")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "fabricName", valid_594855
  var valid_594856 = path.getOrDefault("resourceGroupName")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "resourceGroupName", valid_594856
  var valid_594857 = path.getOrDefault("mappingName")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "mappingName", valid_594857
  var valid_594858 = path.getOrDefault("subscriptionId")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "subscriptionId", valid_594858
  var valid_594859 = path.getOrDefault("resourceName")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "resourceName", valid_594859
  var valid_594860 = path.getOrDefault("protectionContainerName")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "protectionContainerName", valid_594860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594861 = query.getOrDefault("api-version")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "api-version", valid_594861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594862: Call_ReplicationProtectionContainerMappingsGet_594852;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_594862.validator(path, query, header, formData, body)
  let scheme = call_594862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594862.url(scheme.get, call_594862.host, call_594862.base,
                         call_594862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594862, url, valid)

proc call*(call_594863: Call_ReplicationProtectionContainerMappingsGet_594852;
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
  var path_594864 = newJObject()
  var query_594865 = newJObject()
  add(path_594864, "fabricName", newJString(fabricName))
  add(path_594864, "resourceGroupName", newJString(resourceGroupName))
  add(query_594865, "api-version", newJString(apiVersion))
  add(path_594864, "mappingName", newJString(mappingName))
  add(path_594864, "subscriptionId", newJString(subscriptionId))
  add(path_594864, "resourceName", newJString(resourceName))
  add(path_594864, "protectionContainerName", newJString(protectionContainerName))
  result = call_594863.call(path_594864, query_594865, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_594852(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_594853,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_594854,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_594896 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsUpdate_594898(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsUpdate_594897(path: JsonNode;
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
  var valid_594899 = path.getOrDefault("fabricName")
  valid_594899 = validateParameter(valid_594899, JString, required = true,
                                 default = nil)
  if valid_594899 != nil:
    section.add "fabricName", valid_594899
  var valid_594900 = path.getOrDefault("resourceGroupName")
  valid_594900 = validateParameter(valid_594900, JString, required = true,
                                 default = nil)
  if valid_594900 != nil:
    section.add "resourceGroupName", valid_594900
  var valid_594901 = path.getOrDefault("mappingName")
  valid_594901 = validateParameter(valid_594901, JString, required = true,
                                 default = nil)
  if valid_594901 != nil:
    section.add "mappingName", valid_594901
  var valid_594902 = path.getOrDefault("subscriptionId")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "subscriptionId", valid_594902
  var valid_594903 = path.getOrDefault("resourceName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "resourceName", valid_594903
  var valid_594904 = path.getOrDefault("protectionContainerName")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "protectionContainerName", valid_594904
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594905 = query.getOrDefault("api-version")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "api-version", valid_594905
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

proc call*(call_594907: Call_ReplicationProtectionContainerMappingsUpdate_594896;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_594907.validator(path, query, header, formData, body)
  let scheme = call_594907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594907.url(scheme.get, call_594907.host, call_594907.base,
                         call_594907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594907, url, valid)

proc call*(call_594908: Call_ReplicationProtectionContainerMappingsUpdate_594896;
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
  var path_594909 = newJObject()
  var query_594910 = newJObject()
  var body_594911 = newJObject()
  add(path_594909, "fabricName", newJString(fabricName))
  add(path_594909, "resourceGroupName", newJString(resourceGroupName))
  add(query_594910, "api-version", newJString(apiVersion))
  add(path_594909, "mappingName", newJString(mappingName))
  add(path_594909, "subscriptionId", newJString(subscriptionId))
  if updateInput != nil:
    body_594911 = updateInput
  add(path_594909, "resourceName", newJString(resourceName))
  add(path_594909, "protectionContainerName", newJString(protectionContainerName))
  result = call_594908.call(path_594909, query_594910, nil, nil, body_594911)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_594896(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_594897,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_594898,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_594882 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsPurge_594884(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_594883(path: JsonNode;
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
  var valid_594885 = path.getOrDefault("fabricName")
  valid_594885 = validateParameter(valid_594885, JString, required = true,
                                 default = nil)
  if valid_594885 != nil:
    section.add "fabricName", valid_594885
  var valid_594886 = path.getOrDefault("resourceGroupName")
  valid_594886 = validateParameter(valid_594886, JString, required = true,
                                 default = nil)
  if valid_594886 != nil:
    section.add "resourceGroupName", valid_594886
  var valid_594887 = path.getOrDefault("mappingName")
  valid_594887 = validateParameter(valid_594887, JString, required = true,
                                 default = nil)
  if valid_594887 != nil:
    section.add "mappingName", valid_594887
  var valid_594888 = path.getOrDefault("subscriptionId")
  valid_594888 = validateParameter(valid_594888, JString, required = true,
                                 default = nil)
  if valid_594888 != nil:
    section.add "subscriptionId", valid_594888
  var valid_594889 = path.getOrDefault("resourceName")
  valid_594889 = validateParameter(valid_594889, JString, required = true,
                                 default = nil)
  if valid_594889 != nil:
    section.add "resourceName", valid_594889
  var valid_594890 = path.getOrDefault("protectionContainerName")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "protectionContainerName", valid_594890
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594891 = query.getOrDefault("api-version")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "api-version", valid_594891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594892: Call_ReplicationProtectionContainerMappingsPurge_594882;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_594892.validator(path, query, header, formData, body)
  let scheme = call_594892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594892.url(scheme.get, call_594892.host, call_594892.base,
                         call_594892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594892, url, valid)

proc call*(call_594893: Call_ReplicationProtectionContainerMappingsPurge_594882;
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
  var path_594894 = newJObject()
  var query_594895 = newJObject()
  add(path_594894, "fabricName", newJString(fabricName))
  add(path_594894, "resourceGroupName", newJString(resourceGroupName))
  add(query_594895, "api-version", newJString(apiVersion))
  add(path_594894, "mappingName", newJString(mappingName))
  add(path_594894, "subscriptionId", newJString(subscriptionId))
  add(path_594894, "resourceName", newJString(resourceName))
  add(path_594894, "protectionContainerName", newJString(protectionContainerName))
  result = call_594893.call(path_594894, query_594895, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_594882(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_594883,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_594884,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_594912 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsDelete_594914(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_594913(path: JsonNode;
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
  var valid_594915 = path.getOrDefault("fabricName")
  valid_594915 = validateParameter(valid_594915, JString, required = true,
                                 default = nil)
  if valid_594915 != nil:
    section.add "fabricName", valid_594915
  var valid_594916 = path.getOrDefault("resourceGroupName")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "resourceGroupName", valid_594916
  var valid_594917 = path.getOrDefault("mappingName")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "mappingName", valid_594917
  var valid_594918 = path.getOrDefault("subscriptionId")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "subscriptionId", valid_594918
  var valid_594919 = path.getOrDefault("resourceName")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "resourceName", valid_594919
  var valid_594920 = path.getOrDefault("protectionContainerName")
  valid_594920 = validateParameter(valid_594920, JString, required = true,
                                 default = nil)
  if valid_594920 != nil:
    section.add "protectionContainerName", valid_594920
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594921 = query.getOrDefault("api-version")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "api-version", valid_594921
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

proc call*(call_594923: Call_ReplicationProtectionContainerMappingsDelete_594912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_594923.validator(path, query, header, formData, body)
  let scheme = call_594923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594923.url(scheme.get, call_594923.host, call_594923.base,
                         call_594923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594923, url, valid)

proc call*(call_594924: Call_ReplicationProtectionContainerMappingsDelete_594912;
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
  var path_594925 = newJObject()
  var query_594926 = newJObject()
  var body_594927 = newJObject()
  add(path_594925, "fabricName", newJString(fabricName))
  add(path_594925, "resourceGroupName", newJString(resourceGroupName))
  add(query_594926, "api-version", newJString(apiVersion))
  add(path_594925, "mappingName", newJString(mappingName))
  add(path_594925, "subscriptionId", newJString(subscriptionId))
  add(path_594925, "resourceName", newJString(resourceName))
  add(path_594925, "protectionContainerName", newJString(protectionContainerName))
  if removalInput != nil:
    body_594927 = removalInput
  result = call_594924.call(path_594925, query_594926, nil, nil, body_594927)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_594912(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_594913,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_594914,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_594928 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersSwitchProtection_594930(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_594929(
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
  var valid_594931 = path.getOrDefault("fabricName")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = nil)
  if valid_594931 != nil:
    section.add "fabricName", valid_594931
  var valid_594932 = path.getOrDefault("resourceGroupName")
  valid_594932 = validateParameter(valid_594932, JString, required = true,
                                 default = nil)
  if valid_594932 != nil:
    section.add "resourceGroupName", valid_594932
  var valid_594933 = path.getOrDefault("subscriptionId")
  valid_594933 = validateParameter(valid_594933, JString, required = true,
                                 default = nil)
  if valid_594933 != nil:
    section.add "subscriptionId", valid_594933
  var valid_594934 = path.getOrDefault("resourceName")
  valid_594934 = validateParameter(valid_594934, JString, required = true,
                                 default = nil)
  if valid_594934 != nil:
    section.add "resourceName", valid_594934
  var valid_594935 = path.getOrDefault("protectionContainerName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "protectionContainerName", valid_594935
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594936 = query.getOrDefault("api-version")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "api-version", valid_594936
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

proc call*(call_594938: Call_ReplicationProtectionContainersSwitchProtection_594928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_594938.validator(path, query, header, formData, body)
  let scheme = call_594938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594938.url(scheme.get, call_594938.host, call_594938.base,
                         call_594938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594938, url, valid)

proc call*(call_594939: Call_ReplicationProtectionContainersSwitchProtection_594928;
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
  var path_594940 = newJObject()
  var query_594941 = newJObject()
  var body_594942 = newJObject()
  add(path_594940, "fabricName", newJString(fabricName))
  add(path_594940, "resourceGroupName", newJString(resourceGroupName))
  add(query_594941, "api-version", newJString(apiVersion))
  add(path_594940, "subscriptionId", newJString(subscriptionId))
  add(path_594940, "resourceName", newJString(resourceName))
  add(path_594940, "protectionContainerName", newJString(protectionContainerName))
  if switchInput != nil:
    body_594942 = switchInput
  result = call_594939.call(path_594940, query_594941, nil, nil, body_594942)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_594928(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_594929,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_594930,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594943 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594945(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594944(
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
  var valid_594946 = path.getOrDefault("fabricName")
  valid_594946 = validateParameter(valid_594946, JString, required = true,
                                 default = nil)
  if valid_594946 != nil:
    section.add "fabricName", valid_594946
  var valid_594947 = path.getOrDefault("resourceGroupName")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "resourceGroupName", valid_594947
  var valid_594948 = path.getOrDefault("subscriptionId")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "subscriptionId", valid_594948
  var valid_594949 = path.getOrDefault("resourceName")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "resourceName", valid_594949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594950 = query.getOrDefault("api-version")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "api-version", valid_594950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594951: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_594951.validator(path, query, header, formData, body)
  let scheme = call_594951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594951.url(scheme.get, call_594951.host, call_594951.base,
                         call_594951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594951, url, valid)

proc call*(call_594952: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594943;
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
  var path_594953 = newJObject()
  var query_594954 = newJObject()
  add(path_594953, "fabricName", newJString(fabricName))
  add(path_594953, "resourceGroupName", newJString(resourceGroupName))
  add(query_594954, "api-version", newJString(apiVersion))
  add(path_594953, "subscriptionId", newJString(subscriptionId))
  add(path_594953, "resourceName", newJString(resourceName))
  result = call_594952.call(path_594953, query_594954, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594943(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594944,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_594945,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_594968 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersCreate_594970(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersCreate_594969(path: JsonNode;
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
  var valid_594971 = path.getOrDefault("fabricName")
  valid_594971 = validateParameter(valid_594971, JString, required = true,
                                 default = nil)
  if valid_594971 != nil:
    section.add "fabricName", valid_594971
  var valid_594972 = path.getOrDefault("resourceGroupName")
  valid_594972 = validateParameter(valid_594972, JString, required = true,
                                 default = nil)
  if valid_594972 != nil:
    section.add "resourceGroupName", valid_594972
  var valid_594973 = path.getOrDefault("subscriptionId")
  valid_594973 = validateParameter(valid_594973, JString, required = true,
                                 default = nil)
  if valid_594973 != nil:
    section.add "subscriptionId", valid_594973
  var valid_594974 = path.getOrDefault("resourceName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "resourceName", valid_594974
  var valid_594975 = path.getOrDefault("providerName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "providerName", valid_594975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594976 = query.getOrDefault("api-version")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "api-version", valid_594976
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

proc call*(call_594978: Call_ReplicationRecoveryServicesProvidersCreate_594968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_ReplicationRecoveryServicesProvidersCreate_594968;
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
  var path_594980 = newJObject()
  var query_594981 = newJObject()
  var body_594982 = newJObject()
  add(path_594980, "fabricName", newJString(fabricName))
  add(path_594980, "resourceGroupName", newJString(resourceGroupName))
  add(query_594981, "api-version", newJString(apiVersion))
  if addProviderInput != nil:
    body_594982 = addProviderInput
  add(path_594980, "subscriptionId", newJString(subscriptionId))
  add(path_594980, "resourceName", newJString(resourceName))
  add(path_594980, "providerName", newJString(providerName))
  result = call_594979.call(path_594980, query_594981, nil, nil, body_594982)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_594968(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_594969,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_594970,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_594955 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersGet_594957(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_594956(path: JsonNode;
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
  var valid_594958 = path.getOrDefault("fabricName")
  valid_594958 = validateParameter(valid_594958, JString, required = true,
                                 default = nil)
  if valid_594958 != nil:
    section.add "fabricName", valid_594958
  var valid_594959 = path.getOrDefault("resourceGroupName")
  valid_594959 = validateParameter(valid_594959, JString, required = true,
                                 default = nil)
  if valid_594959 != nil:
    section.add "resourceGroupName", valid_594959
  var valid_594960 = path.getOrDefault("subscriptionId")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "subscriptionId", valid_594960
  var valid_594961 = path.getOrDefault("resourceName")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "resourceName", valid_594961
  var valid_594962 = path.getOrDefault("providerName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "providerName", valid_594962
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594963 = query.getOrDefault("api-version")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "api-version", valid_594963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594964: Call_ReplicationRecoveryServicesProvidersGet_594955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_594964.validator(path, query, header, formData, body)
  let scheme = call_594964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594964.url(scheme.get, call_594964.host, call_594964.base,
                         call_594964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594964, url, valid)

proc call*(call_594965: Call_ReplicationRecoveryServicesProvidersGet_594955;
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
  var path_594966 = newJObject()
  var query_594967 = newJObject()
  add(path_594966, "fabricName", newJString(fabricName))
  add(path_594966, "resourceGroupName", newJString(resourceGroupName))
  add(query_594967, "api-version", newJString(apiVersion))
  add(path_594966, "subscriptionId", newJString(subscriptionId))
  add(path_594966, "resourceName", newJString(resourceName))
  add(path_594966, "providerName", newJString(providerName))
  result = call_594965.call(path_594966, query_594967, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_594955(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_594956, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_594957,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_594983 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersPurge_594985(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_594984(path: JsonNode;
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
  var valid_594986 = path.getOrDefault("fabricName")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "fabricName", valid_594986
  var valid_594987 = path.getOrDefault("resourceGroupName")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "resourceGroupName", valid_594987
  var valid_594988 = path.getOrDefault("subscriptionId")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "subscriptionId", valid_594988
  var valid_594989 = path.getOrDefault("resourceName")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "resourceName", valid_594989
  var valid_594990 = path.getOrDefault("providerName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "providerName", valid_594990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594991 = query.getOrDefault("api-version")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "api-version", valid_594991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594992: Call_ReplicationRecoveryServicesProvidersPurge_594983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_594992.validator(path, query, header, formData, body)
  let scheme = call_594992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594992.url(scheme.get, call_594992.host, call_594992.base,
                         call_594992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594992, url, valid)

proc call*(call_594993: Call_ReplicationRecoveryServicesProvidersPurge_594983;
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
  var path_594994 = newJObject()
  var query_594995 = newJObject()
  add(path_594994, "fabricName", newJString(fabricName))
  add(path_594994, "resourceGroupName", newJString(resourceGroupName))
  add(query_594995, "api-version", newJString(apiVersion))
  add(path_594994, "subscriptionId", newJString(subscriptionId))
  add(path_594994, "resourceName", newJString(resourceName))
  add(path_594994, "providerName", newJString(providerName))
  result = call_594993.call(path_594994, query_594995, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_594983(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_594984,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_594985,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_594996 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_594998(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_594997(
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
  var valid_594999 = path.getOrDefault("fabricName")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = nil)
  if valid_594999 != nil:
    section.add "fabricName", valid_594999
  var valid_595000 = path.getOrDefault("resourceGroupName")
  valid_595000 = validateParameter(valid_595000, JString, required = true,
                                 default = nil)
  if valid_595000 != nil:
    section.add "resourceGroupName", valid_595000
  var valid_595001 = path.getOrDefault("subscriptionId")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "subscriptionId", valid_595001
  var valid_595002 = path.getOrDefault("resourceName")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "resourceName", valid_595002
  var valid_595003 = path.getOrDefault("providerName")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "providerName", valid_595003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595004 = query.getOrDefault("api-version")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "api-version", valid_595004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595005: Call_ReplicationRecoveryServicesProvidersRefreshProvider_594996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_595005.validator(path, query, header, formData, body)
  let scheme = call_595005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595005.url(scheme.get, call_595005.host, call_595005.base,
                         call_595005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595005, url, valid)

proc call*(call_595006: Call_ReplicationRecoveryServicesProvidersRefreshProvider_594996;
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
  var path_595007 = newJObject()
  var query_595008 = newJObject()
  add(path_595007, "fabricName", newJString(fabricName))
  add(path_595007, "resourceGroupName", newJString(resourceGroupName))
  add(query_595008, "api-version", newJString(apiVersion))
  add(path_595007, "subscriptionId", newJString(subscriptionId))
  add(path_595007, "resourceName", newJString(resourceName))
  add(path_595007, "providerName", newJString(providerName))
  result = call_595006.call(path_595007, query_595008, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_594996(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_594997,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_594998,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_595009 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersDelete_595011(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_595010(path: JsonNode;
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
  var valid_595012 = path.getOrDefault("fabricName")
  valid_595012 = validateParameter(valid_595012, JString, required = true,
                                 default = nil)
  if valid_595012 != nil:
    section.add "fabricName", valid_595012
  var valid_595013 = path.getOrDefault("resourceGroupName")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = nil)
  if valid_595013 != nil:
    section.add "resourceGroupName", valid_595013
  var valid_595014 = path.getOrDefault("subscriptionId")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "subscriptionId", valid_595014
  var valid_595015 = path.getOrDefault("resourceName")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "resourceName", valid_595015
  var valid_595016 = path.getOrDefault("providerName")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "providerName", valid_595016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595017 = query.getOrDefault("api-version")
  valid_595017 = validateParameter(valid_595017, JString, required = true,
                                 default = nil)
  if valid_595017 != nil:
    section.add "api-version", valid_595017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595018: Call_ReplicationRecoveryServicesProvidersDelete_595009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_595018.validator(path, query, header, formData, body)
  let scheme = call_595018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595018.url(scheme.get, call_595018.host, call_595018.base,
                         call_595018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595018, url, valid)

proc call*(call_595019: Call_ReplicationRecoveryServicesProvidersDelete_595009;
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
  var path_595020 = newJObject()
  var query_595021 = newJObject()
  add(path_595020, "fabricName", newJString(fabricName))
  add(path_595020, "resourceGroupName", newJString(resourceGroupName))
  add(query_595021, "api-version", newJString(apiVersion))
  add(path_595020, "subscriptionId", newJString(subscriptionId))
  add(path_595020, "resourceName", newJString(resourceName))
  add(path_595020, "providerName", newJString(providerName))
  result = call_595019.call(path_595020, query_595021, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_595009(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_595010,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_595011,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_595022 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsListByReplicationFabrics_595024(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_595023(
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
  var valid_595025 = path.getOrDefault("fabricName")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = nil)
  if valid_595025 != nil:
    section.add "fabricName", valid_595025
  var valid_595026 = path.getOrDefault("resourceGroupName")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "resourceGroupName", valid_595026
  var valid_595027 = path.getOrDefault("subscriptionId")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "subscriptionId", valid_595027
  var valid_595028 = path.getOrDefault("resourceName")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "resourceName", valid_595028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595029 = query.getOrDefault("api-version")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "api-version", valid_595029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595030: Call_ReplicationStorageClassificationsListByReplicationFabrics_595022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_595030.validator(path, query, header, formData, body)
  let scheme = call_595030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595030.url(scheme.get, call_595030.host, call_595030.base,
                         call_595030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595030, url, valid)

proc call*(call_595031: Call_ReplicationStorageClassificationsListByReplicationFabrics_595022;
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
  var path_595032 = newJObject()
  var query_595033 = newJObject()
  add(path_595032, "fabricName", newJString(fabricName))
  add(path_595032, "resourceGroupName", newJString(resourceGroupName))
  add(query_595033, "api-version", newJString(apiVersion))
  add(path_595032, "subscriptionId", newJString(subscriptionId))
  add(path_595032, "resourceName", newJString(resourceName))
  result = call_595031.call(path_595032, query_595033, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_595022(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_595023,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_595024,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_595034 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsGet_595036(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_595035(path: JsonNode;
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
  var valid_595037 = path.getOrDefault("fabricName")
  valid_595037 = validateParameter(valid_595037, JString, required = true,
                                 default = nil)
  if valid_595037 != nil:
    section.add "fabricName", valid_595037
  var valid_595038 = path.getOrDefault("resourceGroupName")
  valid_595038 = validateParameter(valid_595038, JString, required = true,
                                 default = nil)
  if valid_595038 != nil:
    section.add "resourceGroupName", valid_595038
  var valid_595039 = path.getOrDefault("subscriptionId")
  valid_595039 = validateParameter(valid_595039, JString, required = true,
                                 default = nil)
  if valid_595039 != nil:
    section.add "subscriptionId", valid_595039
  var valid_595040 = path.getOrDefault("resourceName")
  valid_595040 = validateParameter(valid_595040, JString, required = true,
                                 default = nil)
  if valid_595040 != nil:
    section.add "resourceName", valid_595040
  var valid_595041 = path.getOrDefault("storageClassificationName")
  valid_595041 = validateParameter(valid_595041, JString, required = true,
                                 default = nil)
  if valid_595041 != nil:
    section.add "storageClassificationName", valid_595041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595042 = query.getOrDefault("api-version")
  valid_595042 = validateParameter(valid_595042, JString, required = true,
                                 default = nil)
  if valid_595042 != nil:
    section.add "api-version", valid_595042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595043: Call_ReplicationStorageClassificationsGet_595034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_595043.validator(path, query, header, formData, body)
  let scheme = call_595043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595043.url(scheme.get, call_595043.host, call_595043.base,
                         call_595043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595043, url, valid)

proc call*(call_595044: Call_ReplicationStorageClassificationsGet_595034;
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
  var path_595045 = newJObject()
  var query_595046 = newJObject()
  add(path_595045, "fabricName", newJString(fabricName))
  add(path_595045, "resourceGroupName", newJString(resourceGroupName))
  add(query_595046, "api-version", newJString(apiVersion))
  add(path_595045, "subscriptionId", newJString(subscriptionId))
  add(path_595045, "resourceName", newJString(resourceName))
  add(path_595045, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595044.call(path_595045, query_595046, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_595034(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_595035, base: "",
    url: url_ReplicationStorageClassificationsGet_595036, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595047 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595049(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595048(
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
  var valid_595050 = path.getOrDefault("fabricName")
  valid_595050 = validateParameter(valid_595050, JString, required = true,
                                 default = nil)
  if valid_595050 != nil:
    section.add "fabricName", valid_595050
  var valid_595051 = path.getOrDefault("resourceGroupName")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "resourceGroupName", valid_595051
  var valid_595052 = path.getOrDefault("subscriptionId")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = nil)
  if valid_595052 != nil:
    section.add "subscriptionId", valid_595052
  var valid_595053 = path.getOrDefault("resourceName")
  valid_595053 = validateParameter(valid_595053, JString, required = true,
                                 default = nil)
  if valid_595053 != nil:
    section.add "resourceName", valid_595053
  var valid_595054 = path.getOrDefault("storageClassificationName")
  valid_595054 = validateParameter(valid_595054, JString, required = true,
                                 default = nil)
  if valid_595054 != nil:
    section.add "storageClassificationName", valid_595054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595055 = query.getOrDefault("api-version")
  valid_595055 = validateParameter(valid_595055, JString, required = true,
                                 default = nil)
  if valid_595055 != nil:
    section.add "api-version", valid_595055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595056: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_595056.validator(path, query, header, formData, body)
  let scheme = call_595056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595056.url(scheme.get, call_595056.host, call_595056.base,
                         call_595056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595056, url, valid)

proc call*(call_595057: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595047;
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
  var path_595058 = newJObject()
  var query_595059 = newJObject()
  add(path_595058, "fabricName", newJString(fabricName))
  add(path_595058, "resourceGroupName", newJString(resourceGroupName))
  add(query_595059, "api-version", newJString(apiVersion))
  add(path_595058, "subscriptionId", newJString(subscriptionId))
  add(path_595058, "resourceName", newJString(resourceName))
  add(path_595058, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595057.call(path_595058, query_595059, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595047(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595048,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_595049,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_595074 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsCreate_595076(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_595075(
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
  var valid_595077 = path.getOrDefault("fabricName")
  valid_595077 = validateParameter(valid_595077, JString, required = true,
                                 default = nil)
  if valid_595077 != nil:
    section.add "fabricName", valid_595077
  var valid_595078 = path.getOrDefault("resourceGroupName")
  valid_595078 = validateParameter(valid_595078, JString, required = true,
                                 default = nil)
  if valid_595078 != nil:
    section.add "resourceGroupName", valid_595078
  var valid_595079 = path.getOrDefault("storageClassificationMappingName")
  valid_595079 = validateParameter(valid_595079, JString, required = true,
                                 default = nil)
  if valid_595079 != nil:
    section.add "storageClassificationMappingName", valid_595079
  var valid_595080 = path.getOrDefault("subscriptionId")
  valid_595080 = validateParameter(valid_595080, JString, required = true,
                                 default = nil)
  if valid_595080 != nil:
    section.add "subscriptionId", valid_595080
  var valid_595081 = path.getOrDefault("resourceName")
  valid_595081 = validateParameter(valid_595081, JString, required = true,
                                 default = nil)
  if valid_595081 != nil:
    section.add "resourceName", valid_595081
  var valid_595082 = path.getOrDefault("storageClassificationName")
  valid_595082 = validateParameter(valid_595082, JString, required = true,
                                 default = nil)
  if valid_595082 != nil:
    section.add "storageClassificationName", valid_595082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595083 = query.getOrDefault("api-version")
  valid_595083 = validateParameter(valid_595083, JString, required = true,
                                 default = nil)
  if valid_595083 != nil:
    section.add "api-version", valid_595083
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

proc call*(call_595085: Call_ReplicationStorageClassificationMappingsCreate_595074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_595085.validator(path, query, header, formData, body)
  let scheme = call_595085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595085.url(scheme.get, call_595085.host, call_595085.base,
                         call_595085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595085, url, valid)

proc call*(call_595086: Call_ReplicationStorageClassificationMappingsCreate_595074;
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
  var path_595087 = newJObject()
  var query_595088 = newJObject()
  var body_595089 = newJObject()
  add(path_595087, "fabricName", newJString(fabricName))
  add(path_595087, "resourceGroupName", newJString(resourceGroupName))
  add(query_595088, "api-version", newJString(apiVersion))
  add(path_595087, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  if pairingInput != nil:
    body_595089 = pairingInput
  add(path_595087, "subscriptionId", newJString(subscriptionId))
  add(path_595087, "resourceName", newJString(resourceName))
  add(path_595087, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595086.call(path_595087, query_595088, nil, nil, body_595089)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_595074(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_595075,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_595076,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_595060 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsGet_595062(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_595061(path: JsonNode;
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
  var valid_595063 = path.getOrDefault("fabricName")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "fabricName", valid_595063
  var valid_595064 = path.getOrDefault("resourceGroupName")
  valid_595064 = validateParameter(valid_595064, JString, required = true,
                                 default = nil)
  if valid_595064 != nil:
    section.add "resourceGroupName", valid_595064
  var valid_595065 = path.getOrDefault("storageClassificationMappingName")
  valid_595065 = validateParameter(valid_595065, JString, required = true,
                                 default = nil)
  if valid_595065 != nil:
    section.add "storageClassificationMappingName", valid_595065
  var valid_595066 = path.getOrDefault("subscriptionId")
  valid_595066 = validateParameter(valid_595066, JString, required = true,
                                 default = nil)
  if valid_595066 != nil:
    section.add "subscriptionId", valid_595066
  var valid_595067 = path.getOrDefault("resourceName")
  valid_595067 = validateParameter(valid_595067, JString, required = true,
                                 default = nil)
  if valid_595067 != nil:
    section.add "resourceName", valid_595067
  var valid_595068 = path.getOrDefault("storageClassificationName")
  valid_595068 = validateParameter(valid_595068, JString, required = true,
                                 default = nil)
  if valid_595068 != nil:
    section.add "storageClassificationName", valid_595068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595069 = query.getOrDefault("api-version")
  valid_595069 = validateParameter(valid_595069, JString, required = true,
                                 default = nil)
  if valid_595069 != nil:
    section.add "api-version", valid_595069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595070: Call_ReplicationStorageClassificationMappingsGet_595060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_595070.validator(path, query, header, formData, body)
  let scheme = call_595070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595070.url(scheme.get, call_595070.host, call_595070.base,
                         call_595070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595070, url, valid)

proc call*(call_595071: Call_ReplicationStorageClassificationMappingsGet_595060;
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
  var path_595072 = newJObject()
  var query_595073 = newJObject()
  add(path_595072, "fabricName", newJString(fabricName))
  add(path_595072, "resourceGroupName", newJString(resourceGroupName))
  add(query_595073, "api-version", newJString(apiVersion))
  add(path_595072, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_595072, "subscriptionId", newJString(subscriptionId))
  add(path_595072, "resourceName", newJString(resourceName))
  add(path_595072, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595071.call(path_595072, query_595073, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_595060(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_595061,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_595062,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_595090 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsDelete_595092(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_595091(
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
  var valid_595093 = path.getOrDefault("fabricName")
  valid_595093 = validateParameter(valid_595093, JString, required = true,
                                 default = nil)
  if valid_595093 != nil:
    section.add "fabricName", valid_595093
  var valid_595094 = path.getOrDefault("resourceGroupName")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "resourceGroupName", valid_595094
  var valid_595095 = path.getOrDefault("storageClassificationMappingName")
  valid_595095 = validateParameter(valid_595095, JString, required = true,
                                 default = nil)
  if valid_595095 != nil:
    section.add "storageClassificationMappingName", valid_595095
  var valid_595096 = path.getOrDefault("subscriptionId")
  valid_595096 = validateParameter(valid_595096, JString, required = true,
                                 default = nil)
  if valid_595096 != nil:
    section.add "subscriptionId", valid_595096
  var valid_595097 = path.getOrDefault("resourceName")
  valid_595097 = validateParameter(valid_595097, JString, required = true,
                                 default = nil)
  if valid_595097 != nil:
    section.add "resourceName", valid_595097
  var valid_595098 = path.getOrDefault("storageClassificationName")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "storageClassificationName", valid_595098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595099 = query.getOrDefault("api-version")
  valid_595099 = validateParameter(valid_595099, JString, required = true,
                                 default = nil)
  if valid_595099 != nil:
    section.add "api-version", valid_595099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595100: Call_ReplicationStorageClassificationMappingsDelete_595090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_595100.validator(path, query, header, formData, body)
  let scheme = call_595100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595100.url(scheme.get, call_595100.host, call_595100.base,
                         call_595100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595100, url, valid)

proc call*(call_595101: Call_ReplicationStorageClassificationMappingsDelete_595090;
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
  var path_595102 = newJObject()
  var query_595103 = newJObject()
  add(path_595102, "fabricName", newJString(fabricName))
  add(path_595102, "resourceGroupName", newJString(resourceGroupName))
  add(query_595103, "api-version", newJString(apiVersion))
  add(path_595102, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_595102, "subscriptionId", newJString(subscriptionId))
  add(path_595102, "resourceName", newJString(resourceName))
  add(path_595102, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_595101.call(path_595102, query_595103, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_595090(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_595091,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_595092,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_595104 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersListByReplicationFabrics_595106(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_595105(path: JsonNode;
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
  var valid_595107 = path.getOrDefault("fabricName")
  valid_595107 = validateParameter(valid_595107, JString, required = true,
                                 default = nil)
  if valid_595107 != nil:
    section.add "fabricName", valid_595107
  var valid_595108 = path.getOrDefault("resourceGroupName")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "resourceGroupName", valid_595108
  var valid_595109 = path.getOrDefault("subscriptionId")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "subscriptionId", valid_595109
  var valid_595110 = path.getOrDefault("resourceName")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = nil)
  if valid_595110 != nil:
    section.add "resourceName", valid_595110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595111 = query.getOrDefault("api-version")
  valid_595111 = validateParameter(valid_595111, JString, required = true,
                                 default = nil)
  if valid_595111 != nil:
    section.add "api-version", valid_595111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595112: Call_ReplicationvCentersListByReplicationFabrics_595104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_595112.validator(path, query, header, formData, body)
  let scheme = call_595112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595112.url(scheme.get, call_595112.host, call_595112.base,
                         call_595112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595112, url, valid)

proc call*(call_595113: Call_ReplicationvCentersListByReplicationFabrics_595104;
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
  var path_595114 = newJObject()
  var query_595115 = newJObject()
  add(path_595114, "fabricName", newJString(fabricName))
  add(path_595114, "resourceGroupName", newJString(resourceGroupName))
  add(query_595115, "api-version", newJString(apiVersion))
  add(path_595114, "subscriptionId", newJString(subscriptionId))
  add(path_595114, "resourceName", newJString(resourceName))
  result = call_595113.call(path_595114, query_595115, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_595104(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_595105,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_595106,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_595129 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersCreate_595131(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_595130(path: JsonNode; query: JsonNode;
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
  var valid_595132 = path.getOrDefault("fabricName")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "fabricName", valid_595132
  var valid_595133 = path.getOrDefault("resourceGroupName")
  valid_595133 = validateParameter(valid_595133, JString, required = true,
                                 default = nil)
  if valid_595133 != nil:
    section.add "resourceGroupName", valid_595133
  var valid_595134 = path.getOrDefault("subscriptionId")
  valid_595134 = validateParameter(valid_595134, JString, required = true,
                                 default = nil)
  if valid_595134 != nil:
    section.add "subscriptionId", valid_595134
  var valid_595135 = path.getOrDefault("resourceName")
  valid_595135 = validateParameter(valid_595135, JString, required = true,
                                 default = nil)
  if valid_595135 != nil:
    section.add "resourceName", valid_595135
  var valid_595136 = path.getOrDefault("vCenterName")
  valid_595136 = validateParameter(valid_595136, JString, required = true,
                                 default = nil)
  if valid_595136 != nil:
    section.add "vCenterName", valid_595136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595137 = query.getOrDefault("api-version")
  valid_595137 = validateParameter(valid_595137, JString, required = true,
                                 default = nil)
  if valid_595137 != nil:
    section.add "api-version", valid_595137
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

proc call*(call_595139: Call_ReplicationvCentersCreate_595129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_595139.validator(path, query, header, formData, body)
  let scheme = call_595139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595139.url(scheme.get, call_595139.host, call_595139.base,
                         call_595139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595139, url, valid)

proc call*(call_595140: Call_ReplicationvCentersCreate_595129; fabricName: string;
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
  var path_595141 = newJObject()
  var query_595142 = newJObject()
  var body_595143 = newJObject()
  add(path_595141, "fabricName", newJString(fabricName))
  add(path_595141, "resourceGroupName", newJString(resourceGroupName))
  add(query_595142, "api-version", newJString(apiVersion))
  add(path_595141, "subscriptionId", newJString(subscriptionId))
  add(path_595141, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_595143 = addVCenterRequest
  add(path_595141, "vCenterName", newJString(vCenterName))
  result = call_595140.call(path_595141, query_595142, nil, nil, body_595143)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_595129(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_595130, base: "",
    url: url_ReplicationvCentersCreate_595131, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_595116 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersGet_595118(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_595117(path: JsonNode; query: JsonNode;
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
  var valid_595119 = path.getOrDefault("fabricName")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "fabricName", valid_595119
  var valid_595120 = path.getOrDefault("resourceGroupName")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "resourceGroupName", valid_595120
  var valid_595121 = path.getOrDefault("subscriptionId")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "subscriptionId", valid_595121
  var valid_595122 = path.getOrDefault("resourceName")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "resourceName", valid_595122
  var valid_595123 = path.getOrDefault("vCenterName")
  valid_595123 = validateParameter(valid_595123, JString, required = true,
                                 default = nil)
  if valid_595123 != nil:
    section.add "vCenterName", valid_595123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595124 = query.getOrDefault("api-version")
  valid_595124 = validateParameter(valid_595124, JString, required = true,
                                 default = nil)
  if valid_595124 != nil:
    section.add "api-version", valid_595124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595125: Call_ReplicationvCentersGet_595116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_595125.validator(path, query, header, formData, body)
  let scheme = call_595125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595125.url(scheme.get, call_595125.host, call_595125.base,
                         call_595125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595125, url, valid)

proc call*(call_595126: Call_ReplicationvCentersGet_595116; fabricName: string;
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
  var path_595127 = newJObject()
  var query_595128 = newJObject()
  add(path_595127, "fabricName", newJString(fabricName))
  add(path_595127, "resourceGroupName", newJString(resourceGroupName))
  add(query_595128, "api-version", newJString(apiVersion))
  add(path_595127, "subscriptionId", newJString(subscriptionId))
  add(path_595127, "resourceName", newJString(resourceName))
  add(path_595127, "vCenterName", newJString(vCenterName))
  result = call_595126.call(path_595127, query_595128, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_595116(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_595117, base: "",
    url: url_ReplicationvCentersGet_595118, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_595157 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersUpdate_595159(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_595158(path: JsonNode; query: JsonNode;
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
  var valid_595160 = path.getOrDefault("fabricName")
  valid_595160 = validateParameter(valid_595160, JString, required = true,
                                 default = nil)
  if valid_595160 != nil:
    section.add "fabricName", valid_595160
  var valid_595161 = path.getOrDefault("resourceGroupName")
  valid_595161 = validateParameter(valid_595161, JString, required = true,
                                 default = nil)
  if valid_595161 != nil:
    section.add "resourceGroupName", valid_595161
  var valid_595162 = path.getOrDefault("subscriptionId")
  valid_595162 = validateParameter(valid_595162, JString, required = true,
                                 default = nil)
  if valid_595162 != nil:
    section.add "subscriptionId", valid_595162
  var valid_595163 = path.getOrDefault("resourceName")
  valid_595163 = validateParameter(valid_595163, JString, required = true,
                                 default = nil)
  if valid_595163 != nil:
    section.add "resourceName", valid_595163
  var valid_595164 = path.getOrDefault("vCenterName")
  valid_595164 = validateParameter(valid_595164, JString, required = true,
                                 default = nil)
  if valid_595164 != nil:
    section.add "vCenterName", valid_595164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595165 = query.getOrDefault("api-version")
  valid_595165 = validateParameter(valid_595165, JString, required = true,
                                 default = nil)
  if valid_595165 != nil:
    section.add "api-version", valid_595165
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

proc call*(call_595167: Call_ReplicationvCentersUpdate_595157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_595167.validator(path, query, header, formData, body)
  let scheme = call_595167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595167.url(scheme.get, call_595167.host, call_595167.base,
                         call_595167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595167, url, valid)

proc call*(call_595168: Call_ReplicationvCentersUpdate_595157; fabricName: string;
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
  var path_595169 = newJObject()
  var query_595170 = newJObject()
  var body_595171 = newJObject()
  add(path_595169, "fabricName", newJString(fabricName))
  add(path_595169, "resourceGroupName", newJString(resourceGroupName))
  add(query_595170, "api-version", newJString(apiVersion))
  add(path_595169, "subscriptionId", newJString(subscriptionId))
  add(path_595169, "resourceName", newJString(resourceName))
  add(path_595169, "vCenterName", newJString(vCenterName))
  if updateVCenterRequest != nil:
    body_595171 = updateVCenterRequest
  result = call_595168.call(path_595169, query_595170, nil, nil, body_595171)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_595157(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_595158, base: "",
    url: url_ReplicationvCentersUpdate_595159, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_595144 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersDelete_595146(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_595145(path: JsonNode; query: JsonNode;
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
  var valid_595147 = path.getOrDefault("fabricName")
  valid_595147 = validateParameter(valid_595147, JString, required = true,
                                 default = nil)
  if valid_595147 != nil:
    section.add "fabricName", valid_595147
  var valid_595148 = path.getOrDefault("resourceGroupName")
  valid_595148 = validateParameter(valid_595148, JString, required = true,
                                 default = nil)
  if valid_595148 != nil:
    section.add "resourceGroupName", valid_595148
  var valid_595149 = path.getOrDefault("subscriptionId")
  valid_595149 = validateParameter(valid_595149, JString, required = true,
                                 default = nil)
  if valid_595149 != nil:
    section.add "subscriptionId", valid_595149
  var valid_595150 = path.getOrDefault("resourceName")
  valid_595150 = validateParameter(valid_595150, JString, required = true,
                                 default = nil)
  if valid_595150 != nil:
    section.add "resourceName", valid_595150
  var valid_595151 = path.getOrDefault("vCenterName")
  valid_595151 = validateParameter(valid_595151, JString, required = true,
                                 default = nil)
  if valid_595151 != nil:
    section.add "vCenterName", valid_595151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595152 = query.getOrDefault("api-version")
  valid_595152 = validateParameter(valid_595152, JString, required = true,
                                 default = nil)
  if valid_595152 != nil:
    section.add "api-version", valid_595152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595153: Call_ReplicationvCentersDelete_595144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_595153.validator(path, query, header, formData, body)
  let scheme = call_595153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595153.url(scheme.get, call_595153.host, call_595153.base,
                         call_595153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595153, url, valid)

proc call*(call_595154: Call_ReplicationvCentersDelete_595144; fabricName: string;
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
  var path_595155 = newJObject()
  var query_595156 = newJObject()
  add(path_595155, "fabricName", newJString(fabricName))
  add(path_595155, "resourceGroupName", newJString(resourceGroupName))
  add(query_595156, "api-version", newJString(apiVersion))
  add(path_595155, "subscriptionId", newJString(subscriptionId))
  add(path_595155, "resourceName", newJString(resourceName))
  add(path_595155, "vCenterName", newJString(vCenterName))
  result = call_595154.call(path_595155, query_595156, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_595144(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_595145, base: "",
    url: url_ReplicationvCentersDelete_595146, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_595172 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsList_595174(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_595173(path: JsonNode; query: JsonNode;
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
  var valid_595175 = path.getOrDefault("resourceGroupName")
  valid_595175 = validateParameter(valid_595175, JString, required = true,
                                 default = nil)
  if valid_595175 != nil:
    section.add "resourceGroupName", valid_595175
  var valid_595176 = path.getOrDefault("subscriptionId")
  valid_595176 = validateParameter(valid_595176, JString, required = true,
                                 default = nil)
  if valid_595176 != nil:
    section.add "subscriptionId", valid_595176
  var valid_595177 = path.getOrDefault("resourceName")
  valid_595177 = validateParameter(valid_595177, JString, required = true,
                                 default = nil)
  if valid_595177 != nil:
    section.add "resourceName", valid_595177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595178 = query.getOrDefault("api-version")
  valid_595178 = validateParameter(valid_595178, JString, required = true,
                                 default = nil)
  if valid_595178 != nil:
    section.add "api-version", valid_595178
  var valid_595179 = query.getOrDefault("$filter")
  valid_595179 = validateParameter(valid_595179, JString, required = false,
                                 default = nil)
  if valid_595179 != nil:
    section.add "$filter", valid_595179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595180: Call_ReplicationJobsList_595172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_595180.validator(path, query, header, formData, body)
  let scheme = call_595180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595180.url(scheme.get, call_595180.host, call_595180.base,
                         call_595180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595180, url, valid)

proc call*(call_595181: Call_ReplicationJobsList_595172; resourceGroupName: string;
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
  var path_595182 = newJObject()
  var query_595183 = newJObject()
  add(path_595182, "resourceGroupName", newJString(resourceGroupName))
  add(query_595183, "api-version", newJString(apiVersion))
  add(path_595182, "subscriptionId", newJString(subscriptionId))
  add(path_595182, "resourceName", newJString(resourceName))
  add(query_595183, "$filter", newJString(Filter))
  result = call_595181.call(path_595182, query_595183, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_595172(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_595173, base: "",
    url: url_ReplicationJobsList_595174, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_595184 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsExport_595186(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_595185(path: JsonNode; query: JsonNode;
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
  var valid_595187 = path.getOrDefault("resourceGroupName")
  valid_595187 = validateParameter(valid_595187, JString, required = true,
                                 default = nil)
  if valid_595187 != nil:
    section.add "resourceGroupName", valid_595187
  var valid_595188 = path.getOrDefault("subscriptionId")
  valid_595188 = validateParameter(valid_595188, JString, required = true,
                                 default = nil)
  if valid_595188 != nil:
    section.add "subscriptionId", valid_595188
  var valid_595189 = path.getOrDefault("resourceName")
  valid_595189 = validateParameter(valid_595189, JString, required = true,
                                 default = nil)
  if valid_595189 != nil:
    section.add "resourceName", valid_595189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595190 = query.getOrDefault("api-version")
  valid_595190 = validateParameter(valid_595190, JString, required = true,
                                 default = nil)
  if valid_595190 != nil:
    section.add "api-version", valid_595190
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

proc call*(call_595192: Call_ReplicationJobsExport_595184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_595192.validator(path, query, header, formData, body)
  let scheme = call_595192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595192.url(scheme.get, call_595192.host, call_595192.base,
                         call_595192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595192, url, valid)

proc call*(call_595193: Call_ReplicationJobsExport_595184;
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
  var path_595194 = newJObject()
  var query_595195 = newJObject()
  var body_595196 = newJObject()
  add(path_595194, "resourceGroupName", newJString(resourceGroupName))
  add(query_595195, "api-version", newJString(apiVersion))
  add(path_595194, "subscriptionId", newJString(subscriptionId))
  add(path_595194, "resourceName", newJString(resourceName))
  if jobQueryParameter != nil:
    body_595196 = jobQueryParameter
  result = call_595193.call(path_595194, query_595195, nil, nil, body_595196)

var replicationJobsExport* = Call_ReplicationJobsExport_595184(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_595185, base: "",
    url: url_ReplicationJobsExport_595186, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_595197 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsGet_595199(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_595198(path: JsonNode; query: JsonNode;
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
  var valid_595200 = path.getOrDefault("resourceGroupName")
  valid_595200 = validateParameter(valid_595200, JString, required = true,
                                 default = nil)
  if valid_595200 != nil:
    section.add "resourceGroupName", valid_595200
  var valid_595201 = path.getOrDefault("subscriptionId")
  valid_595201 = validateParameter(valid_595201, JString, required = true,
                                 default = nil)
  if valid_595201 != nil:
    section.add "subscriptionId", valid_595201
  var valid_595202 = path.getOrDefault("jobName")
  valid_595202 = validateParameter(valid_595202, JString, required = true,
                                 default = nil)
  if valid_595202 != nil:
    section.add "jobName", valid_595202
  var valid_595203 = path.getOrDefault("resourceName")
  valid_595203 = validateParameter(valid_595203, JString, required = true,
                                 default = nil)
  if valid_595203 != nil:
    section.add "resourceName", valid_595203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595204 = query.getOrDefault("api-version")
  valid_595204 = validateParameter(valid_595204, JString, required = true,
                                 default = nil)
  if valid_595204 != nil:
    section.add "api-version", valid_595204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595205: Call_ReplicationJobsGet_595197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_595205.validator(path, query, header, formData, body)
  let scheme = call_595205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595205.url(scheme.get, call_595205.host, call_595205.base,
                         call_595205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595205, url, valid)

proc call*(call_595206: Call_ReplicationJobsGet_595197; resourceGroupName: string;
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
  var path_595207 = newJObject()
  var query_595208 = newJObject()
  add(path_595207, "resourceGroupName", newJString(resourceGroupName))
  add(query_595208, "api-version", newJString(apiVersion))
  add(path_595207, "subscriptionId", newJString(subscriptionId))
  add(path_595207, "jobName", newJString(jobName))
  add(path_595207, "resourceName", newJString(resourceName))
  result = call_595206.call(path_595207, query_595208, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_595197(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_595198, base: "",
    url: url_ReplicationJobsGet_595199, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_595209 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsCancel_595211(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_595210(path: JsonNode; query: JsonNode;
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
  var valid_595212 = path.getOrDefault("resourceGroupName")
  valid_595212 = validateParameter(valid_595212, JString, required = true,
                                 default = nil)
  if valid_595212 != nil:
    section.add "resourceGroupName", valid_595212
  var valid_595213 = path.getOrDefault("subscriptionId")
  valid_595213 = validateParameter(valid_595213, JString, required = true,
                                 default = nil)
  if valid_595213 != nil:
    section.add "subscriptionId", valid_595213
  var valid_595214 = path.getOrDefault("jobName")
  valid_595214 = validateParameter(valid_595214, JString, required = true,
                                 default = nil)
  if valid_595214 != nil:
    section.add "jobName", valid_595214
  var valid_595215 = path.getOrDefault("resourceName")
  valid_595215 = validateParameter(valid_595215, JString, required = true,
                                 default = nil)
  if valid_595215 != nil:
    section.add "resourceName", valid_595215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595216 = query.getOrDefault("api-version")
  valid_595216 = validateParameter(valid_595216, JString, required = true,
                                 default = nil)
  if valid_595216 != nil:
    section.add "api-version", valid_595216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595217: Call_ReplicationJobsCancel_595209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_595217.validator(path, query, header, formData, body)
  let scheme = call_595217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595217.url(scheme.get, call_595217.host, call_595217.base,
                         call_595217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595217, url, valid)

proc call*(call_595218: Call_ReplicationJobsCancel_595209;
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
  var path_595219 = newJObject()
  var query_595220 = newJObject()
  add(path_595219, "resourceGroupName", newJString(resourceGroupName))
  add(query_595220, "api-version", newJString(apiVersion))
  add(path_595219, "subscriptionId", newJString(subscriptionId))
  add(path_595219, "jobName", newJString(jobName))
  add(path_595219, "resourceName", newJString(resourceName))
  result = call_595218.call(path_595219, query_595220, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_595209(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_595210, base: "",
    url: url_ReplicationJobsCancel_595211, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_595221 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsRestart_595223(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_595222(path: JsonNode; query: JsonNode;
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
  var valid_595224 = path.getOrDefault("resourceGroupName")
  valid_595224 = validateParameter(valid_595224, JString, required = true,
                                 default = nil)
  if valid_595224 != nil:
    section.add "resourceGroupName", valid_595224
  var valid_595225 = path.getOrDefault("subscriptionId")
  valid_595225 = validateParameter(valid_595225, JString, required = true,
                                 default = nil)
  if valid_595225 != nil:
    section.add "subscriptionId", valid_595225
  var valid_595226 = path.getOrDefault("jobName")
  valid_595226 = validateParameter(valid_595226, JString, required = true,
                                 default = nil)
  if valid_595226 != nil:
    section.add "jobName", valid_595226
  var valid_595227 = path.getOrDefault("resourceName")
  valid_595227 = validateParameter(valid_595227, JString, required = true,
                                 default = nil)
  if valid_595227 != nil:
    section.add "resourceName", valid_595227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595228 = query.getOrDefault("api-version")
  valid_595228 = validateParameter(valid_595228, JString, required = true,
                                 default = nil)
  if valid_595228 != nil:
    section.add "api-version", valid_595228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595229: Call_ReplicationJobsRestart_595221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_595229.validator(path, query, header, formData, body)
  let scheme = call_595229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595229.url(scheme.get, call_595229.host, call_595229.base,
                         call_595229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595229, url, valid)

proc call*(call_595230: Call_ReplicationJobsRestart_595221;
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
  var path_595231 = newJObject()
  var query_595232 = newJObject()
  add(path_595231, "resourceGroupName", newJString(resourceGroupName))
  add(query_595232, "api-version", newJString(apiVersion))
  add(path_595231, "subscriptionId", newJString(subscriptionId))
  add(path_595231, "jobName", newJString(jobName))
  add(path_595231, "resourceName", newJString(resourceName))
  result = call_595230.call(path_595231, query_595232, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_595221(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_595222, base: "",
    url: url_ReplicationJobsRestart_595223, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_595233 = ref object of OpenApiRestCall_593439
proc url_ReplicationJobsResume_595235(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_595234(path: JsonNode; query: JsonNode;
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
  var valid_595236 = path.getOrDefault("resourceGroupName")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = nil)
  if valid_595236 != nil:
    section.add "resourceGroupName", valid_595236
  var valid_595237 = path.getOrDefault("subscriptionId")
  valid_595237 = validateParameter(valid_595237, JString, required = true,
                                 default = nil)
  if valid_595237 != nil:
    section.add "subscriptionId", valid_595237
  var valid_595238 = path.getOrDefault("jobName")
  valid_595238 = validateParameter(valid_595238, JString, required = true,
                                 default = nil)
  if valid_595238 != nil:
    section.add "jobName", valid_595238
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
  ## parameters in `body` object:
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595242: Call_ReplicationJobsResume_595233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_595242.validator(path, query, header, formData, body)
  let scheme = call_595242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595242.url(scheme.get, call_595242.host, call_595242.base,
                         call_595242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595242, url, valid)

proc call*(call_595243: Call_ReplicationJobsResume_595233;
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
  var path_595244 = newJObject()
  var query_595245 = newJObject()
  var body_595246 = newJObject()
  add(path_595244, "resourceGroupName", newJString(resourceGroupName))
  add(query_595245, "api-version", newJString(apiVersion))
  if resumeJobParams != nil:
    body_595246 = resumeJobParams
  add(path_595244, "subscriptionId", newJString(subscriptionId))
  add(path_595244, "jobName", newJString(jobName))
  add(path_595244, "resourceName", newJString(resourceName))
  result = call_595243.call(path_595244, query_595245, nil, nil, body_595246)

var replicationJobsResume* = Call_ReplicationJobsResume_595233(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_595234, base: "",
    url: url_ReplicationJobsResume_595235, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_595247 = ref object of OpenApiRestCall_593439
proc url_ReplicationMigrationItemsList_595249(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsList_595248(path: JsonNode; query: JsonNode;
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
  var valid_595250 = path.getOrDefault("resourceGroupName")
  valid_595250 = validateParameter(valid_595250, JString, required = true,
                                 default = nil)
  if valid_595250 != nil:
    section.add "resourceGroupName", valid_595250
  var valid_595251 = path.getOrDefault("subscriptionId")
  valid_595251 = validateParameter(valid_595251, JString, required = true,
                                 default = nil)
  if valid_595251 != nil:
    section.add "subscriptionId", valid_595251
  var valid_595252 = path.getOrDefault("resourceName")
  valid_595252 = validateParameter(valid_595252, JString, required = true,
                                 default = nil)
  if valid_595252 != nil:
    section.add "resourceName", valid_595252
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_595253 = query.getOrDefault("skipToken")
  valid_595253 = validateParameter(valid_595253, JString, required = false,
                                 default = nil)
  if valid_595253 != nil:
    section.add "skipToken", valid_595253
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595254 = query.getOrDefault("api-version")
  valid_595254 = validateParameter(valid_595254, JString, required = true,
                                 default = nil)
  if valid_595254 != nil:
    section.add "api-version", valid_595254
  var valid_595255 = query.getOrDefault("$filter")
  valid_595255 = validateParameter(valid_595255, JString, required = false,
                                 default = nil)
  if valid_595255 != nil:
    section.add "$filter", valid_595255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595256: Call_ReplicationMigrationItemsList_595247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595256.validator(path, query, header, formData, body)
  let scheme = call_595256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595256.url(scheme.get, call_595256.host, call_595256.base,
                         call_595256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595256, url, valid)

proc call*(call_595257: Call_ReplicationMigrationItemsList_595247;
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
  var path_595258 = newJObject()
  var query_595259 = newJObject()
  add(path_595258, "resourceGroupName", newJString(resourceGroupName))
  add(query_595259, "skipToken", newJString(skipToken))
  add(query_595259, "api-version", newJString(apiVersion))
  add(path_595258, "subscriptionId", newJString(subscriptionId))
  add(path_595258, "resourceName", newJString(resourceName))
  add(query_595259, "$filter", newJString(Filter))
  result = call_595257.call(path_595258, query_595259, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_595247(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_595248, base: "",
    url: url_ReplicationMigrationItemsList_595249, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_595260 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworkMappingsList_595262(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_595261(path: JsonNode;
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
  var valid_595263 = path.getOrDefault("resourceGroupName")
  valid_595263 = validateParameter(valid_595263, JString, required = true,
                                 default = nil)
  if valid_595263 != nil:
    section.add "resourceGroupName", valid_595263
  var valid_595264 = path.getOrDefault("subscriptionId")
  valid_595264 = validateParameter(valid_595264, JString, required = true,
                                 default = nil)
  if valid_595264 != nil:
    section.add "subscriptionId", valid_595264
  var valid_595265 = path.getOrDefault("resourceName")
  valid_595265 = validateParameter(valid_595265, JString, required = true,
                                 default = nil)
  if valid_595265 != nil:
    section.add "resourceName", valid_595265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595266 = query.getOrDefault("api-version")
  valid_595266 = validateParameter(valid_595266, JString, required = true,
                                 default = nil)
  if valid_595266 != nil:
    section.add "api-version", valid_595266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595267: Call_ReplicationNetworkMappingsList_595260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_595267.validator(path, query, header, formData, body)
  let scheme = call_595267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595267.url(scheme.get, call_595267.host, call_595267.base,
                         call_595267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595267, url, valid)

proc call*(call_595268: Call_ReplicationNetworkMappingsList_595260;
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
  var path_595269 = newJObject()
  var query_595270 = newJObject()
  add(path_595269, "resourceGroupName", newJString(resourceGroupName))
  add(query_595270, "api-version", newJString(apiVersion))
  add(path_595269, "subscriptionId", newJString(subscriptionId))
  add(path_595269, "resourceName", newJString(resourceName))
  result = call_595268.call(path_595269, query_595270, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_595260(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_595261, base: "",
    url: url_ReplicationNetworkMappingsList_595262, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_595271 = ref object of OpenApiRestCall_593439
proc url_ReplicationNetworksList_595273(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_595272(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595277 = query.getOrDefault("api-version")
  valid_595277 = validateParameter(valid_595277, JString, required = true,
                                 default = nil)
  if valid_595277 != nil:
    section.add "api-version", valid_595277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595278: Call_ReplicationNetworksList_595271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_595278.validator(path, query, header, formData, body)
  let scheme = call_595278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595278.url(scheme.get, call_595278.host, call_595278.base,
                         call_595278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595278, url, valid)

proc call*(call_595279: Call_ReplicationNetworksList_595271;
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
  var path_595280 = newJObject()
  var query_595281 = newJObject()
  add(path_595280, "resourceGroupName", newJString(resourceGroupName))
  add(query_595281, "api-version", newJString(apiVersion))
  add(path_595280, "subscriptionId", newJString(subscriptionId))
  add(path_595280, "resourceName", newJString(resourceName))
  result = call_595279.call(path_595280, query_595281, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_595271(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_595272, base: "",
    url: url_ReplicationNetworksList_595273, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_595282 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesList_595284(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_595283(path: JsonNode; query: JsonNode;
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
  var valid_595285 = path.getOrDefault("resourceGroupName")
  valid_595285 = validateParameter(valid_595285, JString, required = true,
                                 default = nil)
  if valid_595285 != nil:
    section.add "resourceGroupName", valid_595285
  var valid_595286 = path.getOrDefault("subscriptionId")
  valid_595286 = validateParameter(valid_595286, JString, required = true,
                                 default = nil)
  if valid_595286 != nil:
    section.add "subscriptionId", valid_595286
  var valid_595287 = path.getOrDefault("resourceName")
  valid_595287 = validateParameter(valid_595287, JString, required = true,
                                 default = nil)
  if valid_595287 != nil:
    section.add "resourceName", valid_595287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595288 = query.getOrDefault("api-version")
  valid_595288 = validateParameter(valid_595288, JString, required = true,
                                 default = nil)
  if valid_595288 != nil:
    section.add "api-version", valid_595288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595289: Call_ReplicationPoliciesList_595282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_595289.validator(path, query, header, formData, body)
  let scheme = call_595289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595289.url(scheme.get, call_595289.host, call_595289.base,
                         call_595289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595289, url, valid)

proc call*(call_595290: Call_ReplicationPoliciesList_595282;
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
  var path_595291 = newJObject()
  var query_595292 = newJObject()
  add(path_595291, "resourceGroupName", newJString(resourceGroupName))
  add(query_595292, "api-version", newJString(apiVersion))
  add(path_595291, "subscriptionId", newJString(subscriptionId))
  add(path_595291, "resourceName", newJString(resourceName))
  result = call_595290.call(path_595291, query_595292, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_595282(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_595283, base: "",
    url: url_ReplicationPoliciesList_595284, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_595305 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesCreate_595307(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_595306(path: JsonNode; query: JsonNode;
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
  var valid_595308 = path.getOrDefault("resourceGroupName")
  valid_595308 = validateParameter(valid_595308, JString, required = true,
                                 default = nil)
  if valid_595308 != nil:
    section.add "resourceGroupName", valid_595308
  var valid_595309 = path.getOrDefault("subscriptionId")
  valid_595309 = validateParameter(valid_595309, JString, required = true,
                                 default = nil)
  if valid_595309 != nil:
    section.add "subscriptionId", valid_595309
  var valid_595310 = path.getOrDefault("resourceName")
  valid_595310 = validateParameter(valid_595310, JString, required = true,
                                 default = nil)
  if valid_595310 != nil:
    section.add "resourceName", valid_595310
  var valid_595311 = path.getOrDefault("policyName")
  valid_595311 = validateParameter(valid_595311, JString, required = true,
                                 default = nil)
  if valid_595311 != nil:
    section.add "policyName", valid_595311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595312 = query.getOrDefault("api-version")
  valid_595312 = validateParameter(valid_595312, JString, required = true,
                                 default = nil)
  if valid_595312 != nil:
    section.add "api-version", valid_595312
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

proc call*(call_595314: Call_ReplicationPoliciesCreate_595305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_595314.validator(path, query, header, formData, body)
  let scheme = call_595314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595314.url(scheme.get, call_595314.host, call_595314.base,
                         call_595314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595314, url, valid)

proc call*(call_595315: Call_ReplicationPoliciesCreate_595305;
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
  var path_595316 = newJObject()
  var query_595317 = newJObject()
  var body_595318 = newJObject()
  add(path_595316, "resourceGroupName", newJString(resourceGroupName))
  add(query_595317, "api-version", newJString(apiVersion))
  add(path_595316, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595318 = input
  add(path_595316, "resourceName", newJString(resourceName))
  add(path_595316, "policyName", newJString(policyName))
  result = call_595315.call(path_595316, query_595317, nil, nil, body_595318)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_595305(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_595306, base: "",
    url: url_ReplicationPoliciesCreate_595307, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_595293 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesGet_595295(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_595294(path: JsonNode; query: JsonNode;
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
  var valid_595296 = path.getOrDefault("resourceGroupName")
  valid_595296 = validateParameter(valid_595296, JString, required = true,
                                 default = nil)
  if valid_595296 != nil:
    section.add "resourceGroupName", valid_595296
  var valid_595297 = path.getOrDefault("subscriptionId")
  valid_595297 = validateParameter(valid_595297, JString, required = true,
                                 default = nil)
  if valid_595297 != nil:
    section.add "subscriptionId", valid_595297
  var valid_595298 = path.getOrDefault("resourceName")
  valid_595298 = validateParameter(valid_595298, JString, required = true,
                                 default = nil)
  if valid_595298 != nil:
    section.add "resourceName", valid_595298
  var valid_595299 = path.getOrDefault("policyName")
  valid_595299 = validateParameter(valid_595299, JString, required = true,
                                 default = nil)
  if valid_595299 != nil:
    section.add "policyName", valid_595299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595300 = query.getOrDefault("api-version")
  valid_595300 = validateParameter(valid_595300, JString, required = true,
                                 default = nil)
  if valid_595300 != nil:
    section.add "api-version", valid_595300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595301: Call_ReplicationPoliciesGet_595293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_595301.validator(path, query, header, formData, body)
  let scheme = call_595301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595301.url(scheme.get, call_595301.host, call_595301.base,
                         call_595301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595301, url, valid)

proc call*(call_595302: Call_ReplicationPoliciesGet_595293;
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
  var path_595303 = newJObject()
  var query_595304 = newJObject()
  add(path_595303, "resourceGroupName", newJString(resourceGroupName))
  add(query_595304, "api-version", newJString(apiVersion))
  add(path_595303, "subscriptionId", newJString(subscriptionId))
  add(path_595303, "resourceName", newJString(resourceName))
  add(path_595303, "policyName", newJString(policyName))
  result = call_595302.call(path_595303, query_595304, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_595293(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_595294, base: "",
    url: url_ReplicationPoliciesGet_595295, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_595331 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesUpdate_595333(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_595332(path: JsonNode; query: JsonNode;
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
  var valid_595334 = path.getOrDefault("resourceGroupName")
  valid_595334 = validateParameter(valid_595334, JString, required = true,
                                 default = nil)
  if valid_595334 != nil:
    section.add "resourceGroupName", valid_595334
  var valid_595335 = path.getOrDefault("subscriptionId")
  valid_595335 = validateParameter(valid_595335, JString, required = true,
                                 default = nil)
  if valid_595335 != nil:
    section.add "subscriptionId", valid_595335
  var valid_595336 = path.getOrDefault("resourceName")
  valid_595336 = validateParameter(valid_595336, JString, required = true,
                                 default = nil)
  if valid_595336 != nil:
    section.add "resourceName", valid_595336
  var valid_595337 = path.getOrDefault("policyName")
  valid_595337 = validateParameter(valid_595337, JString, required = true,
                                 default = nil)
  if valid_595337 != nil:
    section.add "policyName", valid_595337
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
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Policy Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595340: Call_ReplicationPoliciesUpdate_595331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_595340.validator(path, query, header, formData, body)
  let scheme = call_595340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595340.url(scheme.get, call_595340.host, call_595340.base,
                         call_595340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595340, url, valid)

proc call*(call_595341: Call_ReplicationPoliciesUpdate_595331;
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
  var path_595342 = newJObject()
  var query_595343 = newJObject()
  var body_595344 = newJObject()
  add(path_595342, "resourceGroupName", newJString(resourceGroupName))
  add(query_595343, "api-version", newJString(apiVersion))
  add(path_595342, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595344 = input
  add(path_595342, "resourceName", newJString(resourceName))
  add(path_595342, "policyName", newJString(policyName))
  result = call_595341.call(path_595342, query_595343, nil, nil, body_595344)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_595331(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_595332, base: "",
    url: url_ReplicationPoliciesUpdate_595333, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_595319 = ref object of OpenApiRestCall_593439
proc url_ReplicationPoliciesDelete_595321(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_595320(path: JsonNode; query: JsonNode;
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
  var valid_595322 = path.getOrDefault("resourceGroupName")
  valid_595322 = validateParameter(valid_595322, JString, required = true,
                                 default = nil)
  if valid_595322 != nil:
    section.add "resourceGroupName", valid_595322
  var valid_595323 = path.getOrDefault("subscriptionId")
  valid_595323 = validateParameter(valid_595323, JString, required = true,
                                 default = nil)
  if valid_595323 != nil:
    section.add "subscriptionId", valid_595323
  var valid_595324 = path.getOrDefault("resourceName")
  valid_595324 = validateParameter(valid_595324, JString, required = true,
                                 default = nil)
  if valid_595324 != nil:
    section.add "resourceName", valid_595324
  var valid_595325 = path.getOrDefault("policyName")
  valid_595325 = validateParameter(valid_595325, JString, required = true,
                                 default = nil)
  if valid_595325 != nil:
    section.add "policyName", valid_595325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595326 = query.getOrDefault("api-version")
  valid_595326 = validateParameter(valid_595326, JString, required = true,
                                 default = nil)
  if valid_595326 != nil:
    section.add "api-version", valid_595326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595327: Call_ReplicationPoliciesDelete_595319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_595327.validator(path, query, header, formData, body)
  let scheme = call_595327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595327.url(scheme.get, call_595327.host, call_595327.base,
                         call_595327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595327, url, valid)

proc call*(call_595328: Call_ReplicationPoliciesDelete_595319;
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
  var path_595329 = newJObject()
  var query_595330 = newJObject()
  add(path_595329, "resourceGroupName", newJString(resourceGroupName))
  add(query_595330, "api-version", newJString(apiVersion))
  add(path_595329, "subscriptionId", newJString(subscriptionId))
  add(path_595329, "resourceName", newJString(resourceName))
  add(path_595329, "policyName", newJString(policyName))
  result = call_595328.call(path_595329, query_595330, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_595319(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_595320, base: "",
    url: url_ReplicationPoliciesDelete_595321, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_595345 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectedItemsList_595347(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_595346(path: JsonNode; query: JsonNode;
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
  var valid_595348 = path.getOrDefault("resourceGroupName")
  valid_595348 = validateParameter(valid_595348, JString, required = true,
                                 default = nil)
  if valid_595348 != nil:
    section.add "resourceGroupName", valid_595348
  var valid_595349 = path.getOrDefault("subscriptionId")
  valid_595349 = validateParameter(valid_595349, JString, required = true,
                                 default = nil)
  if valid_595349 != nil:
    section.add "subscriptionId", valid_595349
  var valid_595350 = path.getOrDefault("resourceName")
  valid_595350 = validateParameter(valid_595350, JString, required = true,
                                 default = nil)
  if valid_595350 != nil:
    section.add "resourceName", valid_595350
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_595351 = query.getOrDefault("skipToken")
  valid_595351 = validateParameter(valid_595351, JString, required = false,
                                 default = nil)
  if valid_595351 != nil:
    section.add "skipToken", valid_595351
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595352 = query.getOrDefault("api-version")
  valid_595352 = validateParameter(valid_595352, JString, required = true,
                                 default = nil)
  if valid_595352 != nil:
    section.add "api-version", valid_595352
  var valid_595353 = query.getOrDefault("$filter")
  valid_595353 = validateParameter(valid_595353, JString, required = false,
                                 default = nil)
  if valid_595353 != nil:
    section.add "$filter", valid_595353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595354: Call_ReplicationProtectedItemsList_595345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_595354.validator(path, query, header, formData, body)
  let scheme = call_595354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595354.url(scheme.get, call_595354.host, call_595354.base,
                         call_595354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595354, url, valid)

proc call*(call_595355: Call_ReplicationProtectedItemsList_595345;
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
  var path_595356 = newJObject()
  var query_595357 = newJObject()
  add(path_595356, "resourceGroupName", newJString(resourceGroupName))
  add(query_595357, "skipToken", newJString(skipToken))
  add(query_595357, "api-version", newJString(apiVersion))
  add(path_595356, "subscriptionId", newJString(subscriptionId))
  add(path_595356, "resourceName", newJString(resourceName))
  add(query_595357, "$filter", newJString(Filter))
  result = call_595355.call(path_595356, query_595357, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_595345(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_595346, base: "",
    url: url_ReplicationProtectedItemsList_595347, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_595358 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainerMappingsList_595360(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_595359(path: JsonNode;
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
  var valid_595361 = path.getOrDefault("resourceGroupName")
  valid_595361 = validateParameter(valid_595361, JString, required = true,
                                 default = nil)
  if valid_595361 != nil:
    section.add "resourceGroupName", valid_595361
  var valid_595362 = path.getOrDefault("subscriptionId")
  valid_595362 = validateParameter(valid_595362, JString, required = true,
                                 default = nil)
  if valid_595362 != nil:
    section.add "subscriptionId", valid_595362
  var valid_595363 = path.getOrDefault("resourceName")
  valid_595363 = validateParameter(valid_595363, JString, required = true,
                                 default = nil)
  if valid_595363 != nil:
    section.add "resourceName", valid_595363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595364 = query.getOrDefault("api-version")
  valid_595364 = validateParameter(valid_595364, JString, required = true,
                                 default = nil)
  if valid_595364 != nil:
    section.add "api-version", valid_595364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595365: Call_ReplicationProtectionContainerMappingsList_595358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_595365.validator(path, query, header, formData, body)
  let scheme = call_595365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595365.url(scheme.get, call_595365.host, call_595365.base,
                         call_595365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595365, url, valid)

proc call*(call_595366: Call_ReplicationProtectionContainerMappingsList_595358;
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
  var path_595367 = newJObject()
  var query_595368 = newJObject()
  add(path_595367, "resourceGroupName", newJString(resourceGroupName))
  add(query_595368, "api-version", newJString(apiVersion))
  add(path_595367, "subscriptionId", newJString(subscriptionId))
  add(path_595367, "resourceName", newJString(resourceName))
  result = call_595366.call(path_595367, query_595368, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_595358(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_595359,
    base: "", url: url_ReplicationProtectionContainerMappingsList_595360,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_595369 = ref object of OpenApiRestCall_593439
proc url_ReplicationProtectionContainersList_595371(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_595370(path: JsonNode;
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
  var valid_595374 = path.getOrDefault("resourceName")
  valid_595374 = validateParameter(valid_595374, JString, required = true,
                                 default = nil)
  if valid_595374 != nil:
    section.add "resourceName", valid_595374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595375 = query.getOrDefault("api-version")
  valid_595375 = validateParameter(valid_595375, JString, required = true,
                                 default = nil)
  if valid_595375 != nil:
    section.add "api-version", valid_595375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595376: Call_ReplicationProtectionContainersList_595369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_595376.validator(path, query, header, formData, body)
  let scheme = call_595376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595376.url(scheme.get, call_595376.host, call_595376.base,
                         call_595376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595376, url, valid)

proc call*(call_595377: Call_ReplicationProtectionContainersList_595369;
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
  var path_595378 = newJObject()
  var query_595379 = newJObject()
  add(path_595378, "resourceGroupName", newJString(resourceGroupName))
  add(query_595379, "api-version", newJString(apiVersion))
  add(path_595378, "subscriptionId", newJString(subscriptionId))
  add(path_595378, "resourceName", newJString(resourceName))
  result = call_595377.call(path_595378, query_595379, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_595369(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_595370, base: "",
    url: url_ReplicationProtectionContainersList_595371, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_595380 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansList_595382(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_595381(path: JsonNode; query: JsonNode;
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
  var valid_595383 = path.getOrDefault("resourceGroupName")
  valid_595383 = validateParameter(valid_595383, JString, required = true,
                                 default = nil)
  if valid_595383 != nil:
    section.add "resourceGroupName", valid_595383
  var valid_595384 = path.getOrDefault("subscriptionId")
  valid_595384 = validateParameter(valid_595384, JString, required = true,
                                 default = nil)
  if valid_595384 != nil:
    section.add "subscriptionId", valid_595384
  var valid_595385 = path.getOrDefault("resourceName")
  valid_595385 = validateParameter(valid_595385, JString, required = true,
                                 default = nil)
  if valid_595385 != nil:
    section.add "resourceName", valid_595385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595386 = query.getOrDefault("api-version")
  valid_595386 = validateParameter(valid_595386, JString, required = true,
                                 default = nil)
  if valid_595386 != nil:
    section.add "api-version", valid_595386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595387: Call_ReplicationRecoveryPlansList_595380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_595387.validator(path, query, header, formData, body)
  let scheme = call_595387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595387.url(scheme.get, call_595387.host, call_595387.base,
                         call_595387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595387, url, valid)

proc call*(call_595388: Call_ReplicationRecoveryPlansList_595380;
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
  var path_595389 = newJObject()
  var query_595390 = newJObject()
  add(path_595389, "resourceGroupName", newJString(resourceGroupName))
  add(query_595390, "api-version", newJString(apiVersion))
  add(path_595389, "subscriptionId", newJString(subscriptionId))
  add(path_595389, "resourceName", newJString(resourceName))
  result = call_595388.call(path_595389, query_595390, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_595380(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_595381, base: "",
    url: url_ReplicationRecoveryPlansList_595382, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_595403 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansCreate_595405(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_595404(path: JsonNode;
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
  var valid_595406 = path.getOrDefault("resourceGroupName")
  valid_595406 = validateParameter(valid_595406, JString, required = true,
                                 default = nil)
  if valid_595406 != nil:
    section.add "resourceGroupName", valid_595406
  var valid_595407 = path.getOrDefault("subscriptionId")
  valid_595407 = validateParameter(valid_595407, JString, required = true,
                                 default = nil)
  if valid_595407 != nil:
    section.add "subscriptionId", valid_595407
  var valid_595408 = path.getOrDefault("recoveryPlanName")
  valid_595408 = validateParameter(valid_595408, JString, required = true,
                                 default = nil)
  if valid_595408 != nil:
    section.add "recoveryPlanName", valid_595408
  var valid_595409 = path.getOrDefault("resourceName")
  valid_595409 = validateParameter(valid_595409, JString, required = true,
                                 default = nil)
  if valid_595409 != nil:
    section.add "resourceName", valid_595409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595410 = query.getOrDefault("api-version")
  valid_595410 = validateParameter(valid_595410, JString, required = true,
                                 default = nil)
  if valid_595410 != nil:
    section.add "api-version", valid_595410
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

proc call*(call_595412: Call_ReplicationRecoveryPlansCreate_595403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_595412.validator(path, query, header, formData, body)
  let scheme = call_595412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595412.url(scheme.get, call_595412.host, call_595412.base,
                         call_595412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595412, url, valid)

proc call*(call_595413: Call_ReplicationRecoveryPlansCreate_595403;
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
  var path_595414 = newJObject()
  var query_595415 = newJObject()
  var body_595416 = newJObject()
  add(path_595414, "resourceGroupName", newJString(resourceGroupName))
  add(query_595415, "api-version", newJString(apiVersion))
  add(path_595414, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595416 = input
  add(path_595414, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595414, "resourceName", newJString(resourceName))
  result = call_595413.call(path_595414, query_595415, nil, nil, body_595416)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_595403(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_595404, base: "",
    url: url_ReplicationRecoveryPlansCreate_595405, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_595391 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansGet_595393(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_595392(path: JsonNode; query: JsonNode;
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
  var valid_595394 = path.getOrDefault("resourceGroupName")
  valid_595394 = validateParameter(valid_595394, JString, required = true,
                                 default = nil)
  if valid_595394 != nil:
    section.add "resourceGroupName", valid_595394
  var valid_595395 = path.getOrDefault("subscriptionId")
  valid_595395 = validateParameter(valid_595395, JString, required = true,
                                 default = nil)
  if valid_595395 != nil:
    section.add "subscriptionId", valid_595395
  var valid_595396 = path.getOrDefault("recoveryPlanName")
  valid_595396 = validateParameter(valid_595396, JString, required = true,
                                 default = nil)
  if valid_595396 != nil:
    section.add "recoveryPlanName", valid_595396
  var valid_595397 = path.getOrDefault("resourceName")
  valid_595397 = validateParameter(valid_595397, JString, required = true,
                                 default = nil)
  if valid_595397 != nil:
    section.add "resourceName", valid_595397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595398 = query.getOrDefault("api-version")
  valid_595398 = validateParameter(valid_595398, JString, required = true,
                                 default = nil)
  if valid_595398 != nil:
    section.add "api-version", valid_595398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595399: Call_ReplicationRecoveryPlansGet_595391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_595399.validator(path, query, header, formData, body)
  let scheme = call_595399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595399.url(scheme.get, call_595399.host, call_595399.base,
                         call_595399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595399, url, valid)

proc call*(call_595400: Call_ReplicationRecoveryPlansGet_595391;
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
  var path_595401 = newJObject()
  var query_595402 = newJObject()
  add(path_595401, "resourceGroupName", newJString(resourceGroupName))
  add(query_595402, "api-version", newJString(apiVersion))
  add(path_595401, "subscriptionId", newJString(subscriptionId))
  add(path_595401, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595401, "resourceName", newJString(resourceName))
  result = call_595400.call(path_595401, query_595402, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_595391(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_595392, base: "",
    url: url_ReplicationRecoveryPlansGet_595393, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_595429 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansUpdate_595431(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_595430(path: JsonNode;
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
  var valid_595432 = path.getOrDefault("resourceGroupName")
  valid_595432 = validateParameter(valid_595432, JString, required = true,
                                 default = nil)
  if valid_595432 != nil:
    section.add "resourceGroupName", valid_595432
  var valid_595433 = path.getOrDefault("subscriptionId")
  valid_595433 = validateParameter(valid_595433, JString, required = true,
                                 default = nil)
  if valid_595433 != nil:
    section.add "subscriptionId", valid_595433
  var valid_595434 = path.getOrDefault("recoveryPlanName")
  valid_595434 = validateParameter(valid_595434, JString, required = true,
                                 default = nil)
  if valid_595434 != nil:
    section.add "recoveryPlanName", valid_595434
  var valid_595435 = path.getOrDefault("resourceName")
  valid_595435 = validateParameter(valid_595435, JString, required = true,
                                 default = nil)
  if valid_595435 != nil:
    section.add "resourceName", valid_595435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595436 = query.getOrDefault("api-version")
  valid_595436 = validateParameter(valid_595436, JString, required = true,
                                 default = nil)
  if valid_595436 != nil:
    section.add "api-version", valid_595436
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

proc call*(call_595438: Call_ReplicationRecoveryPlansUpdate_595429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_595438.validator(path, query, header, formData, body)
  let scheme = call_595438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595438.url(scheme.get, call_595438.host, call_595438.base,
                         call_595438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595438, url, valid)

proc call*(call_595439: Call_ReplicationRecoveryPlansUpdate_595429;
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
  var path_595440 = newJObject()
  var query_595441 = newJObject()
  var body_595442 = newJObject()
  add(path_595440, "resourceGroupName", newJString(resourceGroupName))
  add(query_595441, "api-version", newJString(apiVersion))
  add(path_595440, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595442 = input
  add(path_595440, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595440, "resourceName", newJString(resourceName))
  result = call_595439.call(path_595440, query_595441, nil, nil, body_595442)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_595429(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_595430, base: "",
    url: url_ReplicationRecoveryPlansUpdate_595431, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_595417 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansDelete_595419(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_595418(path: JsonNode;
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
  var valid_595420 = path.getOrDefault("resourceGroupName")
  valid_595420 = validateParameter(valid_595420, JString, required = true,
                                 default = nil)
  if valid_595420 != nil:
    section.add "resourceGroupName", valid_595420
  var valid_595421 = path.getOrDefault("subscriptionId")
  valid_595421 = validateParameter(valid_595421, JString, required = true,
                                 default = nil)
  if valid_595421 != nil:
    section.add "subscriptionId", valid_595421
  var valid_595422 = path.getOrDefault("recoveryPlanName")
  valid_595422 = validateParameter(valid_595422, JString, required = true,
                                 default = nil)
  if valid_595422 != nil:
    section.add "recoveryPlanName", valid_595422
  var valid_595423 = path.getOrDefault("resourceName")
  valid_595423 = validateParameter(valid_595423, JString, required = true,
                                 default = nil)
  if valid_595423 != nil:
    section.add "resourceName", valid_595423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595424 = query.getOrDefault("api-version")
  valid_595424 = validateParameter(valid_595424, JString, required = true,
                                 default = nil)
  if valid_595424 != nil:
    section.add "api-version", valid_595424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595425: Call_ReplicationRecoveryPlansDelete_595417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_595425.validator(path, query, header, formData, body)
  let scheme = call_595425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595425.url(scheme.get, call_595425.host, call_595425.base,
                         call_595425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595425, url, valid)

proc call*(call_595426: Call_ReplicationRecoveryPlansDelete_595417;
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
  var path_595427 = newJObject()
  var query_595428 = newJObject()
  add(path_595427, "resourceGroupName", newJString(resourceGroupName))
  add(query_595428, "api-version", newJString(apiVersion))
  add(path_595427, "subscriptionId", newJString(subscriptionId))
  add(path_595427, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595427, "resourceName", newJString(resourceName))
  result = call_595426.call(path_595427, query_595428, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_595417(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_595418, base: "",
    url: url_ReplicationRecoveryPlansDelete_595419, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_595443 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansFailoverCommit_595445(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_595444(path: JsonNode;
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
  var valid_595446 = path.getOrDefault("resourceGroupName")
  valid_595446 = validateParameter(valid_595446, JString, required = true,
                                 default = nil)
  if valid_595446 != nil:
    section.add "resourceGroupName", valid_595446
  var valid_595447 = path.getOrDefault("subscriptionId")
  valid_595447 = validateParameter(valid_595447, JString, required = true,
                                 default = nil)
  if valid_595447 != nil:
    section.add "subscriptionId", valid_595447
  var valid_595448 = path.getOrDefault("recoveryPlanName")
  valid_595448 = validateParameter(valid_595448, JString, required = true,
                                 default = nil)
  if valid_595448 != nil:
    section.add "recoveryPlanName", valid_595448
  var valid_595449 = path.getOrDefault("resourceName")
  valid_595449 = validateParameter(valid_595449, JString, required = true,
                                 default = nil)
  if valid_595449 != nil:
    section.add "resourceName", valid_595449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595450 = query.getOrDefault("api-version")
  valid_595450 = validateParameter(valid_595450, JString, required = true,
                                 default = nil)
  if valid_595450 != nil:
    section.add "api-version", valid_595450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595451: Call_ReplicationRecoveryPlansFailoverCommit_595443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_595451.validator(path, query, header, formData, body)
  let scheme = call_595451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595451.url(scheme.get, call_595451.host, call_595451.base,
                         call_595451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595451, url, valid)

proc call*(call_595452: Call_ReplicationRecoveryPlansFailoverCommit_595443;
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
  var path_595453 = newJObject()
  var query_595454 = newJObject()
  add(path_595453, "resourceGroupName", newJString(resourceGroupName))
  add(query_595454, "api-version", newJString(apiVersion))
  add(path_595453, "subscriptionId", newJString(subscriptionId))
  add(path_595453, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595453, "resourceName", newJString(resourceName))
  result = call_595452.call(path_595453, query_595454, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_595443(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_595444, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_595445,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_595455 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansPlannedFailover_595457(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_595456(path: JsonNode;
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
  var valid_595458 = path.getOrDefault("resourceGroupName")
  valid_595458 = validateParameter(valid_595458, JString, required = true,
                                 default = nil)
  if valid_595458 != nil:
    section.add "resourceGroupName", valid_595458
  var valid_595459 = path.getOrDefault("subscriptionId")
  valid_595459 = validateParameter(valid_595459, JString, required = true,
                                 default = nil)
  if valid_595459 != nil:
    section.add "subscriptionId", valid_595459
  var valid_595460 = path.getOrDefault("recoveryPlanName")
  valid_595460 = validateParameter(valid_595460, JString, required = true,
                                 default = nil)
  if valid_595460 != nil:
    section.add "recoveryPlanName", valid_595460
  var valid_595461 = path.getOrDefault("resourceName")
  valid_595461 = validateParameter(valid_595461, JString, required = true,
                                 default = nil)
  if valid_595461 != nil:
    section.add "resourceName", valid_595461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595462 = query.getOrDefault("api-version")
  valid_595462 = validateParameter(valid_595462, JString, required = true,
                                 default = nil)
  if valid_595462 != nil:
    section.add "api-version", valid_595462
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

proc call*(call_595464: Call_ReplicationRecoveryPlansPlannedFailover_595455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_595464.validator(path, query, header, formData, body)
  let scheme = call_595464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595464.url(scheme.get, call_595464.host, call_595464.base,
                         call_595464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595464, url, valid)

proc call*(call_595465: Call_ReplicationRecoveryPlansPlannedFailover_595455;
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
  var path_595466 = newJObject()
  var query_595467 = newJObject()
  var body_595468 = newJObject()
  add(path_595466, "resourceGroupName", newJString(resourceGroupName))
  add(query_595467, "api-version", newJString(apiVersion))
  add(path_595466, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595468 = input
  add(path_595466, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595466, "resourceName", newJString(resourceName))
  result = call_595465.call(path_595466, query_595467, nil, nil, body_595468)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_595455(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_595456, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_595457,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_595469 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansReprotect_595471(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_595470(path: JsonNode;
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
  var valid_595472 = path.getOrDefault("resourceGroupName")
  valid_595472 = validateParameter(valid_595472, JString, required = true,
                                 default = nil)
  if valid_595472 != nil:
    section.add "resourceGroupName", valid_595472
  var valid_595473 = path.getOrDefault("subscriptionId")
  valid_595473 = validateParameter(valid_595473, JString, required = true,
                                 default = nil)
  if valid_595473 != nil:
    section.add "subscriptionId", valid_595473
  var valid_595474 = path.getOrDefault("recoveryPlanName")
  valid_595474 = validateParameter(valid_595474, JString, required = true,
                                 default = nil)
  if valid_595474 != nil:
    section.add "recoveryPlanName", valid_595474
  var valid_595475 = path.getOrDefault("resourceName")
  valid_595475 = validateParameter(valid_595475, JString, required = true,
                                 default = nil)
  if valid_595475 != nil:
    section.add "resourceName", valid_595475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595476 = query.getOrDefault("api-version")
  valid_595476 = validateParameter(valid_595476, JString, required = true,
                                 default = nil)
  if valid_595476 != nil:
    section.add "api-version", valid_595476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595477: Call_ReplicationRecoveryPlansReprotect_595469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_595477.validator(path, query, header, formData, body)
  let scheme = call_595477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595477.url(scheme.get, call_595477.host, call_595477.base,
                         call_595477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595477, url, valid)

proc call*(call_595478: Call_ReplicationRecoveryPlansReprotect_595469;
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
  var path_595479 = newJObject()
  var query_595480 = newJObject()
  add(path_595479, "resourceGroupName", newJString(resourceGroupName))
  add(query_595480, "api-version", newJString(apiVersion))
  add(path_595479, "subscriptionId", newJString(subscriptionId))
  add(path_595479, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595479, "resourceName", newJString(resourceName))
  result = call_595478.call(path_595479, query_595480, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_595469(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_595470, base: "",
    url: url_ReplicationRecoveryPlansReprotect_595471, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_595481 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansTestFailover_595483(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_595482(path: JsonNode;
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
  var valid_595484 = path.getOrDefault("resourceGroupName")
  valid_595484 = validateParameter(valid_595484, JString, required = true,
                                 default = nil)
  if valid_595484 != nil:
    section.add "resourceGroupName", valid_595484
  var valid_595485 = path.getOrDefault("subscriptionId")
  valid_595485 = validateParameter(valid_595485, JString, required = true,
                                 default = nil)
  if valid_595485 != nil:
    section.add "subscriptionId", valid_595485
  var valid_595486 = path.getOrDefault("recoveryPlanName")
  valid_595486 = validateParameter(valid_595486, JString, required = true,
                                 default = nil)
  if valid_595486 != nil:
    section.add "recoveryPlanName", valid_595486
  var valid_595487 = path.getOrDefault("resourceName")
  valid_595487 = validateParameter(valid_595487, JString, required = true,
                                 default = nil)
  if valid_595487 != nil:
    section.add "resourceName", valid_595487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595488 = query.getOrDefault("api-version")
  valid_595488 = validateParameter(valid_595488, JString, required = true,
                                 default = nil)
  if valid_595488 != nil:
    section.add "api-version", valid_595488
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

proc call*(call_595490: Call_ReplicationRecoveryPlansTestFailover_595481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_595490.validator(path, query, header, formData, body)
  let scheme = call_595490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595490.url(scheme.get, call_595490.host, call_595490.base,
                         call_595490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595490, url, valid)

proc call*(call_595491: Call_ReplicationRecoveryPlansTestFailover_595481;
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
  var path_595492 = newJObject()
  var query_595493 = newJObject()
  var body_595494 = newJObject()
  add(path_595492, "resourceGroupName", newJString(resourceGroupName))
  add(query_595493, "api-version", newJString(apiVersion))
  add(path_595492, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595494 = input
  add(path_595492, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595492, "resourceName", newJString(resourceName))
  result = call_595491.call(path_595492, query_595493, nil, nil, body_595494)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_595481(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_595482, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_595483, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_595495 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansTestFailoverCleanup_595497(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_595496(path: JsonNode;
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
  var valid_595498 = path.getOrDefault("resourceGroupName")
  valid_595498 = validateParameter(valid_595498, JString, required = true,
                                 default = nil)
  if valid_595498 != nil:
    section.add "resourceGroupName", valid_595498
  var valid_595499 = path.getOrDefault("subscriptionId")
  valid_595499 = validateParameter(valid_595499, JString, required = true,
                                 default = nil)
  if valid_595499 != nil:
    section.add "subscriptionId", valid_595499
  var valid_595500 = path.getOrDefault("recoveryPlanName")
  valid_595500 = validateParameter(valid_595500, JString, required = true,
                                 default = nil)
  if valid_595500 != nil:
    section.add "recoveryPlanName", valid_595500
  var valid_595501 = path.getOrDefault("resourceName")
  valid_595501 = validateParameter(valid_595501, JString, required = true,
                                 default = nil)
  if valid_595501 != nil:
    section.add "resourceName", valid_595501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595502 = query.getOrDefault("api-version")
  valid_595502 = validateParameter(valid_595502, JString, required = true,
                                 default = nil)
  if valid_595502 != nil:
    section.add "api-version", valid_595502
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

proc call*(call_595504: Call_ReplicationRecoveryPlansTestFailoverCleanup_595495;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_595504.validator(path, query, header, formData, body)
  let scheme = call_595504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595504.url(scheme.get, call_595504.host, call_595504.base,
                         call_595504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595504, url, valid)

proc call*(call_595505: Call_ReplicationRecoveryPlansTestFailoverCleanup_595495;
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
  var path_595506 = newJObject()
  var query_595507 = newJObject()
  var body_595508 = newJObject()
  add(path_595506, "resourceGroupName", newJString(resourceGroupName))
  add(query_595507, "api-version", newJString(apiVersion))
  add(path_595506, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595508 = input
  add(path_595506, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595506, "resourceName", newJString(resourceName))
  result = call_595505.call(path_595506, query_595507, nil, nil, body_595508)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_595495(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_595496,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_595497,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_595509 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryPlansUnplannedFailover_595511(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_595510(path: JsonNode;
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
  var valid_595512 = path.getOrDefault("resourceGroupName")
  valid_595512 = validateParameter(valid_595512, JString, required = true,
                                 default = nil)
  if valid_595512 != nil:
    section.add "resourceGroupName", valid_595512
  var valid_595513 = path.getOrDefault("subscriptionId")
  valid_595513 = validateParameter(valid_595513, JString, required = true,
                                 default = nil)
  if valid_595513 != nil:
    section.add "subscriptionId", valid_595513
  var valid_595514 = path.getOrDefault("recoveryPlanName")
  valid_595514 = validateParameter(valid_595514, JString, required = true,
                                 default = nil)
  if valid_595514 != nil:
    section.add "recoveryPlanName", valid_595514
  var valid_595515 = path.getOrDefault("resourceName")
  valid_595515 = validateParameter(valid_595515, JString, required = true,
                                 default = nil)
  if valid_595515 != nil:
    section.add "resourceName", valid_595515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595516 = query.getOrDefault("api-version")
  valid_595516 = validateParameter(valid_595516, JString, required = true,
                                 default = nil)
  if valid_595516 != nil:
    section.add "api-version", valid_595516
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

proc call*(call_595518: Call_ReplicationRecoveryPlansUnplannedFailover_595509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_595518.validator(path, query, header, formData, body)
  let scheme = call_595518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595518.url(scheme.get, call_595518.host, call_595518.base,
                         call_595518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595518, url, valid)

proc call*(call_595519: Call_ReplicationRecoveryPlansUnplannedFailover_595509;
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
  var path_595520 = newJObject()
  var query_595521 = newJObject()
  var body_595522 = newJObject()
  add(path_595520, "resourceGroupName", newJString(resourceGroupName))
  add(query_595521, "api-version", newJString(apiVersion))
  add(path_595520, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595522 = input
  add(path_595520, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_595520, "resourceName", newJString(resourceName))
  result = call_595519.call(path_595520, query_595521, nil, nil, body_595522)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_595509(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_595510,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_595511,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_595523 = ref object of OpenApiRestCall_593439
proc url_ReplicationRecoveryServicesProvidersList_595525(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_595524(path: JsonNode;
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
  var valid_595526 = path.getOrDefault("resourceGroupName")
  valid_595526 = validateParameter(valid_595526, JString, required = true,
                                 default = nil)
  if valid_595526 != nil:
    section.add "resourceGroupName", valid_595526
  var valid_595527 = path.getOrDefault("subscriptionId")
  valid_595527 = validateParameter(valid_595527, JString, required = true,
                                 default = nil)
  if valid_595527 != nil:
    section.add "subscriptionId", valid_595527
  var valid_595528 = path.getOrDefault("resourceName")
  valid_595528 = validateParameter(valid_595528, JString, required = true,
                                 default = nil)
  if valid_595528 != nil:
    section.add "resourceName", valid_595528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595529 = query.getOrDefault("api-version")
  valid_595529 = validateParameter(valid_595529, JString, required = true,
                                 default = nil)
  if valid_595529 != nil:
    section.add "api-version", valid_595529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595530: Call_ReplicationRecoveryServicesProvidersList_595523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_595530.validator(path, query, header, formData, body)
  let scheme = call_595530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595530.url(scheme.get, call_595530.host, call_595530.base,
                         call_595530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595530, url, valid)

proc call*(call_595531: Call_ReplicationRecoveryServicesProvidersList_595523;
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
  var path_595532 = newJObject()
  var query_595533 = newJObject()
  add(path_595532, "resourceGroupName", newJString(resourceGroupName))
  add(query_595533, "api-version", newJString(apiVersion))
  add(path_595532, "subscriptionId", newJString(subscriptionId))
  add(path_595532, "resourceName", newJString(resourceName))
  result = call_595531.call(path_595532, query_595533, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_595523(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_595524, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_595525,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_595534 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationMappingsList_595536(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_595535(path: JsonNode;
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
  var valid_595537 = path.getOrDefault("resourceGroupName")
  valid_595537 = validateParameter(valid_595537, JString, required = true,
                                 default = nil)
  if valid_595537 != nil:
    section.add "resourceGroupName", valid_595537
  var valid_595538 = path.getOrDefault("subscriptionId")
  valid_595538 = validateParameter(valid_595538, JString, required = true,
                                 default = nil)
  if valid_595538 != nil:
    section.add "subscriptionId", valid_595538
  var valid_595539 = path.getOrDefault("resourceName")
  valid_595539 = validateParameter(valid_595539, JString, required = true,
                                 default = nil)
  if valid_595539 != nil:
    section.add "resourceName", valid_595539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595540 = query.getOrDefault("api-version")
  valid_595540 = validateParameter(valid_595540, JString, required = true,
                                 default = nil)
  if valid_595540 != nil:
    section.add "api-version", valid_595540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595541: Call_ReplicationStorageClassificationMappingsList_595534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_595541.validator(path, query, header, formData, body)
  let scheme = call_595541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595541.url(scheme.get, call_595541.host, call_595541.base,
                         call_595541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595541, url, valid)

proc call*(call_595542: Call_ReplicationStorageClassificationMappingsList_595534;
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
  var path_595543 = newJObject()
  var query_595544 = newJObject()
  add(path_595543, "resourceGroupName", newJString(resourceGroupName))
  add(query_595544, "api-version", newJString(apiVersion))
  add(path_595543, "subscriptionId", newJString(subscriptionId))
  add(path_595543, "resourceName", newJString(resourceName))
  result = call_595542.call(path_595543, query_595544, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_595534(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_595535,
    base: "", url: url_ReplicationStorageClassificationMappingsList_595536,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_595545 = ref object of OpenApiRestCall_593439
proc url_ReplicationStorageClassificationsList_595547(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_595546(path: JsonNode;
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
  var valid_595548 = path.getOrDefault("resourceGroupName")
  valid_595548 = validateParameter(valid_595548, JString, required = true,
                                 default = nil)
  if valid_595548 != nil:
    section.add "resourceGroupName", valid_595548
  var valid_595549 = path.getOrDefault("subscriptionId")
  valid_595549 = validateParameter(valid_595549, JString, required = true,
                                 default = nil)
  if valid_595549 != nil:
    section.add "subscriptionId", valid_595549
  var valid_595550 = path.getOrDefault("resourceName")
  valid_595550 = validateParameter(valid_595550, JString, required = true,
                                 default = nil)
  if valid_595550 != nil:
    section.add "resourceName", valid_595550
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595551 = query.getOrDefault("api-version")
  valid_595551 = validateParameter(valid_595551, JString, required = true,
                                 default = nil)
  if valid_595551 != nil:
    section.add "api-version", valid_595551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595552: Call_ReplicationStorageClassificationsList_595545;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_595552.validator(path, query, header, formData, body)
  let scheme = call_595552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595552.url(scheme.get, call_595552.host, call_595552.base,
                         call_595552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595552, url, valid)

proc call*(call_595553: Call_ReplicationStorageClassificationsList_595545;
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
  var path_595554 = newJObject()
  var query_595555 = newJObject()
  add(path_595554, "resourceGroupName", newJString(resourceGroupName))
  add(query_595555, "api-version", newJString(apiVersion))
  add(path_595554, "subscriptionId", newJString(subscriptionId))
  add(path_595554, "resourceName", newJString(resourceName))
  result = call_595553.call(path_595554, query_595555, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_595545(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_595546, base: "",
    url: url_ReplicationStorageClassificationsList_595547, schemes: {Scheme.Https})
type
  Call_SupportedOperatingSystemsGet_595556 = ref object of OpenApiRestCall_593439
proc url_SupportedOperatingSystemsGet_595558(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/replicationSupportedOperatingSystems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportedOperatingSystemsGet_595557(path: JsonNode; query: JsonNode;
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
  var valid_595559 = path.getOrDefault("resourceGroupName")
  valid_595559 = validateParameter(valid_595559, JString, required = true,
                                 default = nil)
  if valid_595559 != nil:
    section.add "resourceGroupName", valid_595559
  var valid_595560 = path.getOrDefault("subscriptionId")
  valid_595560 = validateParameter(valid_595560, JString, required = true,
                                 default = nil)
  if valid_595560 != nil:
    section.add "subscriptionId", valid_595560
  var valid_595561 = path.getOrDefault("resourceName")
  valid_595561 = validateParameter(valid_595561, JString, required = true,
                                 default = nil)
  if valid_595561 != nil:
    section.add "resourceName", valid_595561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595562 = query.getOrDefault("api-version")
  valid_595562 = validateParameter(valid_595562, JString, required = true,
                                 default = nil)
  if valid_595562 != nil:
    section.add "api-version", valid_595562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595563: Call_SupportedOperatingSystemsGet_595556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595563.validator(path, query, header, formData, body)
  let scheme = call_595563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595563.url(scheme.get, call_595563.host, call_595563.base,
                         call_595563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595563, url, valid)

proc call*(call_595564: Call_SupportedOperatingSystemsGet_595556;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## supportedOperatingSystemsGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595565 = newJObject()
  var query_595566 = newJObject()
  add(path_595565, "resourceGroupName", newJString(resourceGroupName))
  add(query_595566, "api-version", newJString(apiVersion))
  add(path_595565, "subscriptionId", newJString(subscriptionId))
  add(path_595565, "resourceName", newJString(resourceName))
  result = call_595564.call(path_595565, query_595566, nil, nil, nil)

var supportedOperatingSystemsGet* = Call_SupportedOperatingSystemsGet_595556(
    name: "supportedOperatingSystemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationSupportedOperatingSystems",
    validator: validate_SupportedOperatingSystemsGet_595557, base: "",
    url: url_SupportedOperatingSystemsGet_595558, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_595567 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultHealthGet_595569(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_595568(path: JsonNode; query: JsonNode;
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
  var valid_595570 = path.getOrDefault("resourceGroupName")
  valid_595570 = validateParameter(valid_595570, JString, required = true,
                                 default = nil)
  if valid_595570 != nil:
    section.add "resourceGroupName", valid_595570
  var valid_595571 = path.getOrDefault("subscriptionId")
  valid_595571 = validateParameter(valid_595571, JString, required = true,
                                 default = nil)
  if valid_595571 != nil:
    section.add "subscriptionId", valid_595571
  var valid_595572 = path.getOrDefault("resourceName")
  valid_595572 = validateParameter(valid_595572, JString, required = true,
                                 default = nil)
  if valid_595572 != nil:
    section.add "resourceName", valid_595572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595573 = query.getOrDefault("api-version")
  valid_595573 = validateParameter(valid_595573, JString, required = true,
                                 default = nil)
  if valid_595573 != nil:
    section.add "api-version", valid_595573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595574: Call_ReplicationVaultHealthGet_595567; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_595574.validator(path, query, header, formData, body)
  let scheme = call_595574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595574.url(scheme.get, call_595574.host, call_595574.base,
                         call_595574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595574, url, valid)

proc call*(call_595575: Call_ReplicationVaultHealthGet_595567;
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
  var path_595576 = newJObject()
  var query_595577 = newJObject()
  add(path_595576, "resourceGroupName", newJString(resourceGroupName))
  add(query_595577, "api-version", newJString(apiVersion))
  add(path_595576, "subscriptionId", newJString(subscriptionId))
  add(path_595576, "resourceName", newJString(resourceName))
  result = call_595575.call(path_595576, query_595577, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_595567(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_595568, base: "",
    url: url_ReplicationVaultHealthGet_595569, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_595578 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultHealthRefresh_595580(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthRefresh_595579(path: JsonNode; query: JsonNode;
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
  var valid_595581 = path.getOrDefault("resourceGroupName")
  valid_595581 = validateParameter(valid_595581, JString, required = true,
                                 default = nil)
  if valid_595581 != nil:
    section.add "resourceGroupName", valid_595581
  var valid_595582 = path.getOrDefault("subscriptionId")
  valid_595582 = validateParameter(valid_595582, JString, required = true,
                                 default = nil)
  if valid_595582 != nil:
    section.add "subscriptionId", valid_595582
  var valid_595583 = path.getOrDefault("resourceName")
  valid_595583 = validateParameter(valid_595583, JString, required = true,
                                 default = nil)
  if valid_595583 != nil:
    section.add "resourceName", valid_595583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595584 = query.getOrDefault("api-version")
  valid_595584 = validateParameter(valid_595584, JString, required = true,
                                 default = nil)
  if valid_595584 != nil:
    section.add "api-version", valid_595584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595585: Call_ReplicationVaultHealthRefresh_595578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_595585.validator(path, query, header, formData, body)
  let scheme = call_595585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595585.url(scheme.get, call_595585.host, call_595585.base,
                         call_595585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595585, url, valid)

proc call*(call_595586: Call_ReplicationVaultHealthRefresh_595578;
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
  var path_595587 = newJObject()
  var query_595588 = newJObject()
  add(path_595587, "resourceGroupName", newJString(resourceGroupName))
  add(query_595588, "api-version", newJString(apiVersion))
  add(path_595587, "subscriptionId", newJString(subscriptionId))
  add(path_595587, "resourceName", newJString(resourceName))
  result = call_595586.call(path_595587, query_595588, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_595578(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_595579, base: "",
    url: url_ReplicationVaultHealthRefresh_595580, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingList_595589 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultSettingList_595591(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/replicationVaultSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingList_595590(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
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
  var valid_595592 = path.getOrDefault("resourceGroupName")
  valid_595592 = validateParameter(valid_595592, JString, required = true,
                                 default = nil)
  if valid_595592 != nil:
    section.add "resourceGroupName", valid_595592
  var valid_595593 = path.getOrDefault("subscriptionId")
  valid_595593 = validateParameter(valid_595593, JString, required = true,
                                 default = nil)
  if valid_595593 != nil:
    section.add "subscriptionId", valid_595593
  var valid_595594 = path.getOrDefault("resourceName")
  valid_595594 = validateParameter(valid_595594, JString, required = true,
                                 default = nil)
  if valid_595594 != nil:
    section.add "resourceName", valid_595594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595595 = query.getOrDefault("api-version")
  valid_595595 = validateParameter(valid_595595, JString, required = true,
                                 default = nil)
  if valid_595595 != nil:
    section.add "api-version", valid_595595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595596: Call_ReplicationVaultSettingList_595589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_595596.validator(path, query, header, formData, body)
  let scheme = call_595596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595596.url(scheme.get, call_595596.host, call_595596.base,
                         call_595596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595596, url, valid)

proc call*(call_595597: Call_ReplicationVaultSettingList_595589;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultSettingList
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_595598 = newJObject()
  var query_595599 = newJObject()
  add(path_595598, "resourceGroupName", newJString(resourceGroupName))
  add(query_595599, "api-version", newJString(apiVersion))
  add(path_595598, "subscriptionId", newJString(subscriptionId))
  add(path_595598, "resourceName", newJString(resourceName))
  result = call_595597.call(path_595598, query_595599, nil, nil, nil)

var replicationVaultSettingList* = Call_ReplicationVaultSettingList_595589(
    name: "replicationVaultSettingList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings",
    validator: validate_ReplicationVaultSettingList_595590, base: "",
    url: url_ReplicationVaultSettingList_595591, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingCreate_595612 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultSettingCreate_595614(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "vaultSettingName" in path,
        "`vaultSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultSettings/"),
               (kind: VariableSegment, value: "vaultSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingCreate_595613(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to configure vault setting.
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
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595615 = path.getOrDefault("resourceGroupName")
  valid_595615 = validateParameter(valid_595615, JString, required = true,
                                 default = nil)
  if valid_595615 != nil:
    section.add "resourceGroupName", valid_595615
  var valid_595616 = path.getOrDefault("subscriptionId")
  valid_595616 = validateParameter(valid_595616, JString, required = true,
                                 default = nil)
  if valid_595616 != nil:
    section.add "subscriptionId", valid_595616
  var valid_595617 = path.getOrDefault("resourceName")
  valid_595617 = validateParameter(valid_595617, JString, required = true,
                                 default = nil)
  if valid_595617 != nil:
    section.add "resourceName", valid_595617
  var valid_595618 = path.getOrDefault("vaultSettingName")
  valid_595618 = validateParameter(valid_595618, JString, required = true,
                                 default = nil)
  if valid_595618 != nil:
    section.add "vaultSettingName", valid_595618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595619 = query.getOrDefault("api-version")
  valid_595619 = validateParameter(valid_595619, JString, required = true,
                                 default = nil)
  if valid_595619 != nil:
    section.add "api-version", valid_595619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Vault setting creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_595621: Call_ReplicationVaultSettingCreate_595612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to configure vault setting.
  ## 
  let valid = call_595621.validator(path, query, header, formData, body)
  let scheme = call_595621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595621.url(scheme.get, call_595621.host, call_595621.base,
                         call_595621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595621, url, valid)

proc call*(call_595622: Call_ReplicationVaultSettingCreate_595612;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; vaultSettingName: string): Recallable =
  ## replicationVaultSettingCreate
  ## The operation to configure vault setting.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Vault setting creation input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  var path_595623 = newJObject()
  var query_595624 = newJObject()
  var body_595625 = newJObject()
  add(path_595623, "resourceGroupName", newJString(resourceGroupName))
  add(query_595624, "api-version", newJString(apiVersion))
  add(path_595623, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_595625 = input
  add(path_595623, "resourceName", newJString(resourceName))
  add(path_595623, "vaultSettingName", newJString(vaultSettingName))
  result = call_595622.call(path_595623, query_595624, nil, nil, body_595625)

var replicationVaultSettingCreate* = Call_ReplicationVaultSettingCreate_595612(
    name: "replicationVaultSettingCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingCreate_595613, base: "",
    url: url_ReplicationVaultSettingCreate_595614, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingGet_595600 = ref object of OpenApiRestCall_593439
proc url_ReplicationVaultSettingGet_595602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "vaultSettingName" in path,
        "`vaultSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultSettings/"),
               (kind: VariableSegment, value: "vaultSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingGet_595601(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
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
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_595603 = path.getOrDefault("resourceGroupName")
  valid_595603 = validateParameter(valid_595603, JString, required = true,
                                 default = nil)
  if valid_595603 != nil:
    section.add "resourceGroupName", valid_595603
  var valid_595604 = path.getOrDefault("subscriptionId")
  valid_595604 = validateParameter(valid_595604, JString, required = true,
                                 default = nil)
  if valid_595604 != nil:
    section.add "subscriptionId", valid_595604
  var valid_595605 = path.getOrDefault("resourceName")
  valid_595605 = validateParameter(valid_595605, JString, required = true,
                                 default = nil)
  if valid_595605 != nil:
    section.add "resourceName", valid_595605
  var valid_595606 = path.getOrDefault("vaultSettingName")
  valid_595606 = validateParameter(valid_595606, JString, required = true,
                                 default = nil)
  if valid_595606 != nil:
    section.add "vaultSettingName", valid_595606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595607 = query.getOrDefault("api-version")
  valid_595607 = validateParameter(valid_595607, JString, required = true,
                                 default = nil)
  if valid_595607 != nil:
    section.add "api-version", valid_595607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595608: Call_ReplicationVaultSettingGet_595600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_595608.validator(path, query, header, formData, body)
  let scheme = call_595608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595608.url(scheme.get, call_595608.host, call_595608.base,
                         call_595608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595608, url, valid)

proc call*(call_595609: Call_ReplicationVaultSettingGet_595600;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vaultSettingName: string): Recallable =
  ## replicationVaultSettingGet
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  var path_595610 = newJObject()
  var query_595611 = newJObject()
  add(path_595610, "resourceGroupName", newJString(resourceGroupName))
  add(query_595611, "api-version", newJString(apiVersion))
  add(path_595610, "subscriptionId", newJString(subscriptionId))
  add(path_595610, "resourceName", newJString(resourceName))
  add(path_595610, "vaultSettingName", newJString(vaultSettingName))
  result = call_595609.call(path_595610, query_595611, nil, nil, nil)

var replicationVaultSettingGet* = Call_ReplicationVaultSettingGet_595600(
    name: "replicationVaultSettingGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingGet_595601, base: "",
    url: url_ReplicationVaultSettingGet_595602, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_595626 = ref object of OpenApiRestCall_593439
proc url_ReplicationvCentersList_595628(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_595627(path: JsonNode; query: JsonNode;
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
  var valid_595629 = path.getOrDefault("resourceGroupName")
  valid_595629 = validateParameter(valid_595629, JString, required = true,
                                 default = nil)
  if valid_595629 != nil:
    section.add "resourceGroupName", valid_595629
  var valid_595630 = path.getOrDefault("subscriptionId")
  valid_595630 = validateParameter(valid_595630, JString, required = true,
                                 default = nil)
  if valid_595630 != nil:
    section.add "subscriptionId", valid_595630
  var valid_595631 = path.getOrDefault("resourceName")
  valid_595631 = validateParameter(valid_595631, JString, required = true,
                                 default = nil)
  if valid_595631 != nil:
    section.add "resourceName", valid_595631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595632 = query.getOrDefault("api-version")
  valid_595632 = validateParameter(valid_595632, JString, required = true,
                                 default = nil)
  if valid_595632 != nil:
    section.add "api-version", valid_595632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595633: Call_ReplicationvCentersList_595626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_595633.validator(path, query, header, formData, body)
  let scheme = call_595633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595633.url(scheme.get, call_595633.host, call_595633.base,
                         call_595633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595633, url, valid)

proc call*(call_595634: Call_ReplicationvCentersList_595626;
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
  var path_595635 = newJObject()
  var query_595636 = newJObject()
  add(path_595635, "resourceGroupName", newJString(resourceGroupName))
  add(query_595636, "api-version", newJString(apiVersion))
  add(path_595635, "subscriptionId", newJString(subscriptionId))
  add(path_595635, "resourceName", newJString(resourceName))
  result = call_595634.call(path_595635, query_595636, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_595626(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_595627, base: "",
    url: url_ReplicationvCentersList_595628, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
