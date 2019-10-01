
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BackupManagementClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Backup Management Client.
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

  OpenApiRestCall_582442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Backups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupsList_582664 = ref object of OpenApiRestCall_582442
proc url_BackupsList_582666(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Backup.Admin/backupLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/backups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsList_582665(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of backups from a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the backup location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582826 = path.getOrDefault("resourceGroupName")
  valid_582826 = validateParameter(valid_582826, JString, required = true,
                                 default = nil)
  if valid_582826 != nil:
    section.add "resourceGroupName", valid_582826
  var valid_582827 = path.getOrDefault("subscriptionId")
  valid_582827 = validateParameter(valid_582827, JString, required = true,
                                 default = nil)
  if valid_582827 != nil:
    section.add "subscriptionId", valid_582827
  var valid_582828 = path.getOrDefault("location")
  valid_582828 = validateParameter(valid_582828, JString, required = true,
                                 default = nil)
  if valid_582828 != nil:
    section.add "location", valid_582828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582842 = query.getOrDefault("api-version")
  valid_582842 = validateParameter(valid_582842, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582842 != nil:
    section.add "api-version", valid_582842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582869: Call_BackupsList_582664; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of backups from a location.
  ## 
  let valid = call_582869.validator(path, query, header, formData, body)
  let scheme = call_582869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582869.url(scheme.get, call_582869.host, call_582869.base,
                         call_582869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582869, url, valid)

proc call*(call_582940: Call_BackupsList_582664; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## backupsList
  ## Returns a list of backups from a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_582941 = newJObject()
  var query_582943 = newJObject()
  add(path_582941, "resourceGroupName", newJString(resourceGroupName))
  add(query_582943, "api-version", newJString(apiVersion))
  add(path_582941, "subscriptionId", newJString(subscriptionId))
  add(path_582941, "location", newJString(location))
  result = call_582940.call(path_582941, query_582943, nil, nil, nil)

var backupsList* = Call_BackupsList_582664(name: "backupsList",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}/backups",
                                        validator: validate_BackupsList_582665,
                                        base: "", url: url_BackupsList_582666,
                                        schemes: {Scheme.Https})
type
  Call_BackupsGet_582982 = ref object of OpenApiRestCall_582442
proc url_BackupsGet_582984(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "backup" in path, "`backup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Backup.Admin/backupLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsGet_582983(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a backup from a location based on name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backup: JString (required)
  ##         : Name of the backup.
  ##   location: JString (required)
  ##           : Name of the backup location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582994 = path.getOrDefault("resourceGroupName")
  valid_582994 = validateParameter(valid_582994, JString, required = true,
                                 default = nil)
  if valid_582994 != nil:
    section.add "resourceGroupName", valid_582994
  var valid_582995 = path.getOrDefault("subscriptionId")
  valid_582995 = validateParameter(valid_582995, JString, required = true,
                                 default = nil)
  if valid_582995 != nil:
    section.add "subscriptionId", valid_582995
  var valid_582996 = path.getOrDefault("backup")
  valid_582996 = validateParameter(valid_582996, JString, required = true,
                                 default = nil)
  if valid_582996 != nil:
    section.add "backup", valid_582996
  var valid_582997 = path.getOrDefault("location")
  valid_582997 = validateParameter(valid_582997, JString, required = true,
                                 default = nil)
  if valid_582997 != nil:
    section.add "location", valid_582997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582998 = query.getOrDefault("api-version")
  valid_582998 = validateParameter(valid_582998, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582998 != nil:
    section.add "api-version", valid_582998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582999: Call_BackupsGet_582982; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a backup from a location based on name.
  ## 
  let valid = call_582999.validator(path, query, header, formData, body)
  let scheme = call_582999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582999.url(scheme.get, call_582999.host, call_582999.base,
                         call_582999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582999, url, valid)

proc call*(call_583000: Call_BackupsGet_582982; resourceGroupName: string;
          subscriptionId: string; backup: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## backupsGet
  ## Returns a backup from a location based on name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backup: string (required)
  ##         : Name of the backup.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_583001 = newJObject()
  var query_583002 = newJObject()
  add(path_583001, "resourceGroupName", newJString(resourceGroupName))
  add(query_583002, "api-version", newJString(apiVersion))
  add(path_583001, "subscriptionId", newJString(subscriptionId))
  add(path_583001, "backup", newJString(backup))
  add(path_583001, "location", newJString(location))
  result = call_583000.call(path_583001, query_583002, nil, nil, nil)

var backupsGet* = Call_BackupsGet_582982(name: "backupsGet",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}/backups/{backup}",
                                      validator: validate_BackupsGet_582983,
                                      base: "", url: url_BackupsGet_582984,
                                      schemes: {Scheme.Https})
type
  Call_BackupsRestore_583003 = ref object of OpenApiRestCall_582442
proc url_BackupsRestore_583005(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "backup" in path, "`backup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Backup.Admin/backupLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/backups/"),
               (kind: VariableSegment, value: "backup"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupsRestore_583004(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restore a backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backup: JString (required)
  ##         : Name of the backup.
  ##   location: JString (required)
  ##           : Name of the backup location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_583006 = path.getOrDefault("resourceGroupName")
  valid_583006 = validateParameter(valid_583006, JString, required = true,
                                 default = nil)
  if valid_583006 != nil:
    section.add "resourceGroupName", valid_583006
  var valid_583007 = path.getOrDefault("subscriptionId")
  valid_583007 = validateParameter(valid_583007, JString, required = true,
                                 default = nil)
  if valid_583007 != nil:
    section.add "subscriptionId", valid_583007
  var valid_583008 = path.getOrDefault("backup")
  valid_583008 = validateParameter(valid_583008, JString, required = true,
                                 default = nil)
  if valid_583008 != nil:
    section.add "backup", valid_583008
  var valid_583009 = path.getOrDefault("location")
  valid_583009 = validateParameter(valid_583009, JString, required = true,
                                 default = nil)
  if valid_583009 != nil:
    section.add "location", valid_583009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583010 = query.getOrDefault("api-version")
  valid_583010 = validateParameter(valid_583010, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583010 != nil:
    section.add "api-version", valid_583010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583011: Call_BackupsRestore_583003; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restore a backup.
  ## 
  let valid = call_583011.validator(path, query, header, formData, body)
  let scheme = call_583011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583011.url(scheme.get, call_583011.host, call_583011.base,
                         call_583011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583011, url, valid)

proc call*(call_583012: Call_BackupsRestore_583003; resourceGroupName: string;
          subscriptionId: string; backup: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## backupsRestore
  ## Restore a backup.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backup: string (required)
  ##         : Name of the backup.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_583013 = newJObject()
  var query_583014 = newJObject()
  add(path_583013, "resourceGroupName", newJString(resourceGroupName))
  add(query_583014, "api-version", newJString(apiVersion))
  add(path_583013, "subscriptionId", newJString(subscriptionId))
  add(path_583013, "backup", newJString(backup))
  add(path_583013, "location", newJString(location))
  result = call_583012.call(path_583013, query_583014, nil, nil, nil)

var backupsRestore* = Call_BackupsRestore_583003(name: "backupsRestore",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}/backups/{backup}/restore",
    validator: validate_BackupsRestore_583004, base: "", url: url_BackupsRestore_583005,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
