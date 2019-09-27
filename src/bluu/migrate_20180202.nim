
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Migrate
## version: 2018-02-02
## termsOfService: (not provided)
## license: (not provided)
## 
## Move your workloads to Azure.
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

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
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
  macServiceName = "migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593648 = ref object of OpenApiRestCall_593426
proc url_OperationsList_593650(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593649(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593755: Call_OperationsList_593648; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_593755.validator(path, query, header, formData, body)
  let scheme = call_593755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593755.url(scheme.get, call_593755.host, call_593755.base,
                         call_593755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593755, url, valid)

proc call*(call_593839: Call_OperationsList_593648): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_593839.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_593648(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_593649, base: "", url: url_OperationsList_593650,
    schemes: {Scheme.Https})
type
  Call_AssessmentOptionsGet_593877 = ref object of OpenApiRestCall_593426
proc url_AssessmentOptionsGet_593879(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/assessmentOptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentOptionsGet_593878(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the available options for the properties of an assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: JString (required)
  ##               : Azure region in which the project is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593957 = path.getOrDefault("subscriptionId")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "subscriptionId", valid_593957
  var valid_593958 = path.getOrDefault("locationName")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "locationName", valid_593958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_593973 = header.getOrDefault("Accept-Language")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "Accept-Language", valid_593973
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_AssessmentOptionsGet_593877; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the available options for the properties of an assessment.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_AssessmentOptionsGet_593877; subscriptionId: string;
          locationName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentOptionsGet
  ## Get the available options for the properties of an assessment.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: string (required)
  ##               : Azure region in which the project is created.
  var path_593976 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  add(path_593976, "locationName", newJString(locationName))
  result = call_593975.call(path_593976, query_593978, nil, nil, nil)

var assessmentOptionsGet* = Call_AssessmentOptionsGet_593877(
    name: "assessmentOptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/assessmentOptions",
    validator: validate_AssessmentOptionsGet_593878, base: "",
    url: url_AssessmentOptionsGet_593879, schemes: {Scheme.Https})
type
  Call_LocationCheckNameAvailability_593980 = ref object of OpenApiRestCall_593426
proc url_LocationCheckNameAvailability_593982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationCheckNameAvailability_593981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the project name is available in the specified region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   locationName: JString (required)
  ##               : The desired region for the name check.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  var valid_594001 = path.getOrDefault("locationName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "locationName", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_LocationCheckNameAvailability_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the project name is available in the specified region.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_LocationCheckNameAvailability_593980;
          subscriptionId: string; parameters: JsonNode; locationName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## locationCheckNameAvailability
  ## Checks whether the project name is available in the specified region.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   parameters: JObject (required)
  ##             : Properties needed to check the availability of a name.
  ##   locationName: string (required)
  ##               : The desired region for the name check.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594008 = parameters
  add(path_594006, "locationName", newJString(locationName))
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var locationCheckNameAvailability* = Call_LocationCheckNameAvailability_593980(
    name: "locationCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationCheckNameAvailability_593981, base: "",
    url: url_LocationCheckNameAvailability_593982, schemes: {Scheme.Https})
type
  Call_ProjectsListBySubscription_594009 = ref object of OpenApiRestCall_593426
proc url_ProjectsListBySubscription_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListBySubscription_594010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594014 = header.getOrDefault("Accept-Language")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "Accept-Language", valid_594014
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_ProjectsListBySubscription_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the subscription.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ProjectsListBySubscription_594009;
          subscriptionId: string; apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListBySubscription
  ## Get all the projects in the subscription.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var projectsListBySubscription* = Call_ProjectsListBySubscription_594009(
    name: "projectsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListBySubscription_594010, base: "",
    url: url_ProjectsListBySubscription_594011, schemes: {Scheme.Https})
type
  Call_AssessmentsListByProject_594019 = ref object of OpenApiRestCall_593426
proc url_AssessmentsListByProject_594021(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByProject_594020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("projectName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "projectName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594026 = header.getOrDefault("Accept-Language")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "Accept-Language", valid_594026
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_AssessmentsListByProject_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_AssessmentsListByProject_594019;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsListByProject
  ## Get all assessments created in the project.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  add(path_594029, "projectName", newJString(projectName))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var assessmentsListByProject* = Call_AssessmentsListByProject_594019(
    name: "assessmentsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/assessments",
    validator: validate_AssessmentsListByProject_594020, base: "",
    url: url_AssessmentsListByProject_594021, schemes: {Scheme.Https})
type
  Call_GroupsListByProject_594031 = ref object of OpenApiRestCall_593426
proc url_GroupsListByProject_594033(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsListByProject_594032(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("projectName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "projectName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594038 = header.getOrDefault("Accept-Language")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "Accept-Language", valid_594038
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_GroupsListByProject_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_GroupsListByProject_594031; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsListByProject
  ## Get all groups created in the project. Returns a json array of objects of type 'group' as specified in the Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  add(path_594041, "projectName", newJString(projectName))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var groupsListByProject* = Call_GroupsListByProject_594031(
    name: "groupsListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups",
    validator: validate_GroupsListByProject_594032, base: "",
    url: url_GroupsListByProject_594033, schemes: {Scheme.Https})
type
  Call_GroupsCreate_594056 = ref object of OpenApiRestCall_593426
proc url_GroupsCreate_594058(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsCreate_594057(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("groupName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "groupName", valid_594061
  var valid_594062 = path.getOrDefault("projectName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "projectName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594064 = header.getOrDefault("Accept-Language")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "Accept-Language", valid_594064
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   group: JObject
  ##        : New or Updated Group object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_GroupsCreate_594056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_GroupsCreate_594056; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"; group: JsonNode = nil): Recallable =
  ## groupsCreate
  ## Create a new group by sending a json object of type 'group' as given in Models section as part of the Request Body. The group name in a project is unique. Labels can be applied on a group as part of creation.
  ## 
  ## If a group with the groupName specified in the URL already exists, then this call acts as an update.
  ## 
  ## This operation is Idempotent.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   group: JObject
  ##        : New or Updated Group object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  var body_594070 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  if group != nil:
    body_594070 = group
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "groupName", newJString(groupName))
  add(path_594068, "projectName", newJString(projectName))
  result = call_594067.call(path_594068, query_594069, nil, nil, body_594070)

var groupsCreate* = Call_GroupsCreate_594056(name: "groupsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsCreate_594057, base: "", url: url_GroupsCreate_594058,
    schemes: {Scheme.Https})
type
  Call_GroupsGet_594043 = ref object of OpenApiRestCall_593426
proc url_GroupsGet_594045(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsGet_594044(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("groupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "groupName", valid_594048
  var valid_594049 = path.getOrDefault("projectName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "projectName", valid_594049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594051 = header.getOrDefault("Accept-Language")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "Accept-Language", valid_594051
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_GroupsGet_594043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_GroupsGet_594043; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsGet
  ## Get information related to a specific group in the project. Returns a json object of type 'group' as specified in the models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(path_594054, "groupName", newJString(groupName))
  add(path_594054, "projectName", newJString(projectName))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var groupsGet* = Call_GroupsGet_594043(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
                                    validator: validate_GroupsGet_594044,
                                    base: "", url: url_GroupsGet_594045,
                                    schemes: {Scheme.Https})
type
  Call_GroupsDelete_594071 = ref object of OpenApiRestCall_593426
proc url_GroupsDelete_594073(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsDelete_594072(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("groupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "groupName", valid_594076
  var valid_594077 = path.getOrDefault("projectName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "projectName", valid_594077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594078 = query.getOrDefault("api-version")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594078 != nil:
    section.add "api-version", valid_594078
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594079 = header.getOrDefault("Accept-Language")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "Accept-Language", valid_594079
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_GroupsDelete_594071; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_GroupsDelete_594071; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## groupsDelete
  ## Delete the group from the project. The machines remain in the project. Deleting a non-existent group results in a no-operation.
  ## 
  ## A group is an aggregation mechanism for machines in a project. Therefore, deleting group does not delete machines in it.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  add(path_594082, "groupName", newJString(groupName))
  add(path_594082, "projectName", newJString(projectName))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_594071(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}",
    validator: validate_GroupsDelete_594072, base: "", url: url_GroupsDelete_594073,
    schemes: {Scheme.Https})
type
  Call_AssessmentsListByGroup_594084 = ref object of OpenApiRestCall_593426
proc url_AssessmentsListByGroup_594086(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsListByGroup_594085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("subscriptionId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "subscriptionId", valid_594088
  var valid_594089 = path.getOrDefault("groupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "groupName", valid_594089
  var valid_594090 = path.getOrDefault("projectName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "projectName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594092 = header.getOrDefault("Accept-Language")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "Accept-Language", valid_594092
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_AssessmentsListByGroup_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_AssessmentsListByGroup_594084;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsListByGroup
  ## Get all assessments created for the specified group.
  ## 
  ## Returns a json array of objects of type 'assessment' as specified in Models section.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "groupName", newJString(groupName))
  add(path_594095, "projectName", newJString(projectName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var assessmentsListByGroup* = Call_AssessmentsListByGroup_594084(
    name: "assessmentsListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments",
    validator: validate_AssessmentsListByGroup_594085, base: "",
    url: url_AssessmentsListByGroup_594086, schemes: {Scheme.Https})
type
  Call_AssessmentsCreate_594111 = ref object of OpenApiRestCall_593426
proc url_AssessmentsCreate_594113(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsCreate_594112(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("groupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "groupName", valid_594116
  var valid_594117 = path.getOrDefault("projectName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "projectName", valid_594117
  var valid_594118 = path.getOrDefault("assessmentName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "assessmentName", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594120 = header.getOrDefault("Accept-Language")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "Accept-Language", valid_594120
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_AssessmentsCreate_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_AssessmentsCreate_594111; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02";
          assessment: JsonNode = nil): Recallable =
  ## assessmentsCreate
  ## Create a new assessment with the given name and the specified settings. Since name of an assessment in a project is a unique identifier, if an assessment with the name provided already exists, then the existing assessment is updated.
  ## 
  ## Any PUT operation, resulting in either create or update on an assessment, will cause the assessment to go in a "InProgress" state. This will be indicated by the field 'computationState' on the Assessment object. During this time no other PUT operation will be allowed on that assessment object, nor will a Delete operation. Once the computation for the assessment is complete, the field 'computationState' will be updated to 'Ready', and then other PUT or DELETE operations can happen on the assessment.
  ## 
  ## When assessment is under computation, any PUT will lead to a 400 - Bad Request error.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessment: JObject
  ##             : New or Updated Assessment object.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  var body_594126 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(query_594125, "api-version", newJString(apiVersion))
  if assessment != nil:
    body_594126 = assessment
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(path_594124, "groupName", newJString(groupName))
  add(path_594124, "projectName", newJString(projectName))
  add(path_594124, "assessmentName", newJString(assessmentName))
  result = call_594123.call(path_594124, query_594125, nil, nil, body_594126)

var assessmentsCreate* = Call_AssessmentsCreate_594111(name: "assessmentsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsCreate_594112, base: "",
    url: url_AssessmentsCreate_594113, schemes: {Scheme.Https})
type
  Call_AssessmentsGet_594097 = ref object of OpenApiRestCall_593426
proc url_AssessmentsGet_594099(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGet_594098(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("groupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "groupName", valid_594102
  var valid_594103 = path.getOrDefault("projectName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "projectName", valid_594103
  var valid_594104 = path.getOrDefault("assessmentName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "assessmentName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594106 = header.getOrDefault("Accept-Language")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "Accept-Language", valid_594106
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_AssessmentsGet_594097; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_AssessmentsGet_594097; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsGet
  ## Get an existing assessment with the specified name. Returns a json object of type 'assessment' as specified in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "groupName", newJString(groupName))
  add(path_594109, "projectName", newJString(projectName))
  add(path_594109, "assessmentName", newJString(assessmentName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var assessmentsGet* = Call_AssessmentsGet_594097(name: "assessmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsGet_594098, base: "", url: url_AssessmentsGet_594099,
    schemes: {Scheme.Https})
type
  Call_AssessmentsDelete_594127 = ref object of OpenApiRestCall_593426
proc url_AssessmentsDelete_594129(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsDelete_594128(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("groupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "groupName", valid_594132
  var valid_594133 = path.getOrDefault("projectName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "projectName", valid_594133
  var valid_594134 = path.getOrDefault("assessmentName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "assessmentName", valid_594134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594136 = header.getOrDefault("Accept-Language")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "Accept-Language", valid_594136
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_AssessmentsDelete_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_AssessmentsDelete_594127; resourceGroupName: string;
          subscriptionId: string; groupName: string; projectName: string;
          assessmentName: string; apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsDelete
  ## Delete an assessment from the project. The machines remain in the assessment. Deleting a non-existent assessment results in a no-operation.
  ## 
  ## When an assessment is under computation, as indicated by the 'computationState' field, it cannot be deleted. Any such attempt will return a 400 - Bad Request.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(path_594139, "resourceGroupName", newJString(resourceGroupName))
  add(query_594140, "api-version", newJString(apiVersion))
  add(path_594139, "subscriptionId", newJString(subscriptionId))
  add(path_594139, "groupName", newJString(groupName))
  add(path_594139, "projectName", newJString(projectName))
  add(path_594139, "assessmentName", newJString(assessmentName))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var assessmentsDelete* = Call_AssessmentsDelete_594127(name: "assessmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}",
    validator: validate_AssessmentsDelete_594128, base: "",
    url: url_AssessmentsDelete_594129, schemes: {Scheme.Https})
type
  Call_AssessedMachinesListByAssessment_594141 = ref object of OpenApiRestCall_593426
proc url_AssessedMachinesListByAssessment_594143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesListByAssessment_594142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("subscriptionId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "subscriptionId", valid_594145
  var valid_594146 = path.getOrDefault("groupName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "groupName", valid_594146
  var valid_594147 = path.getOrDefault("projectName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "projectName", valid_594147
  var valid_594148 = path.getOrDefault("assessmentName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "assessmentName", valid_594148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594150 = header.getOrDefault("Accept-Language")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "Accept-Language", valid_594150
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_AssessedMachinesListByAssessment_594141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_AssessedMachinesListByAssessment_594141;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessedMachinesListByAssessment
  ## Get list of machines that assessed as part of the specified assessment. Returns a json array of objects of type 'assessedMachine' as specified in the Models section.
  ## 
  ## Whenever an assessment is created or updated, it goes under computation. During this phase, the 'status' field of Assessment object reports 'Computing'.
  ## During the period when the assessment is under computation, the list of assessed machines is empty and no assessed machines are returned by this call.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(path_594153, "resourceGroupName", newJString(resourceGroupName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "subscriptionId", newJString(subscriptionId))
  add(path_594153, "groupName", newJString(groupName))
  add(path_594153, "projectName", newJString(projectName))
  add(path_594153, "assessmentName", newJString(assessmentName))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var assessedMachinesListByAssessment* = Call_AssessedMachinesListByAssessment_594141(
    name: "assessedMachinesListByAssessment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines",
    validator: validate_AssessedMachinesListByAssessment_594142, base: "",
    url: url_AssessedMachinesListByAssessment_594143, schemes: {Scheme.Https})
type
  Call_AssessedMachinesGet_594155 = ref object of OpenApiRestCall_593426
proc url_AssessedMachinesGet_594157(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  assert "assessedMachineName" in path,
        "`assessedMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/assessedMachines/"),
               (kind: VariableSegment, value: "assessedMachineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessedMachinesGet_594156(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   assessedMachineName: JString (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594158 = path.getOrDefault("resourceGroupName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "resourceGroupName", valid_594158
  var valid_594159 = path.getOrDefault("assessedMachineName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "assessedMachineName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  var valid_594161 = path.getOrDefault("groupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "groupName", valid_594161
  var valid_594162 = path.getOrDefault("projectName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "projectName", valid_594162
  var valid_594163 = path.getOrDefault("assessmentName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "assessmentName", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594165 = header.getOrDefault("Accept-Language")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "Accept-Language", valid_594165
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_AssessedMachinesGet_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_AssessedMachinesGet_594155; resourceGroupName: string;
          assessedMachineName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessedMachinesGet
  ## Get an assessed machine with its size & cost estimate that was evaluated in the specified assessment.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   assessedMachineName: string (required)
  ##                      : Unique name of an assessed machine evaluated as part of an assessment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "assessedMachineName", newJString(assessedMachineName))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "groupName", newJString(groupName))
  add(path_594168, "projectName", newJString(projectName))
  add(path_594168, "assessmentName", newJString(assessmentName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var assessedMachinesGet* = Call_AssessedMachinesGet_594155(
    name: "assessedMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/assessedMachines/{assessedMachineName}",
    validator: validate_AssessedMachinesGet_594156, base: "",
    url: url_AssessedMachinesGet_594157, schemes: {Scheme.Https})
type
  Call_AssessmentsGetReportDownloadUrl_594170 = ref object of OpenApiRestCall_593426
proc url_AssessmentsGetReportDownloadUrl_594172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "assessmentName" in path, "`assessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/assessments/"),
               (kind: VariableSegment, value: "assessmentName"),
               (kind: ConstantSegment, value: "/downloadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssessmentsGetReportDownloadUrl_594171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: JString (required)
  ##            : Unique name of a group within a project.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: JString (required)
  ##                 : Unique name of an assessment within a project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  var valid_594175 = path.getOrDefault("groupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "groupName", valid_594175
  var valid_594176 = path.getOrDefault("projectName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "projectName", valid_594176
  var valid_594177 = path.getOrDefault("assessmentName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "assessmentName", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594179 = header.getOrDefault("Accept-Language")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "Accept-Language", valid_594179
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_AssessmentsGetReportDownloadUrl_594170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the URL for downloading the assessment in a report format.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_AssessmentsGetReportDownloadUrl_594170;
          resourceGroupName: string; subscriptionId: string; groupName: string;
          projectName: string; assessmentName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## assessmentsGetReportDownloadUrl
  ## Get the URL for downloading the assessment in a report format.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   groupName: string (required)
  ##            : Unique name of a group within a project.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  ##   assessmentName: string (required)
  ##                 : Unique name of an assessment within a project.
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(path_594182, "groupName", newJString(groupName))
  add(path_594182, "projectName", newJString(projectName))
  add(path_594182, "assessmentName", newJString(assessmentName))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var assessmentsGetReportDownloadUrl* = Call_AssessmentsGetReportDownloadUrl_594170(
    name: "assessmentsGetReportDownloadUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/groups/{groupName}/assessments/{assessmentName}/downloadUrl",
    validator: validate_AssessmentsGetReportDownloadUrl_594171, base: "",
    url: url_AssessmentsGetReportDownloadUrl_594172, schemes: {Scheme.Https})
type
  Call_MachinesListByProject_594184 = ref object of OpenApiRestCall_593426
proc url_MachinesListByProject_594186(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListByProject_594185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594187 = path.getOrDefault("resourceGroupName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceGroupName", valid_594187
  var valid_594188 = path.getOrDefault("subscriptionId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "subscriptionId", valid_594188
  var valid_594189 = path.getOrDefault("projectName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "projectName", valid_594189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594190 = query.getOrDefault("api-version")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594190 != nil:
    section.add "api-version", valid_594190
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594191 = header.getOrDefault("Accept-Language")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "Accept-Language", valid_594191
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_MachinesListByProject_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_MachinesListByProject_594184;
          resourceGroupName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## machinesListByProject
  ## Get data of all the machines available in the project. Returns a json array of objects of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(path_594194, "resourceGroupName", newJString(resourceGroupName))
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "subscriptionId", newJString(subscriptionId))
  add(path_594194, "projectName", newJString(projectName))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var machinesListByProject* = Call_MachinesListByProject_594184(
    name: "machinesListByProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines",
    validator: validate_MachinesListByProject_594185, base: "",
    url: url_MachinesListByProject_594186, schemes: {Scheme.Https})
type
  Call_MachinesGet_594196 = ref object of OpenApiRestCall_593426
proc url_MachinesGet_594198(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGet_594197(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   machineName: JString (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("machineName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "machineName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("projectName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "projectName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594204 = header.getOrDefault("Accept-Language")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "Accept-Language", valid_594204
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_MachinesGet_594196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_MachinesGet_594196; resourceGroupName: string;
          machineName: string; subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## machinesGet
  ## Get the machine with the specified name. Returns a json object of type 'machine' defined in Models section.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   machineName: string (required)
  ##              : Unique name of a machine in private datacenter.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "machineName", newJString(machineName))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  add(path_594207, "projectName", newJString(projectName))
  result = call_594206.call(path_594207, query_594208, nil, nil, nil)

var machinesGet* = Call_MachinesGet_594196(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/machines/{machineName}",
                                        validator: validate_MachinesGet_594197,
                                        base: "", url: url_MachinesGet_594198,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsListByResourceGroup_594209 = ref object of OpenApiRestCall_593426
proc url_ProjectsListByResourceGroup_594211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListByResourceGroup_594210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the projects in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594212 = path.getOrDefault("resourceGroupName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "resourceGroupName", valid_594212
  var valid_594213 = path.getOrDefault("subscriptionId")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscriptionId", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594214 = query.getOrDefault("api-version")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594214 != nil:
    section.add "api-version", valid_594214
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594215 = header.getOrDefault("Accept-Language")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "Accept-Language", valid_594215
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_ProjectsListByResourceGroup_594209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the projects in the resource group.
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_ProjectsListByResourceGroup_594209;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsListByResourceGroup
  ## Get all the projects in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  add(path_594218, "resourceGroupName", newJString(resourceGroupName))
  add(query_594219, "api-version", newJString(apiVersion))
  add(path_594218, "subscriptionId", newJString(subscriptionId))
  result = call_594217.call(path_594218, query_594219, nil, nil, nil)

var projectsListByResourceGroup* = Call_ProjectsListByResourceGroup_594209(
    name: "projectsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects",
    validator: validate_ProjectsListByResourceGroup_594210, base: "",
    url: url_ProjectsListByResourceGroup_594211, schemes: {Scheme.Https})
type
  Call_ProjectsCreate_594232 = ref object of OpenApiRestCall_593426
proc url_ProjectsCreate_594234(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreate_594233(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594235 = path.getOrDefault("resourceGroupName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resourceGroupName", valid_594235
  var valid_594236 = path.getOrDefault("subscriptionId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "subscriptionId", valid_594236
  var valid_594237 = path.getOrDefault("projectName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "projectName", valid_594237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594238 = query.getOrDefault("api-version")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594238 != nil:
    section.add "api-version", valid_594238
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594239 = header.getOrDefault("Accept-Language")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "Accept-Language", valid_594239
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : New or Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_ProjectsCreate_594232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a project with specified name. If a project already exists, update it.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_ProjectsCreate_594232; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
  ## projectsCreate
  ## Create a project with specified name. If a project already exists, update it.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : New or Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  var body_594245 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_594245 = project
  add(path_594243, "projectName", newJString(projectName))
  result = call_594242.call(path_594243, query_594244, nil, nil, body_594245)

var projectsCreate* = Call_ProjectsCreate_594232(name: "projectsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsCreate_594233, base: "", url: url_ProjectsCreate_594234,
    schemes: {Scheme.Https})
type
  Call_ProjectsGet_594220 = ref object of OpenApiRestCall_593426
proc url_ProjectsGet_594222(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_594221(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the project with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594223 = path.getOrDefault("resourceGroupName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "resourceGroupName", valid_594223
  var valid_594224 = path.getOrDefault("subscriptionId")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "subscriptionId", valid_594224
  var valid_594225 = path.getOrDefault("projectName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "projectName", valid_594225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594226 = query.getOrDefault("api-version")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594226 != nil:
    section.add "api-version", valid_594226
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594227 = header.getOrDefault("Accept-Language")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "Accept-Language", valid_594227
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_ProjectsGet_594220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the project with the specified name.
  ## 
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_ProjectsGet_594220; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsGet
  ## Get the project with the specified name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  add(path_594230, "projectName", newJString(projectName))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_594220(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
                                        validator: validate_ProjectsGet_594221,
                                        base: "", url: url_ProjectsGet_594222,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_594258 = ref object of OpenApiRestCall_593426
proc url_ProjectsUpdate_594260(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_594259(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594261 = path.getOrDefault("resourceGroupName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "resourceGroupName", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  var valid_594263 = path.getOrDefault("projectName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "projectName", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594265 = header.getOrDefault("Accept-Language")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "Accept-Language", valid_594265
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   project: JObject
  ##          : Updated project object.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_ProjectsUpdate_594258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_ProjectsUpdate_594258; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"; project: JsonNode = nil): Recallable =
  ## projectsUpdate
  ## Update a project with specified name. Supports partial updates, for example only tags can be provided.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   project: JObject
  ##          : Updated project object.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  var body_594271 = newJObject()
  add(path_594269, "resourceGroupName", newJString(resourceGroupName))
  add(query_594270, "api-version", newJString(apiVersion))
  add(path_594269, "subscriptionId", newJString(subscriptionId))
  if project != nil:
    body_594271 = project
  add(path_594269, "projectName", newJString(projectName))
  result = call_594268.call(path_594269, query_594270, nil, nil, body_594271)

var projectsUpdate* = Call_ProjectsUpdate_594258(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsUpdate_594259, base: "", url: url_ProjectsUpdate_594260,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_594246 = ref object of OpenApiRestCall_593426
proc url_ProjectsDelete_594248(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_594247(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("subscriptionId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "subscriptionId", valid_594250
  var valid_594251 = path.getOrDefault("projectName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "projectName", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594253 = header.getOrDefault("Accept-Language")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "Accept-Language", valid_594253
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_ProjectsDelete_594246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_ProjectsDelete_594246; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsDelete
  ## Delete the project. Deleting non-existent project is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "resourceGroupName", newJString(resourceGroupName))
  add(query_594257, "api-version", newJString(apiVersion))
  add(path_594256, "subscriptionId", newJString(subscriptionId))
  add(path_594256, "projectName", newJString(projectName))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_594246(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}",
    validator: validate_ProjectsDelete_594247, base: "", url: url_ProjectsDelete_594248,
    schemes: {Scheme.Https})
type
  Call_ProjectsGetKeys_594272 = ref object of OpenApiRestCall_593426
proc url_ProjectsGetKeys_594274(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Migrate/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGetKeys_594273(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: JString (required)
  ##              : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594275 = path.getOrDefault("resourceGroupName")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "resourceGroupName", valid_594275
  var valid_594276 = path.getOrDefault("subscriptionId")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscriptionId", valid_594276
  var valid_594277 = path.getOrDefault("projectName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "projectName", valid_594277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594278 = query.getOrDefault("api-version")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = newJString("2018-02-02"))
  if valid_594278 != nil:
    section.add "api-version", valid_594278
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594279 = header.getOrDefault("Accept-Language")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "Accept-Language", valid_594279
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594280: Call_ProjectsGetKeys_594272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ## 
  let valid = call_594280.validator(path, query, header, formData, body)
  let scheme = call_594280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594280.url(scheme.get, call_594280.host, call_594280.base,
                         call_594280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594280, url, valid)

proc call*(call_594281: Call_ProjectsGetKeys_594272; resourceGroupName: string;
          subscriptionId: string; projectName: string;
          apiVersion: string = "2018-02-02"): Recallable =
  ## projectsGetKeys
  ## Gets the Log Analytics Workspace ID and Primary Key for the specified project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which project was created.
  ##   projectName: string (required)
  ##              : Name of the Azure Migrate project.
  var path_594282 = newJObject()
  var query_594283 = newJObject()
  add(path_594282, "resourceGroupName", newJString(resourceGroupName))
  add(query_594283, "api-version", newJString(apiVersion))
  add(path_594282, "subscriptionId", newJString(subscriptionId))
  add(path_594282, "projectName", newJString(projectName))
  result = call_594281.call(path_594282, query_594283, nil, nil, nil)

var projectsGetKeys* = Call_ProjectsGetKeys_594272(name: "projectsGetKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Migrate/projects/{projectName}/keys",
    validator: validate_ProjectsGetKeys_594273, base: "", url: url_ProjectsGetKeys_594274,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
