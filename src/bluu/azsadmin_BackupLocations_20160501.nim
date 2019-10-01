
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

  OpenApiRestCall_582441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-BackupLocations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupLocationsList_582663 = ref object of OpenApiRestCall_582441
proc url_BackupLocationsList_582665(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Backup.Admin/backupLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLocationsList_582664(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the list of backup locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582825 = path.getOrDefault("resourceGroupName")
  valid_582825 = validateParameter(valid_582825, JString, required = true,
                                 default = nil)
  if valid_582825 != nil:
    section.add "resourceGroupName", valid_582825
  var valid_582826 = path.getOrDefault("subscriptionId")
  valid_582826 = validateParameter(valid_582826, JString, required = true,
                                 default = nil)
  if valid_582826 != nil:
    section.add "subscriptionId", valid_582826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582840 = query.getOrDefault("api-version")
  valid_582840 = validateParameter(valid_582840, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582840 != nil:
    section.add "api-version", valid_582840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582867: Call_BackupLocationsList_582663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of backup locations.
  ## 
  let valid = call_582867.validator(path, query, header, formData, body)
  let scheme = call_582867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582867.url(scheme.get, call_582867.host, call_582867.base,
                         call_582867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582867, url, valid)

proc call*(call_582938: Call_BackupLocationsList_582663; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01"): Recallable =
  ## backupLocationsList
  ## Returns the list of backup locations.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_582939 = newJObject()
  var query_582941 = newJObject()
  add(path_582939, "resourceGroupName", newJString(resourceGroupName))
  add(query_582941, "api-version", newJString(apiVersion))
  add(path_582939, "subscriptionId", newJString(subscriptionId))
  result = call_582938.call(path_582939, query_582941, nil, nil, nil)

var backupLocationsList* = Call_BackupLocationsList_582663(
    name: "backupLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations",
    validator: validate_BackupLocationsList_582664, base: "",
    url: url_BackupLocationsList_582665, schemes: {Scheme.Https})
type
  Call_BackupLocationsUpdate_583000 = ref object of OpenApiRestCall_582441
proc url_BackupLocationsUpdate_583002(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "location")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLocationsUpdate_583001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a backup location.
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
  var valid_583003 = path.getOrDefault("resourceGroupName")
  valid_583003 = validateParameter(valid_583003, JString, required = true,
                                 default = nil)
  if valid_583003 != nil:
    section.add "resourceGroupName", valid_583003
  var valid_583004 = path.getOrDefault("subscriptionId")
  valid_583004 = validateParameter(valid_583004, JString, required = true,
                                 default = nil)
  if valid_583004 != nil:
    section.add "subscriptionId", valid_583004
  var valid_583005 = path.getOrDefault("location")
  valid_583005 = validateParameter(valid_583005, JString, required = true,
                                 default = nil)
  if valid_583005 != nil:
    section.add "location", valid_583005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583006 = query.getOrDefault("api-version")
  valid_583006 = validateParameter(valid_583006, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583006 != nil:
    section.add "api-version", valid_583006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   backup: JObject (required)
  ##         : Backup location object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583008: Call_BackupLocationsUpdate_583000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a backup location.
  ## 
  let valid = call_583008.validator(path, query, header, formData, body)
  let scheme = call_583008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583008.url(scheme.get, call_583008.host, call_583008.base,
                         call_583008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583008, url, valid)

proc call*(call_583009: Call_BackupLocationsUpdate_583000;
          resourceGroupName: string; subscriptionId: string; backup: JsonNode;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## backupLocationsUpdate
  ## Update a backup location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   backup: JObject (required)
  ##         : Backup location object.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_583010 = newJObject()
  var query_583011 = newJObject()
  var body_583012 = newJObject()
  add(path_583010, "resourceGroupName", newJString(resourceGroupName))
  add(query_583011, "api-version", newJString(apiVersion))
  add(path_583010, "subscriptionId", newJString(subscriptionId))
  if backup != nil:
    body_583012 = backup
  add(path_583010, "location", newJString(location))
  result = call_583009.call(path_583010, query_583011, nil, nil, body_583012)

var backupLocationsUpdate* = Call_BackupLocationsUpdate_583000(
    name: "backupLocationsUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}",
    validator: validate_BackupLocationsUpdate_583001, base: "",
    url: url_BackupLocationsUpdate_583002, schemes: {Scheme.Https})
type
  Call_BackupLocationsGet_582980 = ref object of OpenApiRestCall_582441
proc url_BackupLocationsGet_582982(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "location")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLocationsGet_582981(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns a specific backup location based on name.
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
  var valid_582992 = path.getOrDefault("resourceGroupName")
  valid_582992 = validateParameter(valid_582992, JString, required = true,
                                 default = nil)
  if valid_582992 != nil:
    section.add "resourceGroupName", valid_582992
  var valid_582993 = path.getOrDefault("subscriptionId")
  valid_582993 = validateParameter(valid_582993, JString, required = true,
                                 default = nil)
  if valid_582993 != nil:
    section.add "subscriptionId", valid_582993
  var valid_582994 = path.getOrDefault("location")
  valid_582994 = validateParameter(valid_582994, JString, required = true,
                                 default = nil)
  if valid_582994 != nil:
    section.add "location", valid_582994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582995 = query.getOrDefault("api-version")
  valid_582995 = validateParameter(valid_582995, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582995 != nil:
    section.add "api-version", valid_582995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582996: Call_BackupLocationsGet_582980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a specific backup location based on name.
  ## 
  let valid = call_582996.validator(path, query, header, formData, body)
  let scheme = call_582996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582996.url(scheme.get, call_582996.host, call_582996.base,
                         call_582996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582996, url, valid)

proc call*(call_582997: Call_BackupLocationsGet_582980; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## backupLocationsGet
  ## Returns a specific backup location based on name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_582998 = newJObject()
  var query_582999 = newJObject()
  add(path_582998, "resourceGroupName", newJString(resourceGroupName))
  add(query_582999, "api-version", newJString(apiVersion))
  add(path_582998, "subscriptionId", newJString(subscriptionId))
  add(path_582998, "location", newJString(location))
  result = call_582997.call(path_582998, query_582999, nil, nil, nil)

var backupLocationsGet* = Call_BackupLocationsGet_582980(
    name: "backupLocationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}",
    validator: validate_BackupLocationsGet_582981, base: "",
    url: url_BackupLocationsGet_582982, schemes: {Scheme.Https})
type
  Call_BackupLocationsCreateBackup_583013 = ref object of OpenApiRestCall_582441
proc url_BackupLocationsCreateBackup_583015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/createBackup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLocationsCreateBackup_583014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Back up a specific location.
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
  var valid_583016 = path.getOrDefault("resourceGroupName")
  valid_583016 = validateParameter(valid_583016, JString, required = true,
                                 default = nil)
  if valid_583016 != nil:
    section.add "resourceGroupName", valid_583016
  var valid_583017 = path.getOrDefault("subscriptionId")
  valid_583017 = validateParameter(valid_583017, JString, required = true,
                                 default = nil)
  if valid_583017 != nil:
    section.add "subscriptionId", valid_583017
  var valid_583018 = path.getOrDefault("location")
  valid_583018 = validateParameter(valid_583018, JString, required = true,
                                 default = nil)
  if valid_583018 != nil:
    section.add "location", valid_583018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583019 = query.getOrDefault("api-version")
  valid_583019 = validateParameter(valid_583019, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583019 != nil:
    section.add "api-version", valid_583019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583020: Call_BackupLocationsCreateBackup_583013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Back up a specific location.
  ## 
  let valid = call_583020.validator(path, query, header, formData, body)
  let scheme = call_583020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583020.url(scheme.get, call_583020.host, call_583020.base,
                         call_583020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583020, url, valid)

proc call*(call_583021: Call_BackupLocationsCreateBackup_583013;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## backupLocationsCreateBackup
  ## Back up a specific location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the backup location.
  var path_583022 = newJObject()
  var query_583023 = newJObject()
  add(path_583022, "resourceGroupName", newJString(resourceGroupName))
  add(query_583023, "api-version", newJString(apiVersion))
  add(path_583022, "subscriptionId", newJString(subscriptionId))
  add(path_583022, "location", newJString(location))
  result = call_583021.call(path_583022, query_583023, nil, nil, nil)

var backupLocationsCreateBackup* = Call_BackupLocationsCreateBackup_583013(
    name: "backupLocationsCreateBackup", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}/createBackup",
    validator: validate_BackupLocationsCreateBackup_583014, base: "",
    url: url_BackupLocationsCreateBackup_583015, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
