
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BackupManagementClient
## version: 2018-09-01
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

  OpenApiRestCall_582458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582458): Option[Scheme] {.used.} =
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
  Call_BackupLocationsList_582680 = ref object of OpenApiRestCall_582458
proc url_BackupLocationsList_582682(protocol: Scheme; host: string; base: string;
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

proc validate_BackupLocationsList_582681(path: JsonNode; query: JsonNode;
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
  var valid_582842 = path.getOrDefault("resourceGroupName")
  valid_582842 = validateParameter(valid_582842, JString, required = true,
                                 default = nil)
  if valid_582842 != nil:
    section.add "resourceGroupName", valid_582842
  var valid_582843 = path.getOrDefault("subscriptionId")
  valid_582843 = validateParameter(valid_582843, JString, required = true,
                                 default = nil)
  if valid_582843 != nil:
    section.add "subscriptionId", valid_582843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582857 = query.getOrDefault("api-version")
  valid_582857 = validateParameter(valid_582857, JString, required = true,
                                 default = newJString("2018-09-01"))
  if valid_582857 != nil:
    section.add "api-version", valid_582857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582884: Call_BackupLocationsList_582680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of backup locations.
  ## 
  let valid = call_582884.validator(path, query, header, formData, body)
  let scheme = call_582884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582884.url(scheme.get, call_582884.host, call_582884.base,
                         call_582884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582884, url, valid)

proc call*(call_582955: Call_BackupLocationsList_582680; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2018-09-01"): Recallable =
  ## backupLocationsList
  ## Returns the list of backup locations.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_582956 = newJObject()
  var query_582958 = newJObject()
  add(path_582956, "resourceGroupName", newJString(resourceGroupName))
  add(query_582958, "api-version", newJString(apiVersion))
  add(path_582956, "subscriptionId", newJString(subscriptionId))
  result = call_582955.call(path_582956, query_582958, nil, nil, nil)

var backupLocationsList* = Call_BackupLocationsList_582680(
    name: "backupLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations",
    validator: validate_BackupLocationsList_582681, base: "",
    url: url_BackupLocationsList_582682, schemes: {Scheme.Https})
type
  Call_BackupLocationsUpdate_583017 = ref object of OpenApiRestCall_582458
proc url_BackupLocationsUpdate_583019(protocol: Scheme; host: string; base: string;
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

proc validate_BackupLocationsUpdate_583018(path: JsonNode; query: JsonNode;
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
  var valid_583020 = path.getOrDefault("resourceGroupName")
  valid_583020 = validateParameter(valid_583020, JString, required = true,
                                 default = nil)
  if valid_583020 != nil:
    section.add "resourceGroupName", valid_583020
  var valid_583021 = path.getOrDefault("subscriptionId")
  valid_583021 = validateParameter(valid_583021, JString, required = true,
                                 default = nil)
  if valid_583021 != nil:
    section.add "subscriptionId", valid_583021
  var valid_583022 = path.getOrDefault("location")
  valid_583022 = validateParameter(valid_583022, JString, required = true,
                                 default = nil)
  if valid_583022 != nil:
    section.add "location", valid_583022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583023 = query.getOrDefault("api-version")
  valid_583023 = validateParameter(valid_583023, JString, required = true,
                                 default = newJString("2018-09-01"))
  if valid_583023 != nil:
    section.add "api-version", valid_583023
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

proc call*(call_583025: Call_BackupLocationsUpdate_583017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a backup location.
  ## 
  let valid = call_583025.validator(path, query, header, formData, body)
  let scheme = call_583025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583025.url(scheme.get, call_583025.host, call_583025.base,
                         call_583025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583025, url, valid)

proc call*(call_583026: Call_BackupLocationsUpdate_583017;
          resourceGroupName: string; subscriptionId: string; backup: JsonNode;
          location: string; apiVersion: string = "2018-09-01"): Recallable =
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
  var path_583027 = newJObject()
  var query_583028 = newJObject()
  var body_583029 = newJObject()
  add(path_583027, "resourceGroupName", newJString(resourceGroupName))
  add(query_583028, "api-version", newJString(apiVersion))
  add(path_583027, "subscriptionId", newJString(subscriptionId))
  if backup != nil:
    body_583029 = backup
  add(path_583027, "location", newJString(location))
  result = call_583026.call(path_583027, query_583028, nil, nil, body_583029)

var backupLocationsUpdate* = Call_BackupLocationsUpdate_583017(
    name: "backupLocationsUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}",
    validator: validate_BackupLocationsUpdate_583018, base: "",
    url: url_BackupLocationsUpdate_583019, schemes: {Scheme.Https})
type
  Call_BackupLocationsGet_582997 = ref object of OpenApiRestCall_582458
proc url_BackupLocationsGet_582999(protocol: Scheme; host: string; base: string;
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

proc validate_BackupLocationsGet_582998(path: JsonNode; query: JsonNode;
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
  var valid_583009 = path.getOrDefault("resourceGroupName")
  valid_583009 = validateParameter(valid_583009, JString, required = true,
                                 default = nil)
  if valid_583009 != nil:
    section.add "resourceGroupName", valid_583009
  var valid_583010 = path.getOrDefault("subscriptionId")
  valid_583010 = validateParameter(valid_583010, JString, required = true,
                                 default = nil)
  if valid_583010 != nil:
    section.add "subscriptionId", valid_583010
  var valid_583011 = path.getOrDefault("location")
  valid_583011 = validateParameter(valid_583011, JString, required = true,
                                 default = nil)
  if valid_583011 != nil:
    section.add "location", valid_583011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583012 = query.getOrDefault("api-version")
  valid_583012 = validateParameter(valid_583012, JString, required = true,
                                 default = newJString("2018-09-01"))
  if valid_583012 != nil:
    section.add "api-version", valid_583012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583013: Call_BackupLocationsGet_582997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a specific backup location based on name.
  ## 
  let valid = call_583013.validator(path, query, header, formData, body)
  let scheme = call_583013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583013.url(scheme.get, call_583013.host, call_583013.base,
                         call_583013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583013, url, valid)

proc call*(call_583014: Call_BackupLocationsGet_582997; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2018-09-01"): Recallable =
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
  var path_583015 = newJObject()
  var query_583016 = newJObject()
  add(path_583015, "resourceGroupName", newJString(resourceGroupName))
  add(query_583016, "api-version", newJString(apiVersion))
  add(path_583015, "subscriptionId", newJString(subscriptionId))
  add(path_583015, "location", newJString(location))
  result = call_583014.call(path_583015, query_583016, nil, nil, nil)

var backupLocationsGet* = Call_BackupLocationsGet_582997(
    name: "backupLocationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}",
    validator: validate_BackupLocationsGet_582998, base: "",
    url: url_BackupLocationsGet_582999, schemes: {Scheme.Https})
type
  Call_BackupLocationsCreateBackup_583030 = ref object of OpenApiRestCall_582458
proc url_BackupLocationsCreateBackup_583032(protocol: Scheme; host: string;
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

proc validate_BackupLocationsCreateBackup_583031(path: JsonNode; query: JsonNode;
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
  var valid_583033 = path.getOrDefault("resourceGroupName")
  valid_583033 = validateParameter(valid_583033, JString, required = true,
                                 default = nil)
  if valid_583033 != nil:
    section.add "resourceGroupName", valid_583033
  var valid_583034 = path.getOrDefault("subscriptionId")
  valid_583034 = validateParameter(valid_583034, JString, required = true,
                                 default = nil)
  if valid_583034 != nil:
    section.add "subscriptionId", valid_583034
  var valid_583035 = path.getOrDefault("location")
  valid_583035 = validateParameter(valid_583035, JString, required = true,
                                 default = nil)
  if valid_583035 != nil:
    section.add "location", valid_583035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583036 = query.getOrDefault("api-version")
  valid_583036 = validateParameter(valid_583036, JString, required = true,
                                 default = newJString("2018-09-01"))
  if valid_583036 != nil:
    section.add "api-version", valid_583036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583037: Call_BackupLocationsCreateBackup_583030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Back up a specific location.
  ## 
  let valid = call_583037.validator(path, query, header, formData, body)
  let scheme = call_583037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583037.url(scheme.get, call_583037.host, call_583037.base,
                         call_583037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583037, url, valid)

proc call*(call_583038: Call_BackupLocationsCreateBackup_583030;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2018-09-01"): Recallable =
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
  var path_583039 = newJObject()
  var query_583040 = newJObject()
  add(path_583039, "resourceGroupName", newJString(resourceGroupName))
  add(query_583040, "api-version", newJString(apiVersion))
  add(path_583039, "subscriptionId", newJString(subscriptionId))
  add(path_583039, "location", newJString(location))
  result = call_583038.call(path_583039, query_583040, nil, nil, nil)

var backupLocationsCreateBackup* = Call_BackupLocationsCreateBackup_583030(
    name: "backupLocationsCreateBackup", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Backup.Admin/backupLocations/{location}/createBackup",
    validator: validate_BackupLocationsCreateBackup_583031, base: "",
    url: url_BackupLocationsCreateBackup_583032, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
