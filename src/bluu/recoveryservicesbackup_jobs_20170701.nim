
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RecoveryServicesBackupClient
## version: 2017-07-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicesbackup-jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackupJobsList_567863 = ref object of OpenApiRestCall_567641
proc url_BackupJobsList_567865(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/backupJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupJobsList_567864(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Provides a pageable list of jobs.
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
  var valid_568039 = path.getOrDefault("resourceGroupName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "resourceGroupName", valid_568039
  var valid_568040 = path.getOrDefault("subscriptionId")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "subscriptionId", valid_568040
  var valid_568041 = path.getOrDefault("vaultName")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "vaultName", valid_568041
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
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  var valid_568043 = query.getOrDefault("$skipToken")
  valid_568043 = validateParameter(valid_568043, JString, required = false,
                                 default = nil)
  if valid_568043 != nil:
    section.add "$skipToken", valid_568043
  var valid_568044 = query.getOrDefault("$filter")
  valid_568044 = validateParameter(valid_568044, JString, required = false,
                                 default = nil)
  if valid_568044 != nil:
    section.add "$filter", valid_568044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568067: Call_BackupJobsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a pageable list of jobs.
  ## 
  let valid = call_568067.validator(path, query, header, formData, body)
  let scheme = call_568067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568067.url(scheme.get, call_568067.host, call_568067.base,
                         call_568067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568067, url, valid)

proc call*(call_568138: Call_BackupJobsList_567863; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vaultName: string;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## backupJobsList
  ## Provides a pageable list of jobs.
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
  var path_568139 = newJObject()
  var query_568141 = newJObject()
  add(path_568139, "resourceGroupName", newJString(resourceGroupName))
  add(query_568141, "api-version", newJString(apiVersion))
  add(path_568139, "subscriptionId", newJString(subscriptionId))
  add(path_568139, "vaultName", newJString(vaultName))
  add(query_568141, "$skipToken", newJString(SkipToken))
  add(query_568141, "$filter", newJString(Filter))
  result = call_568138.call(path_568139, query_568141, nil, nil, nil)

var backupJobsList* = Call_BackupJobsList_567863(name: "backupJobsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs",
    validator: validate_BackupJobsList_567864, base: "", url: url_BackupJobsList_567865,
    schemes: {Scheme.Https})
type
  Call_JobDetailsGet_568180 = ref object of OpenApiRestCall_567641
proc url_JobDetailsGet_568182(protocol: Scheme; host: string; base: string;
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

proc validate_JobDetailsGet_568181(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets exteded information associated with the job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Name of the job whose details are to be fetched.
  ##   vaultName: JString (required)
  ##            : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568183 = path.getOrDefault("resourceGroupName")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "resourceGroupName", valid_568183
  var valid_568184 = path.getOrDefault("subscriptionId")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "subscriptionId", valid_568184
  var valid_568185 = path.getOrDefault("jobName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "jobName", valid_568185
  var valid_568186 = path.getOrDefault("vaultName")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "vaultName", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_JobDetailsGet_568180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets exteded information associated with the job.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_JobDetailsGet_568180; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          vaultName: string): Recallable =
  ## jobDetailsGet
  ## Gets exteded information associated with the job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Name of the job whose details are to be fetched.
  ##   vaultName: string (required)
  ##            : The name of the recovery services vault.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(path_568190, "resourceGroupName", newJString(resourceGroupName))
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  add(path_568190, "jobName", newJString(jobName))
  add(path_568190, "vaultName", newJString(vaultName))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var jobDetailsGet* = Call_JobDetailsGet_568180(name: "jobDetailsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupJobs/{jobName}",
    validator: validate_JobDetailsGet_568181, base: "", url: url_JobDetailsGet_568182,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
